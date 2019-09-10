/***********第九、十章 描述性统计分析、参数估计与假设检验************/

/*********************************************************************
	*  添加saslib AWDW2016

libname saslib 'D:\00 SAS Data\Cache\saslib';
run;

libname AWDW2016 odbc datasrc=SQLSVR_AWDW2016
  user='Bran' pwd='BrandonXu@023' schema=dbo;
run;

libname TSQL2012 odbc datasrc=SQLSVR_TSQL2012
  user='Bran' pwd='BrandonXu@023' schema=sales;
run;
*********************************************************************/
;
/*********************************************************************
	*  

proc means data=saslib.Inventory mean std var cv range qrange 
	nolabels nonobs maxdec=2;
var Instock Price Cost;
run;
title 'saslib.Inventory';
proc print data=saslib.Inventory;
run;

proc means data=saslib.Inventory mean t prt clm cv ;
var Price;
class Instock; *若用by Instock notsorted，结果会按Instock输出多张报表;
run;
*********************************************************************/
;
/*********************************************************************
	* 

proc means data=sashelp.shoes mean median sum std chartype maxdec=2;
	title 'sashelp.shoes';
*	by region;
	var sales inventory;
	class region product;
	ways 2; 
	* 指定只输出2个分类变量组合的情况，等价于 types region*product;
	* 还可以指定nway选项指定只输出包含所有分类变量的情况;
	output out=work.test mean(sales)=sales_mean
						 sum(sales)=sales_sum
						 mean(inventory)=inventory_mean
						 sum(inventory)=inventory_sum
						/autolabel;
		label sales='Sales'
			  inventory='Inventory';
		format sales dollar15.2
			   inventory 10.2;
run;

proc datasets lib=work nolist;
	modify test;
	rename Sales_Mean=MeanOfSales;
	label MeanOfSales='Mean Of Sales';
quit;

title 'work.test';
proc print data=work.test;
run;
*********************************************************************/
;
/*********************************************************************
	*  

data work.test;
	set sashelp.fish;
	where species='Bream';
run;

proc univariate data=work.test plot;
	title'ProcUnivariate';
	var height;
	histogram /normal(color=(yellow black) mu=est sigma=est) kernel(c=1);
	inset skewness kurtosis/position=ne;  * ne 表示东南角;
run;
*********************************************************************/
;
/*********************************************************************
	*  

data work.test;
	set sashelp.fish;
	where species='Bream';
run;

proc means data=work.test maxdec=2 n nmiss mean std stderr clm alpha=0.03;
	title'ProcUnivariate';
	var height;
run;
*********************************************************************/
;
/*********************************************************************
	*  

proc univariate data=sashelp.fish normal alpha=0.05 mu0=15;
	where species='Bream';
	var height;
	probplot height /normal(mu=est sigma=est);
*	title'mu0=14';
run;

proc ttest data=sashelp.fish h0=14 plots(shownull)=interval;
	where species='Bream';
	var height;
	title'h0=14';
run;

*********************************************************************/
;
/*********************************************************************
	*  

proc univariate data=sashelp.heart alpha=0.05 mu0=137;
	var systolic;
	probplot /normal(mu=est sigma=est);
	histogram /normal(mu=est sigma=est) lognormal gamma 
		weibull exponential;
run;






*********************************************************************/
;
/*********************************************************************





*********************************************************************/
;
/*********************************************************************
*********************************************************************/
;
/*********************************************************************
