/*
---------------------------------------------------
Curso: Microeconometria Aplicada II
Tema: EEA
Autor: Edinson Tolentino
---------------------------------------------------
*/

cls
clear all
capture mkdir "E:\EducatePeru\Stata\S11\Data"
set more off
gl main 	"E:\EducatePeru\Stata\S11"
gl clean 	"${main}/Data"
gl codigos 	"${clean}/Codigos"
gl tablas 	"${main}/Tablas"

u "${clean}/BD_L11.dta",clear

d
sum 

*******************************
* Modelo MCO
*******************************
reg lnrva rsecurity_1 lnrl
