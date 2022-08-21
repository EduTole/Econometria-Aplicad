**************************************************
*PASO 1 : Extraccion de informacion
**************************************************

*"/iinei/srienaho/descarga/STATA/737-Modulo77.zip"
cls
clear all
gl ubicacion "D:\Dropbox\BASES\ENAHO" 
cap mkdir "$ubicacion"
								
if 1==1{

	mat ENAHO=(634\687\737\759)
	mat MENAHO=J(4,31,0)
	mat MENAHO[1,1]=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,22,23,24,25,26,27,28,34,37,77,78,84,85)
	mat MENAHO[2,1]=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,22,23,24,25,26,27,28,34,37,77,78,84,85)
	mat MENAHO[3,1]=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,22,23,24,25,26,27,28,34,37,77,78,84,85)
	mat MENAHO[4,1]=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,22,23,24,25,26,27,28,34,37,77,78,84,85)
	
}
matlist ENAHO
matlist MENAHO


forvalues i=18/21{
	local year=2000
	local year=`year'+`i'
	local t=`i'-17
	
	cd "$ubicacion"
	cap mkdir `year'
	cd `year'
	
	cap mkdir "Download"
	cd "Download"
	
	scalar r_enaho=ENAHO[`t',1]
*Modulo 01-05 --> modulos hogar y persona	
		foreach j in 1 2 3 4 5 {
		scalar r_menaho=MENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho
		local mod=r_enaho
		local i=r_menaho
		display "`i'" " " "`year'" " " "`mod'"
		cap copy http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/`mod'-Modulo0`i'.zip enaho_`year'_mod_`i'.zip 
		cap unzipfile enaho_`year'_mod_`i'.zip, replace
		cap erase enaho_`year'_mod_`i'.zip
		}
		
	
*Modulo 34 --> sumaria pobreza
	scalar r_enaho=ENAHO[`t',1]
		foreach j in  26 {
		scalar r_menaho=MENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho
		local mod=r_enaho
		local i=r_menaho
		display "`i'" " " "`year'" " " "`mod'"
		cap copy http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/`mod'-Modulo`i'.zip  enaho_`year'_mod_`i'.zip 
		cap unzipfile enaho_`year'_mod_`i'.zip, replace
		cap erase enaho_`year'_mod_`i'.zip
		}	
			
		*Modulo 77 --> trabajador independiente
	scalar r_enaho=ENAHO[`t',1]
		foreach j in  28 {
		scalar r_menaho=MENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho
		local mod=r_enaho
		local i=r_menaho
		display "`i'" " " "`year'" " " "`mod'"
		cap copy http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/`mod'-Modulo`i'.zip enaho_`year'_mod_`i'.zip 
		cap unzipfile enaho_`year'_mod_`i'.zip, replace
		cap erase enaho_`year'_mod_`i'.zip
		}		

		*Modulo 85 --> encuesta de opinion
	scalar r_enaho=ENAHO[`t',1]
		foreach j in  31 {
		scalar r_menaho=MENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho
		local mod=r_enaho
		local i=r_menaho
		display "`i'" " " "`year'" " " "`mod'"
		cap copy http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/`mod'-Modulo`i'.zip enaho_`year'_mod_`i'.zip 
		cap unzipfile enaho_`year'_mod_`i'.zip, replace
		cap erase enaho_`year'_mod_`i'.zip
		}			
		
}
				
*Colocar data on files 
*------------------------------------------------------		
global ubicacion "D:\Dropbox\BASES\ENAHO" 


if 1==1{
	mat ENAHO=(634\687\737\759)
	mat MENAHO=J(4,7,0)
	mat TENAHO=J(4,7,0)
	
	mat MENAHO[1,1]=(1,2,3, 4,5, 77, 85)
	mat MENAHO[2,1]=(1,2,3, 4,5, 77, 85)
	mat MENAHO[3,1]=(1,2,3, 4,5, 77, 85)
	mat MENAHO[4,1]=(1,2,3, 4,5, 77, 85)
	
	mat TENAHO[1,1]=(100, 200, 300, 400, 500,77,34)
	mat TENAHO[2,1]=(100, 200, 300, 400, 500,77,34)
	mat TENAHO[3,1]=(100, 200, 300, 400, 500,77,34)
	mat TENAHO[4,1]=(100, 200, 300, 400, 500,77,34)
	
}

 
forvalues i=18/21{
	local year=2000
	local year=`year'+`i'
	local t=`i'-17

 if `year'<=2020{	
	
	cd "$ubicacion"
	cap mkdir `year'
	cd `year'
	global BaseFinal "D:\Dropbox\BASES\ENAHO\\`year'"
	cap mkdir "$BaseFinal"
	
*	cd "Download"

*Modulo 01-02 --> Modulos de hogar	
	scalar r_enaho=ENAHO[`t',1]
		foreach j in 1 2 {
		scalar r_menaho=MENAHO[`t',`j']
		scalar r_tenaho=TENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho " " r_tenaho
		local mod=r_enaho
		local i=r_menaho
		local k=r_tenaho
		display "`i'" " " "`year'" " " "`mod'" " "  "`k'"
		cap copy "`mod'-Modulo0`i'\\enaho01-`year'-`k'.dta" "enaho01-`year'-`k'.dta"
		u "enaho01a-`year'-`k'.dta",clear
		saveold "$BaseFinal\\enaho01-`year'-`k'.dta",replace
		}

		
*Modulo 03-05 --> Empleo	
	scalar r_enaho=ENAHO[`t',1]
		foreach j in 3 4 5{
		scalar r_menaho=MENAHO[`t',`j']
		scalar r_tenaho=TENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho " " r_tenaho
		local mod=r_enaho
		local i=r_menaho
		local k=r_tenaho
		display "`i'" " " "`year'" " " "`mod'" " "  "`k'"
		cap copy "`mod'-Modulo0`i'\\enaho01a-`year'-`k'.dta" "enaho01a-`year'-`k'.dta"
		u "enaho01a-`year'-`k'.dta",clear
		saveold "$BaseFinal\\enaho01a-`year'-`k'.dta",replace
		}
		
*Modulo 77 --> trabajador independiente	
*	scalar r_enaho=ENAHO[`t',1]
		foreach j in 6 {
		scalar r_menaho=MENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho
		local mod=r_enaho
		local i=r_menaho
		display "`i'" " " "`year'" " " "`mod'"
		cap copy "`mod'-Modulo`i'\\enaho04-`year'-1-preg-1-a-13.dta" "enaho04-`year'-1-preg-1-a-13.dta"
		u "enaho04-`year'-1-preg-1-a-13.dta",clear
		qui saveold "$BaseFinal\\enaho04-`year'-1-preg-1-a-13.dta",replace
		
		}		

*Modulo 34 --> sumaria	
*	scalar r_enaho=ENAHO[`t',1]
		foreach j in 7 {
		scalar r_menaho=TENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho
		local mod=r_enaho
		local i=r_menaho
		display "`i'" " " "`year'" " " "`mod'"
		cap copy "`mod'-Modulo`i'\\sumaria-`year'.dta" "sumaria-`year'.dta"
		u "sumaria-`year'.dta",clear
		qui saveold "$BaseFinal\\sumaria-`year'.dta",replace
		
		}		

*Modulo 85 --> modulo de opinion	
*	scalar r_enaho=ENAHO[`t',1]
		foreach j in 7 {
		scalar r_menaho=MENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho
		local mod=r_enaho
		local i=r_menaho
		display "`i'" " " "`year'" " " "`mod'"
		cap copy "`mod'-Modulo`i'\\enaho01b-`year'-1.dta" "enaho01b-`year'-1.dta"
		u "enaho01b-`year'-1.dta",clear
		qui saveold "$BaseFinal\\enaho01b-`year'-1.dta",replace
		
		}			

		foreach j in 7 {
		scalar r_menaho=MENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho
		local mod=r_enaho
		local i=r_menaho
		display "`i'" " " "`year'" " " "`mod'"
		cap copy "`mod'-Modulo`i'\\enaho01b-`year'-2.dta" "enaho01b-`year'-2.dta"
		u "enaho01b-`year'-2.dta",clear
		qui saveold "$BaseFinal\\enaho01b-`year'-2.dta",replace
		
		}	
		
	}
	
	*Caso 2021
	if `year'==2021 {
		
	cd "$ubicacion"
	cap mkdir `year'
	cd `year'
	global BaseFinal "D:\Dropbox\BASES\ENAHO\\`year'"
	cap mkdir "$BaseFinal"

	cd "Download"

*Modulo 01-02 --> Empleo	
	scalar r_enaho=ENAHO[`t',1]
		foreach j in 1 2 {
		scalar r_menaho=MENAHO[`t',`j']
		scalar r_tenaho=TENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho " " r_tenaho
		local mod=r_enaho
		local i=r_menaho
		local k=r_tenaho
		display "`i'" " " "`year'" " " "`mod'" " "  "`k'"
		cap copy "`mod'-Modulo0`i'\\enaho01-`year'-`k'.dta" "enaho01-`year'-`k'.dta"
		u "enaho01-`year'-`k'.dta",clear
		saveold "$BaseFinal\\enaho01-`year'-`k'.dta",replace
		}
		
*Modulo 03-05 --> Empleo	
	scalar r_enaho=ENAHO[`t',1]
		foreach j in 3 4 5 {
		scalar r_menaho=MENAHO[`t',`j']
		scalar r_tenaho=TENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho " " r_tenaho
		local mod=r_enaho
		local i=r_menaho
		local k=r_tenaho
		display "`i'" " " "`year'" " " "`mod'" " "  "`k'"
		cap copy "`mod'-Modulo0`i'\\enaho01a-`year'-`k'.dta" "enaho01a-`year'-`k'.dta"
		u "enaho01a-`year'-`k'.dta",clear
		saveold "$BaseFinal\\enaho01a-`year'-`k'.dta",replace
		}
		
*Modulo 77 --> trabajador independiente	
*	scalar r_enaho=ENAHO[`t',1]
		foreach j in 6 {
		scalar r_menaho=MENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho
		local mod=r_enaho
		local i=r_menaho
		display "`i'" " " "`year'" " " "`mod'"
		cap copy "`mod'-Modulo`i'\\enaho04-`year'-1-preg-1-a-13.dta" "enaho04-`year'-1-preg-1-a-13.dta"
		u "enaho04-`year'-1-preg-1-a-13.dta",clear
		qui saveold "$BaseFinal\\enaho04-`year'-1-preg-1-a-13.dta",replace
		
		}	
		
*Modulo 34--> Sumaria	
		foreach j in 7 {
		scalar r_menaho=TENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho
		local mod=r_enaho
		local i=r_menaho
		display "`i'" " " "`year'" " " "`mod'"
		cap copy "`mod'-Modulo`i'\\sumaria-`year'.dta" "sumaria-`year'.dta"
		u "sumaria-`year'.dta",clear
		qui saveold "$BaseFinal\\sumaria-`year'.dta",replace
		
		}

*Modulo 85 --> modulo de opinion	
*	scalar r_enaho=ENAHO[`t',1]
		foreach j in 7 {
		scalar r_menaho=MENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho
		local mod=r_enaho
		local i=r_menaho
		display "`i'" " " "`year'" " " "`mod'"
		cap copy "`mod'-Modulo`i'\\enaho01b-`year'-1.dta" "enaho01b-`year'-1.dta"
		u "enaho01b-`year'-1.dta",clear
		qui saveold "$BaseFinal\\enaho01b-`year'-1.dta",replace
		
		}
		
		foreach j in 7 {
		scalar r_menaho=MENAHO[`t',`j']
		display "`year'" " " r_enaho " " r_menaho
		local mod=r_enaho
		local i=r_menaho
		display "`i'" " " "`year'" " " "`mod'"
		cap copy "`mod'-Modulo`i'\\enaho01b-`year'-2.dta" "enaho01b-`year'-2.dta"
		u "enaho01b-`year'-2.dta",clear
		qui saveold "$BaseFinal\\enaho01b-`year'-2.dta",replace
		
		}	
		
	}	
	
}
