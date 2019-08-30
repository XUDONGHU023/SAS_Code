/*******************第二章 读取外部数据到SAS数据集*******************/

/*********************************************************************
	*  libname

libname saslib 'D:\00 SAS Data\Cache\saslib';
run;
*********************************************************************/
;
/*********************************************************************
	*  DATA步生成saslib.Inventory，赋值语句Cost=计算变量Cost的值

data saslib.Inventory;
input Prodcut_ID $ Instock Price;
Cost=Price*0.15;
datalines;
P001R 12 125.00
P003T 34 40.00
P301M 23 500.00
PC02M 12 100.00
;
run;
*********************************************************************/
;
/*********************************************************************
	*  数据集属性及信息

proc contents data=saslib.inventory;
run;
proc print data=saslib.inventory noobs;
run;
*********************************************************************/
;
/*********************************************************************
	*  通过ODBC连接SQL Server

libname test odbc datasrc=SQLSVR_AW2016 schema=Production;
run;
*********************************************************************/
;
/*********************************************************************
	*  变量属性 name / type / length / format / informat / label 

data saslib.sales;
infile datalines dsd missover;
input Emp_ID $ Dept $ Sales dollar10. Date date9.;
  format Sales COMMA10. Date yymmdd10.;
  *informat Sales dollar10. Date date9.;
  label Emp_ID='员工ID' Dept='部门' Sales='销售数据' Date='销售时间';
datalines;
ET001,TSG,$10000,01JAN2012
ED002,,$12000,01FEB2012
EC002,CSG,$23000,01APR2012
ED004,QSG,,01AUG2012
;
run;
proc contents data=saslib.sales;
run;
proc print data=saslib.sales noobs label;
run;
*********************************************************************/
;
/*********************************************************************
	*  读入方式 flowover / missover / truncover / stopover
	*  "D:\00 SAS Data\Cache\flowover.txt" 数据如下：
	*  1
	*  22
	*  333
	*  4444
	*  55555
	*  
	*  注意：从文件中读取与从datalines中读取是有区别的，当从datalines
	*  中读取时，flowover等参数是无效的，但并不会提示错误。
	*  

data numbers;
infile "D:\00 SAS Data\Cache\flowover.txt" flowover;
input temp 5.;
run;
title 'truncover';
proc print data=numbers;
run;
*********************************************************************/
;
/*********************************************************************
	*  设置options obs;
	*  查看系统选项值(在日志中输出)

options obs=20;
title '数据集选项obs=生效打印前5条观测';
proc print data=sashelp.shoes (obs=5);
run;
title '系统选项obs=生效打印第11-20条观测';
proc print data=sashelp.shoes (firstobs=11);
run;

proc options option=obs value;
run;
*********************************************************************/
;
/*********************************************************************
	*  1）DLM选项指定分隔符
	*  
	*  2）DSD选项完成了3件事：
	*a 如果数据是引号引起来的，将数据值中的分隔符当成数据的一部
	*  分，字符值两端的匹配的引号对在读入时会被删除（但字符值中
	*  的不匹配的引号将被当成数据的一部分）
	*b 将默认的分隔符设置为逗号(列表输入默认分隔符是空格)
	*c 如果有连续的分隔符，则相应位置将被当作缺失值
	*  
	*  注意：DLM='ab' 是将a、b分别都当作分隔符，DLMSTR='ab' 是将 ab当
	*  作分隔符
	*  

data saslib.customer;
length Name $20 Address $40;
infile datalines dlm=',' dsd;
input Customer_ID $ Name $ Address $;
datalines;
C001,,"14 Bridge 'St. San Francisco', CA"
C002,Enily Cooker,"42 Rue Marston"
C003,,"52 Rue Marston Paris"
C005,Jimmy Cruze,"Box 100 Cary, NC"
;
run;
proc print data=saslib.customer noobs;
run;
*********************************************************************/
;
/*********************************************************************

	*  filename指定外部文件存储位置 "D:\00 SAS Data\Cache" 
	*  原始数据文件customer2.dat内容如下：
	*  C001  Willam Smith   22OCT1970
	*  C002  Emily Cooker   01JAN1978
	*  C003  Geroge Collin  09MAR1968
	*  C005  Jimmy Cruze    25JUN1972
	*  
	*  三个修饰符 & : ~ 【使用修饰符时，变量的输入方式为列表输入】
	*  
	*  & 读入数据值中单个空格的字符值，遇到两个连续空格或达到定义长度
	*    即停止读入。【若遇到两个连续空格，停止读入后指针在两个空格之
	*    后的位置】
	*  
	*  : 可以在变量名后指定输入格式，【但输入方式仍为列表输入，而不是
	*    格式输入】
	*  
	*  ~ 必须与DSD选项一起使用，只是读入引号引起来的数据时不去掉引号，
	*    若不与DSD一起使用，执行时会被忽略
	*  
	*  
filename extfiles 'D:\00 SAS Data\Cache';
data saslib.customer2;
infile datalines dlm=' ';
*infile extfiles(customer2);
input Customer_ID $ Name & $20. Birth_Date:date9.;
format Birth_Date date9.;
datalines;
C001  Willam Smith   22OCT1970
C002  Emily Cooker   01JAN1978
C003  Geroge Collin  09MAR1968
C005  Jimmy Cruze    25JUN1972
;
run;
proc print data=saslib.customer2 noobs;
run;

	*  详见 _NOTS_SAS format modifier（修饰符）.txt
*********************************************************************/
;
/*********************************************************************
	*  test_line_hold_specifier
	*  注意，第二个input时要重新指定列指针位置，因为第一个input完成后
	*  列指针在第10列

data saslib._test_line_hold_specifier_sales;
infile datalines;
input Dept $7-9 @;
if Dept='TSG';
input Emp_ID $1-5 +5 Sales comma6. @22 Date date9.;
format Date yymmdd10.;
datalines;
ET001 TSG $10000     01JAN2012
ED002     $12000     01FEB2012
ET004 TSG $500002MAR2012
EC002 CSG $23000     01APR2012
ED004 QSG01AUG2012
;
run;
proc print data=saslib._test_line_hold_specifier_sales noobs;
run;
*********************************************************************/
;
/*********************************************************************
	*  test_line_hold_specifier_2

data saslib._test_line_hold_specifier_Inv;
infile datalines;
input Product_ID $ Instock Price @@;
format Price dollar10.2;
datalines;
P001R 12 125.00 P003T 34 40.00
P301M 23 500.00 PC02M 12 100.00
;
run;
proc print data=saslib._test_line_hold_specifier_Inv noobs;
run;
*********************************************************************/
;
/*********************************************************************
	*  通过ODBC引擎链接SQLSVR数据库

libname AWDW2016 odbc datasrc=SQLSVR_AWDW2016
  user='Bran' pwd='BrandonXu@023' schema=dbo;
run;
*********************************************************************/
;
/*********************************************************************
	*  将SQL查询存储为逻辑库中的SQL视图
	*  
	*  

libname proc_sql 'D:\00 SAS Data\Cache\lib_proc_sql';

proc sql;
	connect to ODBC (datasrc=SQLSVR_AWDW2016 user='Bran' pwd='BrandonXu@023');
		create view proc_sql.awdw2016_dbo_dimproduct as select * from connection to odbc
			(select [ProductAlternateKey]
				,[EnglishProductName]
				,[StandardCost]
				,[Color]
				,[SafetyStockLevel]
				,[ReorderPoint]
				,[ListPrice]
				,[Size]
				,[SizeRange]
				,[Weight]
			 from [AdventureworksDW2016CTP3].[dbo].[DimProduct]
			);
	disconnect from odbc;
quit;
*********************************************************************/
;

