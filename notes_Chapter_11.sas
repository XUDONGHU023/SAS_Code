/*************************第十一章 方差分析**************************/

/*********************************************************************
	*  

/**/
data work.relieftime;
	input medicine $ hours @@;
datalines;
A 7 A 5 A 3 A 1
B 6 B 5 B 3 B 3
C 7 C 9 C 9 C 9
D 4 D 3 D 4 D 3
;
run;

proc means data=work.relieftime mean cv stderr std maxdec=3;
	var hours;
run;

proc univariate data=work.relieftime;
	var hours;
*	class medicine;
	histogram /normal(mu=est sigma=est);                    * 正态拟合;
run;

proc glm data=work.relieftime alpha=0.05 plots=diagnostics; * diagnostics选项生成拟合诊断图;
	class medicine;
	model hours=medicine;                                   * 分析模型;
	means medicine /hovtest;                                * 输出均值，hovtest检验方差齐性;
	lsmeans medicine /pdiff=all;                            * pdiff选项输出水平间差异;
run;
quit;

proc glm data=work.relieftime alpha=0.05;                   * 对比上条过程，输出图像差异;
	class medicine;
	model hours=medicine;
	lsmeans medicine /pdiff=all;
run;
quit;

*********************************************************************/
;
/*********************************************************************
	*  
/**/
* 分布拟合;
proc univariate data=sashelp.class;
	var height;
*	class sex;
	histogram /normal(mu=est sigma=est);
run;


* 方差齐性检验;
proc ttest data=sashelp.class plot(shownull)=interval;
*	class sex;              * class 变量只能有2个取值，所以只能做双样本方差齐性检验;
	var height;
run;
proc glm data=sashelp.class alpha=0.05 plots;
	class sex;              * class 变量可以有多个取值;
	model height=sex;
	means sex /hovtest;     * hovtest 选项检测方差齐性，means 因素必须出现在model-;
							* -中但方差齐性检验只能在单因素模型下使用，对比下条过程;
run;
quit;


* 无交互作用的双因素实验方差分析;
proc glm data=sashelp.class alpha=0.05;
	class age sex;                     * class 可以有多个变量;
	model height=age sex age*sex;      * age*sex 判断age和sex是否交互作用，H0=没有交互作用;
	means age sex;                     * 此时不能指定 hovtest，只能在单因素模型使用;
run;
	* 以上结果显示显著水平只有age，继续使用lsmeans分析age的水平间差异;
	lsmeans age /pdiff=all;            * glm 支持交互性，会一直在后台运行，直至遇到下一个-;
									   * -proc步、data步或quit语句;
	* 注意，此例数据不是均衡的，应使用lsmeans计算的均值，与means计算的均值不相等;
run;
quit;


* 有交互作用的双因素实验方差分析;
data work.fruit;
	input humidity $ temperature $ output_lbs @@;
	datalines;
	A1 B1 58.2   A1 B1 52.6
	A1 B2 56.2   A1 B2 41.2
	A1 B3 65.3   A1 B3 60.0
	A2 B1 49.1   A2 B1 42.8
	A2 B2 54.1   A2 B2 50.5
	A2 B3 51.6   A2 B3 48.4
	A3 B1 60.1   A3 B1 58.3
	A3 B2 70.9   A3 B2 73.2
	A3 B3 39.2   A3 B3 40.7
;
run;

proc univariate data=work.fruit alpha=0.05;
	var output_lbs;
	histogram /normal(mu=est sigma=est) kernel;
	probplot /normal(mu=est sigma=est);
run;

proc glm data=work.fruit alpha=0.05;
	class humidity temperature;
	model output_lbs=humidity temperature humidity*temperature;
run;
		* humidity 的 PrF < alpha=0.05，认为 humidity 是显著因素;
		* humidity*temperature 的 PrF < alpha=0.05，认为有交互作用;
	lsmeans humidity*temperature /slice=humidity;
		* 在 humidity 的每个水平下分析 temperature 的作用;
run;
quit;

*********************************************************************/
