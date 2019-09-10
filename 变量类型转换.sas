/*windows xp系统sas9.13下测试可用。
功能：
1.出所有的纯数字的字符类型变量并将其转化为数值变量
2.将转化后的数据集以原始数据集的顺序存储
3.找出所有进行过转化的变量的变量名、位置、标签名等存储到chavn数据集中
*/

%macro d(data=,out=&data,chavn=);
/*data为需转换的数据集名，如果不在work库中，需给出逻辑库名称，如“sasuser.jd”。
out是转换后的数据集名，不指定默认替换原始数据集，为求保险不推荐使用替换原始数据集的方式。
chavn是规定将所有含有非数值字符的字符型变量名输出到chavn数据集中，此数据集含有原始变量名，变量在out中的位置及标签名,这只是为了查看到底哪些变量进行了转换，可以省略 。
*/
%let data=%upcase(&data);
%let a=%scan(&data,1,'.');
%let b=%scan(&data,2,'.');
%if &b= %then %do;
        %let a=WORK;
        %let b=&data;
        %let data=WORK.&b;
%end;/*分别取库名及数据集名称，a为库名，b为集名*/

data _TMP_;
set &data;
run;/*保留原始数据集，特别是在out不等于data时，保留原始数据在工作中很重要。*/

proc sql noprint ;
select upcase(name) into :var separated by ' '
from dictionary.columns
where libname="&a" and memname="&b";
quit;
/*取原始数据中变量的顺序，将变量依照原始顺序存入宏变量var。使转换后仍按此顺序排列*/


proc sql ;
create table char as
select * from &data (keep= _character_ );
run;/*取原始数据集中所有字符变量组成数据集*/

proc contents data=char position out=content(keep=name varnum) noprint;
run;/*取字符型数据集中变量名*/

proc sort data=content;
by varnum;
proc sql noprint;
select name into: name separated by ' '
from content order by varnum;
select 'T_'||compress(name)||'_1' into: name_1 separated by ' '
from content order by varnum;
quit;/*将字符型数据集中的变量名按序存入name宏变量，同时产生两列新变量用于存放中间结果*/

%let s=&sqlObs;/*sqlobs是指sql步骤中的读入的记录数。此处赋值给宏变量s，因为后面还有sql步。
也可将“select name into: name separated by ' '”改为“select name，count(*) into: name separated by ' ',: s”*/


        DATA _Tmp_;
        set _TMP_;
        %do i=1 %to &sqlobs ;
    %let cha&i=%scan(&name,&i);        /*cha&i变量读入原始变量。*/
    %let rr&I=%scan(&name_1,&i);        /*rr&i变量作为判断是否为字符的中间变量。0为数值，1为字符。*/
        &&rr&i=0;
        if compress(&&cha&I)='' then &&rr&i+0;
        else do;
                if compress(&&cha&i,'.','d')=''  then &&rr&i+0;else &&rr&i+1;
        end;
    %end;
        RUN;

%do i=1 %to &sqlobs;
proc sql noprint ;
select max(&&rr&i) into :r&i
from _TMP_;
quit;
%end;/*计算各rr&i的最大值。*/

data _TMP_;
set _TMP_;
%let str=;
%do i=1 %to &s;
        %if &&r&i=0 %then %do;  
          %let e=%scan(&name,&i);
          %let e1=T_&e._2;
          &e1=&e*1;
          drop &e;
          rename &e1=&e;
        %end;
        %if &&r&i>0 %then %do;
        /*%put "含非数值的字符变量有：" %scan(&name,&i);*/
        %let str=&str. %scan(&name,&i);
        %end;
%end;
run;/*rr&i为0则转换变量类型，反之将所有的变量名以空格间隔输出到str宏变量中。*/

data _TMP_; set _TMP_;
drop  &name_1;
run;/*去掉宏变量rr&i所产生的所有变量。*/

data &out;
retain &var;
set _TMP_;
run;/*以原始顺序排列变量*/

proc delete data=char content _tmp_;
run;

%if &chavn^= %then %do;
proc contents data=&out(keep=&str) position out=&chavn(keep=name varnum label) noprint;
run;%end;

/*显示未转换的字符变量，需注意其中有的可能只有几个观测含有非数值字符，这种要自己转换*/
%put "不是全部都是数值的字符变量，如全为字母汉字或含有“<0.002”，此类变量为转换：";
%put &str;

%mend;
/*此程序基本满足我所说的要求：
1.全部转换；
2.转数不转值；
3变量名及顺序不变（即除了变量类型变其他都不变。）
4.将不能转的变量列出，方便查看哪些是部分记录含有字符的变量。
最好能多一个宏参数使含字符值记录小于该限的输出，而不输出全部的含非数值的字符变量（如10000条记录中尿微量白蛋白可能有1000条是显示“<0.02”，那么这一个宏参数“0.5”就会把那些50%以上记录都是非数值的变量去掉，如此就会把一些变量如住址【基本都含数值】去掉不显示出来。而一些仅小部分记录含非数值内容的变量保留。）

另此宏的缺点：
1.如前所述缺一参数，我不打算加了。
2.宏中会用到两个中间数据库：cha、_TMP_与content。使用前必须保证work中不含同名数据库才行。
3.宏中使用了中间变量名'T_"原变量名"_1'、'T_"原变量名"_2'如果数据集中有同名变量的话会覆盖，建议事前查看好，事后注意原始数据库中的变量数与最终库中的变量数是否相等，不等说明有问题，只能麻烦先手改再用了。不过由于事先考虑到这个问题中间变量都是前面加“T_”、后面加"_1"/"_2",按理不会出现重名的情况。
4.还是老问题效率效率。
恳请牛人支援！！！！！
dahufa
2009.10.2 2pm
*/



/*下面是使用该宏的一个实例
%d(data=d.jd1,out=j,CHAVN=R);
或
%d(data=d.jd1,out=j);
*/
