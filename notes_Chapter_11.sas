/*************************��ʮһ�� �������**************************/

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
	histogram /normal(mu=est sigma=est);                    * ��̬���;
run;

proc glm data=work.relieftime alpha=0.05 plots=diagnostics; * diagnosticsѡ������������ͼ;
	class medicine;
	model hours=medicine;                                   * ����ģ��;
	means medicine /hovtest;                                * �����ֵ��hovtest���鷽������;
	lsmeans medicine /pdiff=all;                            * pdiffѡ�����ˮƽ�����;
run;
quit;

proc glm data=work.relieftime alpha=0.05;                   * �Ա��������̣����ͼ�����;
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
* �ֲ����;
proc univariate data=sashelp.class;
	var height;
*	class sex;
	histogram /normal(mu=est sigma=est);
run;


* �������Լ���;
proc ttest data=sashelp.class plot(shownull)=interval;
*	class sex;              * class ����ֻ����2��ȡֵ������ֻ����˫�����������Լ���;
	var height;
run;
proc glm data=sashelp.class alpha=0.05 plots;
	class sex;              * class ���������ж��ȡֵ;
	model height=sex;
	means sex /hovtest;     * hovtest ѡ���ⷽ�����ԣ�means ���ر��������model-;
							* -�е��������Լ���ֻ���ڵ�����ģ����ʹ�ã��Ա���������;
run;
quit;


* �޽������õ�˫����ʵ�鷽�����;
proc glm data=sashelp.class alpha=0.05;
	class age sex;                     * class �����ж������;
	model height=age sex age*sex;      * age*sex �ж�age��sex�Ƿ񽻻����ã�H0=û�н�������;
	means age sex;                     * ��ʱ����ָ�� hovtest��ֻ���ڵ�����ģ��ʹ��;
run;
	* ���Ͻ����ʾ����ˮƽֻ��age������ʹ��lsmeans����age��ˮƽ�����;
	lsmeans age /pdiff=all;            * glm ֧�ֽ����ԣ���һֱ�ں�̨���У�ֱ��������һ��-;
									   * -proc����data����quit���;
	* ע�⣬�������ݲ��Ǿ���ģ�Ӧʹ��lsmeans����ľ�ֵ����means����ľ�ֵ�����;
run;
quit;


* �н������õ�˫����ʵ�鷽�����;
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
		* humidity �� PrF < alpha=0.05����Ϊ humidity ����������;
		* humidity*temperature �� PrF < alpha=0.05����Ϊ�н�������;
	lsmeans humidity*temperature /slice=humidity;
		* �� humidity ��ÿ��ˮƽ�·��� temperature ������;
run;
quit;

*********************************************************************/
