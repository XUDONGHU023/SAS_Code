/*********************************************************************
	*  libname
libname saslib 'D:\00 SAS Data\Cache\saslib';
run;
*********************************************************************/
;
/*********************************************************************
	*  DATA������saslib.Inventory����ֵ���Cost=�������Cost��ֵ

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
	*  ���ݼ����Լ���Ϣ

proc contents data=saslib.inventory;
run;
proc print data=saslib.inventory noobs;
run;
*********************************************************************/
;
/*********************************************************************
	*  ͨ��ODBC����SQL Server

libname test odbc datasrc=SQLSVR_AW2016 schema=Production;
run;
*********************************************************************/
;
/*********************************************************************
	*  �������� name / type / length / format / informat / label 

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
;
/*********************************************************************
	*  ���뷽ʽ flowover / missover / truncover / stopover
	*  "D:\00 SAS Data\Cache\flowover.txt" �������£�
	*  1
	*  22
	*  333
	*  4444
	*  55555
	*  
	*  ע�⣺���ļ��ж�ȡ���datalines�ж�ȡ��������ģ�����datalines
	*        �ж�ȡʱ��flowover�Ȳ�������Ч�ģ�����������ʾ����
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
	*  ����options obs;
	*  �鿴ϵͳѡ��ֵ(����־�����)

options obs=20;
title '���ݼ�ѡ��obs=��Ч��ӡǰ5���۲�';
proc print data=sashelp.shoes (obs=5);
run;
title 'ϵͳѡ��obs=��Ч��ӡ��11-20���۲�';
proc print data=sashelp.shoes (firstobs=11);
run;

proc options option=obs value;
run;
*********************************************************************/
;
/*********************************************************************
	*  1��DLMѡ��ָ���ָ���
	*  
	*  2��DSDѡ�������3���£�
	*      a ��������������������ģ�������ֵ�еķָ����������ݵ�һ��
	*        �֣��ַ�ֵ���˵�ƥ������Ŷ��ڶ���ʱ�ᱻɾ�������ַ�ֵ��
	*        �Ĳ�ƥ������Ž����������ݵ�һ���֣�
	*      b ��Ĭ�ϵķָ�������Ϊ����(�б�����Ĭ�Ϸָ����ǿո�)
	*      c ����������ķָ���������Ӧλ�ý�������ȱʧֵ
	*  
	*  ע�⣺DLM='ab' �ǽ�a��b�ֱ𶼵����ָ�����DLMSTR='ab' �ǽ� ab��
	*        ���ָ���
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

	*  filenameָ���ⲿ�ļ��洢λ�� "D:\00 SAS Data\Cache" 
	*  ԭʼ�����ļ�customer2.dat�������£�
	*  C001  Willam Smith   22OCT1970
	*  C002  Emily Cooker   01JAN1978
	*  C003  Geroge Collin  09MAR1968
	*  C005  Jimmy Cruze    25JUN1972
	*  
	*  �������η� & : ~ ��ʹ�����η�ʱ�����������뷽ʽΪ�б����롿
	*  
	*  & ��������ֵ�е����ո���ַ�ֵ���������������ո��ﵽ���峤��
	*    ��ֹͣ���롣�����������������ո�ֹͣ�����ָ���������ո�֮
	*    ���λ�á�
	*  
	*  : �����ڱ�������ָ�������ʽ���������뷽ʽ��Ϊ�б����룬������
	*    ��ʽ���롿
	*  
	*  ~ ������DSDѡ��һ��ʹ�ã�ֻ�Ƕ�������������������ʱ��ȥ�����ţ�
	*    ������DSDһ��ʹ�ã�ִ��ʱ�ᱻ����
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

	*  ��� _NOTS_SAS format modifier�����η���.txt
*********************************************************************/
;






