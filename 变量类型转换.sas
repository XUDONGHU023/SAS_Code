/*windows xpϵͳsas9.13�²��Կ��á�
���ܣ�
1.�����еĴ����ֵ��ַ����ͱ���������ת��Ϊ��ֵ����
2.��ת��������ݼ���ԭʼ���ݼ���˳��洢
3.�ҳ����н��й�ת���ı����ı�������λ�á���ǩ���ȴ洢��chavn���ݼ���
*/

%macro d(data=,out=&data,chavn=);
/*dataΪ��ת�������ݼ������������work���У�������߼������ƣ��硰sasuser.jd����
out��ת��������ݼ�������ָ��Ĭ���滻ԭʼ���ݼ���Ϊ���ղ��Ƽ�ʹ���滻ԭʼ���ݼ��ķ�ʽ��
chavn�ǹ涨�����к��з���ֵ�ַ����ַ��ͱ����������chavn���ݼ��У������ݼ�����ԭʼ��������������out�е�λ�ü���ǩ��,��ֻ��Ϊ�˲鿴������Щ����������ת��������ʡ�� ��
*/
%let data=%upcase(&data);
%let a=%scan(&data,1,'.');
%let b=%scan(&data,2,'.');
%if &b= %then %do;
        %let a=WORK;
        %let b=&data;
        %let data=WORK.&b;
%end;/*�ֱ�ȡ���������ݼ����ƣ�aΪ������bΪ����*/

data _TMP_;
set &data;
run;/*����ԭʼ���ݼ����ر�����out������dataʱ������ԭʼ�����ڹ����к���Ҫ��*/

proc sql noprint ;
select upcase(name) into :var separated by ' '
from dictionary.columns
where libname="&a" and memname="&b";
quit;
/*ȡԭʼ�����б�����˳�򣬽���������ԭʼ˳���������var��ʹת�����԰���˳������*/


proc sql ;
create table char as
select * from &data (keep= _character_ );
run;/*ȡԭʼ���ݼ��������ַ�����������ݼ�*/

proc contents data=char position out=content(keep=name varnum) noprint;
run;/*ȡ�ַ������ݼ��б�����*/

proc sort data=content;
by varnum;
proc sql noprint;
select name into: name separated by ' '
from content order by varnum;
select 'T_'||compress(name)||'_1' into: name_1 separated by ' '
from content order by varnum;
quit;/*���ַ������ݼ��еı������������name�������ͬʱ���������±������ڴ���м���*/

%let s=&sqlObs;/*sqlobs��ָsql�����еĶ���ļ�¼�����˴���ֵ�������s����Ϊ���滹��sql����
Ҳ�ɽ���select name into: name separated by ' '����Ϊ��select name��count(*) into: name separated by ' ',: s��*/


        DATA _Tmp_;
        set _TMP_;
        %do i=1 %to &sqlobs ;
    %let cha&i=%scan(&name,&i);        /*cha&i��������ԭʼ������*/
    %let rr&I=%scan(&name_1,&i);        /*rr&i������Ϊ�ж��Ƿ�Ϊ�ַ����м������0Ϊ��ֵ��1Ϊ�ַ���*/
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
%end;/*�����rr&i�����ֵ��*/

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
        /*%put "������ֵ���ַ������У�" %scan(&name,&i);*/
        %let str=&str. %scan(&name,&i);
        %end;
%end;
run;/*rr&iΪ0��ת���������ͣ���֮�����еı������Կո��������str������С�*/

data _TMP_; set _TMP_;
drop  &name_1;
run;/*ȥ�������rr&i�����������б�����*/

data &out;
retain &var;
set _TMP_;
run;/*��ԭʼ˳�����б���*/

proc delete data=char content _tmp_;
run;

%if &chavn^= %then %do;
proc contents data=&out(keep=&str) position out=&chavn(keep=name varnum label) noprint;
run;%end;

/*��ʾδת�����ַ���������ע�������еĿ���ֻ�м����۲⺬�з���ֵ�ַ�������Ҫ�Լ�ת��*/
%put "����ȫ��������ֵ���ַ���������ȫΪ��ĸ���ֻ��С�<0.002�����������Ϊת����";
%put &str;

%mend;
/*�˳��������������˵��Ҫ��
1.ȫ��ת����
2.ת����תֵ��
3��������˳�򲻱䣨�����˱������ͱ����������䡣��
4.������ת�ı����г�������鿴��Щ�ǲ��ּ�¼�����ַ��ı�����
����ܶ�һ�������ʹ���ַ�ֵ��¼С�ڸ��޵�������������ȫ���ĺ�����ֵ���ַ���������10000����¼����΢���׵��׿�����1000������ʾ��<0.02������ô��һ���������0.5���ͻ����Щ50%���ϼ�¼���Ƿ���ֵ�ı���ȥ������˾ͻ��һЩ������סַ������������ֵ��ȥ������ʾ��������һЩ��С���ּ�¼������ֵ���ݵı�����������

��˺��ȱ�㣺
1.��ǰ����ȱһ�������Ҳ�������ˡ�
2.���л��õ������м����ݿ⣺cha��_TMP_��content��ʹ��ǰ���뱣֤work�в���ͬ�����ݿ���С�
3.����ʹ�����м������'T_"ԭ������"_1'��'T_"ԭ������"_2'������ݼ�����ͬ�������Ļ��Ḳ�ǣ�������ǰ�鿴�ã��º�ע��ԭʼ���ݿ��еı����������տ��еı������Ƿ���ȣ�����˵�������⣬ֻ���鷳���ָ������ˡ������������ȿ��ǵ���������м��������ǰ��ӡ�T_���������"_1"/"_2",��������������������
4.����������Ч��Ч�ʡ�
����ţ��֧Ԯ����������
dahufa
2009.10.2 2pm
*/



/*������ʹ�øú��һ��ʵ��
%d(data=d.jd1,out=j,CHAVN=R);
��
%d(data=d.jd1,out=j);
*/
