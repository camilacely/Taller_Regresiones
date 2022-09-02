***************************
** Evaluacion de Impacto **
**   Taller de Repaso    **
* Andrea Margarita Beleño *
** Yuli Castellanos Niño **
* Maria Camila Cely Moreno*
***************************


*Pregunta de investigacion: la corrupcion politica incrementa la incidencia de trampa por parte de los estudiantes?


******************************
* establecer directorio y ruta  ** varia de acuerdo al pc de cada quien

*cd "C:\Users\Camila Cely\Documents\GitHub\Taller_Regresiones"
cd "E:\MAESTRIA UNIANDES\EVALUACION DE IMPACTO\Taller_Regresiones"
use "corruption.dta"

br
summarize

******************************
***PUNTO 1

* Revision de variables

***
* Corrupt: toma valor de 1 si hubo corrupcion en el municipio m en el año t
sum Corrupt
/*
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
     Corrupt |    102,637    .1537555    .3607159          0          1 */

***	 
* 	Auditada : toma valor de 1 si fueron publicadas auditorias  en el municipio m en el año t
sum Auditada
/*
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
    Auditada |    102,637    .3248244    .4683115          0          1 */

***
* clavedelaescuela: esta como texto, es un identificador para hacer los efectos fijos por escuela

***
* year: para efectos fijos de tiempo (anual) **notar que aqui hay tres observaciones mas que en el resto de variables, no se por que
sum year
/*    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
        year |    102,640    2010.443    1.955598       2006       2013 */

***
* GradoSecundaria : grado de los estudiantes
sum GradoSecundaria
/*    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
GradoSecun~a |    102,637    2.145445    .8319514          1          3 */

***
* PartidoDesf : corresponde al partido politico activo, variable de texto

***
* AlreadyAudited: toma el valor de 1 si el municipio ya fue auditado en el pasado

sum AlreadyAudited
/*
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
AlreadyAud~d |    102,637    .7081559    .4546132          0          1 */

***
*CorruptPast : Toma el valor e 1 si el municipio fue corrupto en el pasado
sum CorruptPast

/*    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
 CorruptPast |    102,637    .4697819    .4990885          0          1 */
 
***
*Numero de homicidios per capita por municipio por año
sum HOMI_CAP_MUN

/*   Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
HOMI_CAP_MUN |    102,637     .000217    .0003278          0   .0045558 */

***
* total de impuestos recolectados en el municipio m en el año texto
sum total

/*    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
       total |    102,637    1.00e+09    1.31e+09          0   7.76e+09 */

*   nota: esta variable debemos manejarla en logaritmo, por eso hay que crear una nueva variable *

gen log_total = log(total) /*dice que se generan 4344 missing values, esto es porque hay valores de cero*/

sum log_total

/*    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
   log_total |     98,296    19.97693    1.322248   15.48875   22.77245
   
   notamos que se reducen las observaciones si dejamos los ceros tal cual, porque el logaritmo de cero se vuelve missing value*/
   
   
*Vamos a duplicarla y reemplazarle los valores de cero para que no se generen los missing values en la variable de logaritmo

gen total2 = total
sum total2

replace total2=1 if total2==0 
sum total2 
*aqui ya vemos que el valor minimo cambio a 1*

*ahora si voy a crear logaritmo

gen log_total2 = log(total2)
sum log_total2

/*    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
  log_total2 |    102,637    19.13201    4.223687          0   22.77245*/
  

***
* MismoPartidoG = toma el valor de 1 si el partido politico del municipio m en el año t esta alineado con el nacional

sum MismoPartidoG

/*    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
MismoParti~G |    102,640    .3171863    .4653829          0          1*/


* por ultimo, ver cuales variables tienen missings
mdesc


 /*  Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
   clavedelae~a |           3        102,640           0.00
          turno |           3        102,640           0.00
           prop |         507        102,640           0.49
   GradoSecun~a |           3        102,640           0.00
           year |           0        102,640           0.00
      clave_mun |           3        102,640           0.00
   unauthorized |           3        102,640           0.00
       Auditada |           3        102,640           0.00
   AlreadyAud~d |           3        102,640           0.00
    CorruptPast |           3        102,640           0.00
        Corrupt |           3        102,640           0.00
   HOMI_CAP_MUN |           3        102,640           0.00
          total |           3        102,640           0.00
        mis_tot |           3        102,640           0.00
    PartidoDesf |           3        102,640           0.00
   MismoParti~G |           0        102,640           0.00
      log_total |       4,344        102,640           4.23
         total2 |           3        102,640           0.00
     log_total2 |           3        102,640           0.00
*/


******************************
***PUNTO 2




* correr las siguientes regresiones

* a) regresion simple de variable dependiente contra independiente principal

reg prop Corrupt
*no sale significativa la variable Corrupt 


/*      Source |       SS           df       MS      Number of obs   =   102,133
-------------+----------------------------------   F(1, 102131)    =      1.50
       Model |  .023700688         1  .023700688   Prob > F        =    0.2203
    Residual |  1610.96488   102,131  .015773515   R-squared       =    0.0000
-------------+----------------------------------   Adj R-squared   =    0.0000
       Total |  1610.98858   102,132  .015773593   Root MSE        =    .12559

------------------------------------------------------------------------------
        prop |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
     Corrupt |   .0013363   .0010901     1.23   0.220    -.0008004    .0034729
       _cons |   .0408682   .0004271    95.68   0.000      .040031    .0417054
------------------------------------------------------------------------------*/


* b) regresion simple de variable dependiente contra independiente principal + controles

*Para la variable PartidoDesf, se convertirá a numérica 
egen nPartidoDesf= group(PartidoDesf)

reg prop Corrupt nPartidoDesf Auditada CorruptPast HOMI_CAP_MUN log_total2 MismoPartidoG 
* nota: esta regresion no esta corriendo no estoy segura por que, revisar
* ademas: no se si esta bien especificada, tengo dudas sobre como se incluye el tiempo y el municipio

/*Source |       SS           df       MS      Number of obs   =   102,133
-------------+----------------------------------   F(7, 102125)    =     97.82
       Model |  10.7293994         7  1.53277134   Prob > F        =    0.0000
    Residual |  1600.25918   102,125  .015669613   R-squared       =    0.0067
-------------+----------------------------------   Adj R-squared   =    0.0066
       Total |  1610.98858   102,132  .015773593   Root MSE        =    .12518

-------------------------------------------------------------------------------
        prop1 | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
--------------+----------------------------------------------------------------
      Corrupt |   .0007935   .0013804     0.57   0.565     -.001912    .0034991
 nPartidoDesf |   .0003293   .0000179    18.44   0.000     .0002943    .0003643
     Auditada |   .0010582   .0010766     0.98   0.326    -.0010519    .0031683
  CorruptPast |  -.0049382   .0008118    -6.08   0.000    -.0065294    -.003347
 HOMI_CAP_MUN |   4.195555   1.211255     3.46   0.001     1.821511    6.569599
   log_total2 |   -.000952   .0000945   -10.08   0.000    -.0011371   -.0007668
MismoPartidoG |  -.0117006   .0008472   -13.81   0.000     -.013361   -.0100402
        _cons |   .0480061   .0020287    23.66   0.000     .0440298    .0519824
-------------------------------------------------------------------------------
*/


ssc install ftools
ssc install reghdfe /*Para instalar paquete de stata*/

* c) regresion simple de variable dependiente contra independiente principal + efectos fijos

*primero los voy a sacar todos por separado para ver como se comportan

**efectos fijos por escuela
reghdfe prop Corrupt , absorb (clavedelaescuela)
*observamos que cuando se ponen efectos fijos por escuela, ahi si empezamos a ver significancia en la variable explicativa de interes

/*(dropped 1777 singleton observations)
(MWFE estimator converged in 1 iterations)

HDFE Linear regression                            Number of obs   =    100,356
Absorbing 1 HDFE group                            F(   1,  81671) =      16.35
                                                  Prob > F        =     0.0001
                                                  R-squared       =     0.3506
                                                  Adj R-squared   =     0.2020
                                                  Within R-sq.    =     0.0002
                                                  Root MSE        =     0.1118

------------------------------------------------------------------------------
        prop |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
     Corrupt |   .0047088   .0011645     4.04   0.000     .0024264    .0069913
       _cons |   .0403388   .0003958   101.91   0.000      .039563    .0411146
------------------------------------------------------------------------------

Absorbed degrees of freedom:
----------------------------------------------------------+
      Absorbed FE | Categories  - Redundant  = Num. Coefs |
------------------+---------------------------------------|
 clavedelaescuela |     18684           0       18684     |
----------------------------------------------------------+
*/

**efectos fijos por grado escolar de los estudiantes
reghdfe prop Corrupt , absorb (GradoSecundaria)
*observamos que solo con efectos fijos de grado, no se obtiene significancia en la variable de interes

/*(MWFE estimator converged in 1 iterations)

HDFE Linear regression                            Number of obs   =    102,133
Absorbing 1 HDFE group                            F(   1, 102129) =       1.99
                                                  Prob > F        =     0.1586
                                                  R-squared       =     0.0052
                                                  Adj R-squared   =     0.0052
                                                  Within R-sq.    =     0.0000
                                                  Root MSE        =     0.1253

------------------------------------------------------------------------------
        prop |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
     Corrupt |   .0015331   .0010874     1.41   0.159    -.0005981    .0036644
       _cons |    .040838    .000426    95.85   0.000     .0400029     .041673
------------------------------------------------------------------------------

Absorbed degrees of freedom:
---------------------------------------------------------+
     Absorbed FE | Categories  - Redundant  = Num. Coefs |
-----------------+---------------------------------------|
 GradoSecundaria |         3           0           3     |
---------------------------------------------------------+*/

**efectos fijos por año (tiempo)
reghdfe prop Corrupt , absorb (year)
*observamos que con efectos fijos de año unicamente, tampoco se obtiene significancia

/*(MWFE estimator converged in 1 iterations)

HDFE Linear regression                            Number of obs   =    102,133
Absorbing 1 HDFE group                            F(   1, 102124) =       0.96
                                                  Prob > F        =     0.3280
                                                  R-squared       =     0.0075
                                                  Adj R-squared   =     0.0075
                                                  Within R-sq.    =     0.0000
                                                  Root MSE        =     0.1251

------------------------------------------------------------------------------
        prop |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
     Corrupt |   .0010695   .0010935     0.98   0.328    -.0010736    .0032127
       _cons |   .0409092    .000426    96.03   0.000     .0400742    .0417441
------------------------------------------------------------------------------

Absorbed degrees of freedom:
-----------------------------------------------------+
 Absorbed FE | Categories  - Redundant  = Num. Coefs |
-------------+---------------------------------------|
        year |         8           0           8     |
-----------------------------------------------------+*/


*** ahora sacamos la regresion con los tres efectos fijos
reghdfe prop Corrupt , absorb (clavedelaescuela GradoSecundaria year)
*observamos que hay significancia y que el coeficiente es ligeramente menor que cuando solo se usan efectos fijos de clave de la escuela, por lo cual los otros efectos fijos si pueden estar ayudando a hallar un estimador menos sesgado
*en general vemos que aqui el coeficiente es positivo, significativo, pero su magnitud creo que es baja (0.004)

/*(dropped 1777 singleton observations)
(MWFE estimator converged in 6 iterations)

HDFE Linear regression                            Number of obs   =    100,356
Absorbing 3 HDFE groups                           F(   1,  81662) =      14.03
                                                  Prob > F        =     0.0002
                                                  R-squared       =     0.3631
                                                  Adj R-squared   =     0.2173
                                                  Within R-sq.    =     0.0002
                                                  Root MSE        =     0.1108

------------------------------------------------------------------------------
        prop |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
     Corrupt |   .0043555   .0011627     3.75   0.000     .0020767    .0066344
       _cons |   .0403932   .0003927   102.87   0.000     .0396235    .0411628
------------------------------------------------------------------------------

Absorbed degrees of freedom:
----------------------------------------------------------+
      Absorbed FE | Categories  - Redundant  = Num. Coefs |
------------------+---------------------------------------|
 clavedelaescuela |     18684           0       18684     |
  GradoSecundaria |         3           1           2     |
             year |         8           1           7    ?|
----------------------------------------------------------+
? = number of redundant parameters may be higher*/


* d) regresion simple de variable dependiente contra independiente principal + controles + efectos fijos

reghdfe prop Corrupt nPartidoDesf Auditada CorruptPast HOMI_CAP_MUN log_total2 MismoPartidoG , absorb (clavedelaescuela GradoSecundaria year)
/*HDFE Linear regression                            Number of obs   =    100,356
Absorbing 3 HDFE groups                           F(   7,  81656) =       6.76
                                                  Prob > F        =     0.0000
                                                  R-squared       =     0.3634
                                                  Adj R-squared   =     0.2176
                                                  Within R-sq.    =     0.0006
                                                  Root MSE        =     0.1107

-------------------------------------------------------------------------------
         prop | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
--------------+----------------------------------------------------------------
      Corrupt |   .0047463   .0015121     3.14   0.002     .0017826    .0077101
 nPartidoDesf |   .0000977   .0000253     3.86   0.000     .0000481    .0001473
     Auditada |  -.0016889   .0011823    -1.43   0.153    -.0040061    .0006284
  CorruptPast |  -.0033646   .0016269    -2.07   0.039    -.0065532   -.0001759
 HOMI_CAP_MUN |  -3.506931   2.309111    -1.52   0.129    -8.032773    1.018911
   log_total2 |  -.0001694   .0001384    -1.22   0.221    -.0004406    .0001019
MismoPartidoG |   .0021732   .0011155     1.95   0.051    -.0000133    .0043596
        _cons |   .0410487   .0030561    13.43   0.000     .0350588    .0470386
-------------------------------------------------------------------------------

Absorbed degrees of freedom:
----------------------------------------------------------+
      Absorbed FE | Categories  - Redundant  = Num. Coefs |
------------------+---------------------------------------|
 clavedelaescuela |     18684           0       18684     |
  GradoSecundaria |         3           1           2     |
             year |         8           1           7    ?|
----------------------------------------------------------+
? = number of redundant parameters may be higher

*/

