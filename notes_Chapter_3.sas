/*********************第三章 对单个数据集的处理**********************/

/*********************************************************************
	*  添加saslib AWDW2016

libname saslib 'D:\00 SAS Data\Cache\saslib';
run;

libname AWDW2016 odbc datasrc=SQLSVR_AWDW2016
  user='Bran' pwd='BrandonXu@023' schema=dbo;
run;
*********************************************************************/
;
/*********************************************************************
	*  比较操作符 eq(=) ne(^=) gt(>) lt(<) ge(>=) le(<=) in(包含于)
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
	*  操作所选取的观测
	*  此时只操作PDV中的值，并写入新数据集，原数据集中的数据不变
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
	*  操作所选取的观测
	*  此时只操作PDV中的值，并写入新数据集，原数据集中的数据不变
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
	*  接上条
	*  将work.test按descending Instock排序
	*  再将排序后的work.test按Instock分组读入work.test2中
	*  分组变量每组的起止条观测会被标记到first、last
	*  添加if first.Instock = last.Instock;可按分组变量筛选出唯一值
	*  
	*  注意，分组前必须先排序，且分组变量指定的排序规则必须与原数据相
	*		 同，如本条程序sort过程和data步的by语句必须相同
	*  
	*  另外，可以在by语句中指定notsorted参数，不要求排序，但是系统会默
	*        认数据集中每个by组合按观测号是连续的，如果数据集中by组合
	*        取值相同的观测不按观测号连续排列，系统会认为他们分别是不
	*        同的by组合
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
	*  用求和语句计算每个by组的和（透视），并输出到多个文件
	*  注意求和语句与赋值语句的区别：在迭代过程中，若遇到缺失值的表达
	*      式，求和语句'变量+表达式'会将缺失值当0处理，而赋值语句'变量
	*      =变量+表达式'会使最终结果为缺失值。
	*  
	*  本条程序中也可采用retain语句：
	*      retain Total_Sales_Subsidiary 0; 
	*      Total_Sales_Subsidiary=Total_Sales_Subsidiary+Sales;
	*  实现，但必须确保Sales中不含缺失值，否则最终结果会是缺失值。可以
	*  添加sum函数解决包含缺失值的问题：
	*      retain Total_Sales_Subsidiary 0; 
	*      Total_Sales_Subsidiary=sum(Total_Sales_Subsidiary,Sales);
	*  sum函数只有当所有参数都为缺失值时才返回缺失值，否则返回所有参数
	*  中非缺失值的和。
	*  
	*  所以，求和语句等效于retain语句和sum函数的组合
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





