/*libname saslib 'D:\00 SAS Data\Cache\saslib';*/
/*run;*/

/*proc contents data=saslib.inventory;*/
/*run;*/

/*proc print data=saslib.inventory noobs;*/
/*run;*/

/*通过ODBC连接SQL Server*/
/*libname test odbc datasrc=SQLSVR_AW2016 schema=Production;*/
/*run;*/

/*********************************************************************
	*变量属性 name / type / length / format / informat / label

data saslib.sales;
infile datalines dsd missover;
input Emp_ID $ Dept $ Sales Date;
  format Sales COMMA10. Date yymmdd10.;
  informat Sales dollar10. Date date9.;
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

/*********************************************************************
	*  读入方式 flowover / missover / truncover / stopover
	*  "D:\00 SAS Data\Cache\test.txt" 数据如下：
	*  1
	*  22
	*  333
	*  4444
	*  55555
	*  
	*  --注意，从文件中读取与从datalines中读取是有区别的，
	*  --当从datalines中读取时，flowover等参数是无效的，但
	*  --并不会提示错误。
;
data numbers;
infile "D:\00 SAS Data\Cache\test.txt" flowover;
input temp 5.;
run;
title 'truncover';
proc print data=numbers;
run;
*********************************************************************/

/*********************************************************************
	*  设置options obs;
options obs=20;
title '数据集选项obs=生效打印前5条观测';
proc print data=sashelp.shoes (obs=5);
run;
title '系统选项obs=生效打印第11-20条观测';
proc print data=sashelp.shoes (firstobs=11);
run;

	*  查看系统选项值(在日志中输出);
proc options option=obs value;
run;
*********************************************************************/




