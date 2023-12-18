clear all
version 18

// cd "C:\Users\Bastian Barraza M\OneDrive\Documentos\Universidad\Datos Categoricos\data"

use "Base de datos Casen 2022 STATA", clear 

// Variables

/*
id_vivienda. Identificación vivienda
folio. Identificación hogar (id_vivienda hogar)
id_persona. Identificador de la persona en el hogar
region
area
cod_up. Código Unidad Primaria de Muestreo (UPM)
nse. nivel socio economico
estrato
hogar
expr 
varstrat 
varunit
edad
esc. Años de escolaridad (edad >= 15)
yoprcor. Ingreso ocupación principal corregido
*/

keep id_vivienda folio id_persona region area cod_up estrato hogar expr varstrat varunit edad esc yoprcor nse  sexo pco1

summarize esc
// Filtrar datos 

keep if region == 13 | region == 8
keep if pco1 == 1
// Crear variable de nivel de escolaridad dicotomizada
gen esc_dicotomic = (esc > 10)


//Ya filtrados los datos veremos un resumen

tabulate region if pco1==1
tabulate region if pco1==1
tabulate region [fw=expr]if pco1==1 
tabulate  esc if pco1==1 
///// Filtrar datos 

keep if region == 8 | region == 13
// datos observaciones totales por región


// mantendremos los jefes de hogar
keep if pco1 == 1 


/// Graficos  y analisis exploratorio ///





*********** DESCRIPCION DE LOS DATOS

summarize esc region edad  yoprcor nse sexo, detail
//En terminos de precentiles, media varianza simetria y kurtosis


summarize esc region // se resume  obs min, max std mean
tabulate region // especifico frecuencia  percentil acumulado 
tabulate edad

graph matrix esc region edad  yoprcor nse sexo , msymbol(p)  // grafica la dispersion





************ *************************************************
***** DESCRIBIR LOS DATOS YA SEA TABLA Y GRAFICO *****

************** INGRESOS TOTALES

table yoprcor,m
tabulate yoprcor
summarize yoprcor [fw=expr] , detail
summarize yoprcor [fw=expr]
graph box yoprcor // grafico de caja, se obsefvan bastante valores atipicos
*GRAFICOS de ingresos

histogram yoprcor , freq kdensity // histograma con linea de densidad
*como agregar factor de expansion al grafico
histogram yoprcor [fw = expr], freq xlabel(0(1000000)  30000000,angle(ninety)) title("Ingreso ocupación principal corregido de los jefes de hogar con FE") subtitle("Región del Biobio y Metropolitana") ytitle(`"Frecuencia"')

*editar este grafico para que buen representativo 

***************** edad

table edad
tabulate edad [fw=expr]
summarize edad, detail

************** AÑOS ESCOLARIDAD

tabulate esc 

summarize esc [fw=expr], detail

*como agregar factor de expansion al grafico

graph bar (count) [fw = expr] , over(esc) title("Años de escolaridad de los jefe de hogar con FE") subtitle(" Región del Biobio y Metropolitana") 

*sin faactor de expansión

graph bar (count), over(esc) title("Años de escolaridad de los jefe de hogar sin FE") subtitle("Región del Biobio y Metropolitana") 



********************* sexo
tab sexo
summarize sexo


*como agregar factor de expansion al grafico
graph bar  (count)   [fw = expr] , over (sexo)  bar(1, fcolor(midgreen)) blabel(bar) title("Sexo de los jefes de hogar con FE") subtitle("Región del Biobio y Metropolitana")  


*sin faactor de expansión

graph bar (count), over(sexo) bar(1, fcolor(midgreen)) blabel(bar) title("Sexo de los jefes de hogar sin FE") subtitle("Región del Biobio y Metropolitana") ytitle(`"Frecuencia"')

graph box esc,over(sexo) 


********************* nse


tab nse
summarize nse

*como agregar factor de expansion al grafico
graph bar  (count)   [fw = expr] , over (nse,label(angle(forty_five))) bar(1, fcolor(yellow)) blabel(bar) title("Nivel socio economico de la UPM de los jefes de hogar con FE") subtitle("Región del Biobio y Metropolitana") ytitle(`"Frecuencia"')

*sin faactor de expansión
graph bar (count), over(nse, label(angle(forty_five))) bar(1, fcolor(yellow)) blabel(bar) title("Nivel socio economico de la UPM de los jefes de hogar sin FE") subtitle("Región del Biobio y Metropolitana") ytitle(`"Frecuencia"')


graph box esc,over(nse) 


*****************Gráfico de relación

*Gráfico de sexo dado escolaridad
graph bar (count), over(sexo,axis(off)) over(esc) asyvars bar(1, fcolor(blue)) bar(2,fcolor(orange))  blabel(bar, size(vsmall)  orientation(vertical)) legend( on) title("Frecuencia de años de escolaridad por Sexo ") ytitle("Frecuencia") 

*generando variables con cortes esc  para sizualizar mejor

gen esc1 = group(esc) if inlist(esc, 1, 2,3,4,5,6,7,8,9,10)
gen esc2 = esc if inlist(esc, 11, 12,13,14,15,16,17,18,19,20)
gen esc3 = esc if inlist(esc, 21, 22,23,24,25,26,27,28,29)


*Gráfico de nivel de escolaridad  y nivel socio economico
graph bar (count), over(nse,axis(off)) over(esc1) asyvars bar(1, fcolor(blue)) bar(2,fcolor(orange))  blabel(bar, size(vsmall)  orientation(vertical)) legend( on) title("Frecuencia de años de escolaridad por nivel socio económico ") ytitle("Frecuencia") 

*Gráfico de nivel de escolaridad  y nivel socio economico
graph bar (count), over(nse,axis(off)) over(esc2) asyvars  blabel(bar, size(vsmall)  orientation(vertical)) legend( on) title("Frecuencia de años de escolaridad por nivel socio económico  ") ytitle("Frecuencia") 

*Gráfico de nivel de escolaridad  y nivel socio economico
graph bar (count), over(nse,axis(off)) over(esc3) asyvars bar(1, fcolor(blue)) bar(2,fcolor(orange))  blabel(bar, size(vsmall)  orientation(vertical)) legend( on) title("Frecuencia de años de escolaridad por nivel socio económico  ") ytitle("Frecuencia") 

*Gráfico de nivel de ecolaridad dado el ingreso 

graph box yoprcor, over(esc) title("Frecuencia de años de escolaridad por") subtitle("Ingreso ocupación principal corregido")



//////////////////////////////////////////
**************Modelo de regresion logistico**********

svyset varunit [w=expr], psu(varunit) strata(varstrat) singleunit(certainty) 

// Aplicar modelo logistico
svy: logit esc_dicotomic i.region edad  i.nse i.sexo, baselevels or

// Realizar predicciones
predict pred
label var pred "Logit: Pr(lfp I X)"
list pred

// Predictions by variable


margins region, vce(unconditional)
margins nse, vce(unconditional)
margins sexo, vce(unconditional)

margins, vce(unconditional) dydx(region) over(nse) 
marginsplot, title("Diferencia  del efecto de las regiones en cada n.s.e a los años de escolaridad") ytitle("Diferencia de Probabilidad entre regiones") xlabel(, angle(45)) 
graph export "C:\Users\Bastian Barraza M\OneDrive\Documentos\Universidad\Datos Categoricos\Trabajo_final\graphs\risk_dif.jpg", replace

// Distribución de las probabilidades
codebook pred, compact

dotplot pred, ytick(0(.2)1) ylabel(, grid gmin gmax) title("Prob. de que un jefe de hogar tenga mas de 10 años de escolaridad") ytitle("Probabilidad")
graph export "C:\Users\Bastian Barraza M\OneDrive\Documentos\Universidad\Datos Categoricos\Trabajo_final\graphs\dist_esc.jpg", replace

table pred[fw=expr]

table region nse

// Chequear residuos: Residuos estandarizados
gen rstd = esc_dicotomic - pred // Crear valores de residual santdar
generate index = _n // Crear index

label var index "Observation Number" // Labelear variables
label var rstd "Standardized Residual" // Labelear variables


sort edad // Sortear por una variable en particular (cambiable)
// Realizar gráfico
graph twoway scatter rstd index, msymbol(Oh)  mcolor(black) ylabel(-1(0.2)1, grid gmin gmax) yline(0, lcolor(black))

// Histograma de resiudos
histogram rstd, freq kdensity 



************************ MODELO MULTINOMIAL ORDINAL**********
//Un modelo multinomial ordinal es un tipo de modelo estadístico utilizado para analizar variables dependientes categóricas ordenadas en más de dos categorías. Este tipo de modelo es una extensión del modelo logístico ordinal y se utiliza cuando la variable de respuesta tiene tres o más niveles ordenados. Stata proporciona la función ologit para ajustar modelos de regresión logística ordinal.

******** modelo y prediccion con muestra compleja 
//En resumen, en tu análisis, hay evidencia significativa para rechazar la hipótesis nula de que todas las restricciones son verdaderas. La prueba F es significativa (Prob > F = 0.0000), lo que sugiere que al menos una de las variables independientes en tu modelo contribuye significativamente a explicar la variabilidad en la variable dependiente.

svy: ologit esc i.region edad yoprcor i.nse i.sexo
//////////predict pre_esc,category// probabilidades

predict pre_esc
//categoria

list esc pre_esc
summarize esc
summarize pre_esc
tab esc pre_esc
graph box esc, over( pre_esc)

graph box esc [fw=expr]
graph box pre_esc [fw=expr]




**********Regresión de Multinomial Nomial**********
recode esc (min/10 = 1) (11/12 = 2) (13/max = 3), gen(esc_multicat)
svyset varunit [w=expr], psu(varunit) strata(varstrat) singleunit(certainty) 


svy: mlogit esc_multicat edad i.sexo yoprcor i.region i.nse 

// Realizamos predicciones
predict pred, pr

// Muestra las primeras 10 filas de las predicciones
list pred in 1/10

// Chequear residuos
generate residuos = esc_multicat - pred
generate index = _n

label var index "Observation Number" 
label var residuos "Residual" 

// Histograma de residuos
histogram residuos, freq kdensity

//Prueba normalidad 
swilk residuos

summarize residuos



/////////////////////
**********Regresión de Poisson**********

svyset varunit [w=expr], psu(varunit) strata(varstrat) singleunit(certainty) 

* el modelo de poisson 
svy: poisson esc i.region edad yoprcor i.nse i.sexo
*mat list e(b)
estat effects

*test ward
*test 1.sexo 2.sexo

*** predict de residuos 
predict pred_esc
generate residuos = pred_esc-esc
generate index = _n
label var residuos "Standardized Residual"
label var index "Observation Number"


//Graficas
*keep if residuos < 40
*predict ehat1, residuals
predict yhat1, xb
scatter residuos yhat1, name(ehat1xyhat1, replace) title(Standardized Residual vs. Predicted Y)
histogram residuos, freq kdensity
graph twoway scatter residuos index, msymbol(Oh)  mcolor(black) ylabel(-15(5)35, grid gmin gmax) yline(0, lcolor(black))





/////////////////////
// Regresión binomial negativa
svyset varunit [w=expr], psu(varunit) strata(varstrat) singleunit(certainty) 

// Aplicar modelo logistico
svy: nbreg esc i.region edad yoprcor i.nse /*modelo regresión binomial negativa*/

estat effects

//predict de residuos
predict pred_esc
generate residuos = pred_esc-esc
generate index = _n
label var residuos "Standardized Residual"
label var index "Observation


//gráficos


predict yhat1, xb
scatter residuos yhat1, name(ehat1xyhat1, replace) title(Standardized Residual vs. Predicted Y)
histogram residuos, freq kdensity
graph twoway scatter residuos index, msymbol(Oh)  mcolor(black) ylabel(-15(5)35, grid gmin gmax) yline(0, lcolor(black))

summarize residuos

swilk residuos
