/*********************������ �Ե������ݼ��Ĵ���**********************/

/*********************************************************************
	*  ���saslib AWDW2016

libname saslib 'D:\00 SAS Data\Cache\saslib';
run;

libname AWDW2016 odbc datasrc=SQLSVR_AWDW2016
  user='Bran' pwd='BrandonXu@023' schema=dbo;
run;
*********************************************************************/
;
/*********************************************************************
	*  �Ƚϲ����� eq(=) ne(^=) gt(>) lt(<) ge(>=) le(<=) in(������)
	*  
	*  

data test;
input COL1 COL2;
	COL1_EQ_COL2 = (COL1 eq COL2);
	COL1_NE_COL2 = (COL1 ne COL2);
	COL1_GT_COL1 = (COL1 gt COL2);
	COL1_LT_COL1 = (COL1 lt COL2);
	COL1_GE_COL1 = (COL1 ge COL2);
	COL1_LE_COL1 = (COL1 le COL2);
	COL2_IN_567  =  COL2 in( 5:7 );
datalines;
5 4
5 5
5 6
;
proc print data=test;
run;
*********************************************************************/
;
/*********************************************************************
	*  ������ѡȡ�Ĺ۲�
	*  ��ʱֻ����PDV�е�ֵ����д�������ݼ���ԭ���ݼ��е����ݲ���
	*

data work.test;
	set saslib.Inventory;
	if Instock < 20 then
		do
			Instock = 20;
		end;
	else 
		do
			Instock = 100;
		end;
run;
title 'work.test';
proc print data=work.test;
run;
title 'saslib.Inventory';
proc print data=saslib.Inventory;
run;
*********************************************************************/
;
/*********************************************************************
	*  ������ѡȡ�Ĺ۲�
	*  ��ʱֻ����PDV�е�ֵ����д�������ݼ���ԭ���ݼ��е����ݲ���
	*  

data work.test;
	set saslib.Inventory;
	select (substr(Prodcut_ID,length(Prodcut_ID),1));
		when ('R') Price = 100;
		when ('T') Price = 80;
		when ('M') Price = 300;
		otherwise;
	end;
run;
title 'saslib.Inventory';
proc print data=saslib.Inventory;
run;
title 'work.test';
proc print data=work.test;
run;
*********************************************************************/
;
/*********************************************************************
	*  ������
	*  ��work.test��descending Instock����
	*  �ٽ�������work.test��Instock�������work.test2��
	*  �������ÿ�����ֹ���۲�ᱻ��ǵ�first��last
	*  ���if first.Instock = last.Instock;�ɰ��������ɸѡ��Ψһֵ
	*  
	*  ע�⣬����ǰ�����������ҷ������ָ����������������ԭ������
	*		 ͬ���籾������sort���̺�data����by��������ͬ
	*  
	*  ���⣬������by�����ָ��notsorted��������Ҫ�����򣬵���ϵͳ��Ĭ
	*        �����ݼ���ÿ��by��ϰ��۲���������ģ�������ݼ���by���
	*        ȡֵ��ͬ�Ĺ۲ⲻ���۲���������У�ϵͳ����Ϊ���Ƿֱ��ǲ�
	*        ͬ��by���
	*        
	*        

proc sort data=work.test;
	by descending Instock;        *by descending Instock notsorted;

data work.test2;
	set work.test;
	by descending Instock;
*	if first.Instock = last.Instock;
run;
title 'work.test2';
proc print data=work.test2;
run;
*********************************************************************/
;
/*********************************************************************
	*  �����������ÿ��by��ĺͣ�͸�ӣ��������������ļ�
	*  ע���������븳ֵ���������ڵ��������У�������ȱʧֵ�ı��
	*      ʽ��������'����+���ʽ'�Ὣȱʧֵ��0��������ֵ���'����
	*      =����+���ʽ'��ʹ���ս��Ϊȱʧֵ��
	*  
	*  ����������Ҳ�ɲ���retain��䣺
	*      retain Total_Sales_Subsidiary 0; 
	*      Total_Sales_Subsidiary=Total_Sales_Subsidiary+Sales;
	*  ʵ�֣�������ȷ��Sales�в���ȱʧֵ���������ս������ȱʧֵ������
	*  ���sum�����������ȱʧֵ�����⣺
	*      retain Total_Sales_Subsidiary 0; 
	*      Total_Sales_Subsidiary=sum(Total_Sales_Subsidiary,Sales);
	*  sum����ֻ�е����в�����Ϊȱʧֵʱ�ŷ���ȱʧֵ�����򷵻����в���
	*  �з�ȱʧֵ�ĺ͡�
	*  
	*  ���ԣ��������Ч��retain����sum���������
	*  


data work.shoes_subsidiary (drop=Sales) 
	 work.shoes_regions (drop=Subsidiary Sales Total_Sales_Subsidiary);
	set sashelp.shoes (keep= Region Subsidiary Sales);
	by Region Subsidiary;

	if first.Subsidiary then Total_Sales_Subsidiary = 0;
	if first.Region then Total_Sales_Region = 0;
	
	Total_Sales_Subsidiary + Sales;
	Total_Sales_Region + Sales;

	if last.subsidiary then output work.shoes_subsidiary;
	if last.Region then	output work.shoes_regions;

	format Total_Sales_Subsidiary dollar13.2;
	format Total_Sales_Region dollar13.2;
run;
title 'work.shoes_subsidiary';
proc print data=work.shoes_subsidiary;
run;
title 'work.shoes_regions';
proc print data=work.shoes_regions;
run;
*********************************************************************/
;
/*********************************************************************
/**/
proc means data=saslib.Inventory mean std var cv range qrange maxdec=2;
var Instock Price Cost;
run;

proc print data=saslib.Inventory;
run;




*********************************************************************/
;
/*********************************************************************








*********************************************************************/
;
/*********************************************************************








*********************************************************************/
;





