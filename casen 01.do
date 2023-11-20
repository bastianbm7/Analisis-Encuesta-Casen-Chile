clear all
version 18

cd "C:\Users\Bastian Barraza M\OneDrive\Documentos\Universidad\Datos Categoricos\data"

use "Base de datos Casen 2022 STATA", clear 

// ¿Cuántos hogares fueron encuestados para la CASEN de 2022

// Cantidad máxima de prsonas por hogar


tabulate id_persona

// Idem a las anteriores por región y zona

tab1 region area if id_persona == 1

tabulate region area if id_persona == 1

// NSE

tab2 nse id_persona 

// Cantidad de hogares por vivienda

tab2  region id_persona if hogar == 6





/* 
- s13. ¿A qué sistema previsional de salud pertenece?
- s17b. ¿Cuál fue la modalidad de atención de esta consulta o atención médica?
- s19a. Problemas para llegar a la consulta, hospital, consultorio, etc.
- s19d. Problemas para pagar por la atención debido al costo
- s20a_preg. ¿Recibió alguna atención de medicina general en los últ. 3 meses?
- s20b. ¿En qué establecimiento recibió la última atención de medicina general?
*/


// Tab of quantity of s13 by region including expr
tabulate region s13[fw= expr] if id_persona == 1



// Grafico de sistema previsional vs modalidad de ultima atencion medica
preserve
	keep if s13 != -88
	keep if s17b != -88
	
	graph bar (count), over(s13) over(s17b) horizontal  
restore

// Grafico de sistema previsional vs modalidad presencial
preserve
	keep if s13 != -88
	keep if s17b == 1
	
	graph bar (count), over(s13) horizontal  
restore

// Grafico de sistema previsional vs modalidad online
preserve
	keep if s13 != -88
	keep if s17b == 2
	
	graph bar (count), over(s13) horizontal  
restore



// Grafico de sistema previsional vs problemas para pagar
preserve
preserve
	keep if s13 != -88
	keep if s19d != -88
	keep if s19d != -99
	graph bar (count), over(s13) over(s19d) horizontal  
restore



// Logistic regression

// Realizar la regresión logística
keep if s20b != -88
keep if s20b != 3
logistic s20b s13 












// Keep only the observations where id_persona == 1
keep if id_persona == 1

// Generate a bar graph for the filtered data

graph bar (count), over(s13) 