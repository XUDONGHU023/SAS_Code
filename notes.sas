/*libname saslib 'D:\00 SAS Data\Cache\saslib';*/
/*run;*/

/*proc contents data=saslib.inventory;*/
/*run;*/

/*proc print data=saslib.inventory noobs;*/
/*run;*/

/*ͨ��ODBC����SQL Server*/
/*libname test odbc datasrc=SQLSVR_AW2016 schema=Production;*/
/*run;*/

/*********************************************************************
	*�������� name / type / length / format / informat / label

data saslib.sales;
infile datalines dsd missover;
input Emp_ID $ Dept $ Sales Date;
  format Sales COMMA10. Date yymmdd10.;
  informat Sales dollar10. Date date9.;
  label Emp_ID='Ա��ID' Dept='����' Sales='��������' Date='����ʱ��';
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
	*  ���뷽ʽ flowover / missover / truncover / stopover
	*  "D:\00 SAS Data\Cache\test.txt" �������£�
	*  1
	*  22
	*  333
	*  4444
	*  55555
	*  
	*  --ע�⣬���ļ��ж�ȡ���datalines�ж�ȡ��������ģ�
	*  --����datalines�ж�ȡʱ��flowover�Ȳ�������Ч�ģ���
	*  --��������ʾ����
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
	*  ����options obs;
options obs=20;
title '���ݼ�ѡ��obs=��Ч��ӡǰ5���۲�';
proc print data=sashelp.shoes (obs=5);
run;
title 'ϵͳѡ��obs=��Ч��ӡ��11-20���۲�';
proc print data=sashelp.shoes (firstobs=11);
run;

	*  �鿴ϵͳѡ��ֵ(����־�����);
proc options option=obs value;
run;
*********************************************************************/




