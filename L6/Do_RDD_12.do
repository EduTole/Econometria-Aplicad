***Regression Discontinuity 
cd "E:\EducatePeru\Stata\S12\Data"
*Cargar la base de datos
u RDD_12.dta,clear

*Pregunta 4
*--------------------------------------------
///This creates the treatment dummy & tabulates -
gen DUM=0
replace DUM=1 if rating > 6
tab DUM

 
///Use a scatter plot relating log attendance to the rating variable - Pregunta 5
*--------------------------------------------
scatter lattend rating, msize(small) xline(7) xtitle("League Position") ytitle("Log Attendance")

findit rdplot

////Click on SJ-14-4 st0366  . .  Robust data-driven inference in reg.-discontinuity design......and then install

///Use an RD Plot to get a better sense of the discontinutity -
rdplot lattend rating, c(7) kernel(tri) p(2) ci(95) shade graph_options(title(RD plot of Log Attendance))

////Test the difference between 'treatment' and 'control' 
gen DD=1-DUM
ttest lattend,by(DD)

////Test the difference between 'treatment' and 'control' in the neighbourhood of the threshold 
ttest lattend if (rating >5 & rating<8), by (DD)

///Generate re-centred rating variable, its quadratic & interactions with the treatment dummy (DUM)

gen x1=(rating-7)
gen x1_sq=x1^2

gen x1_DUM=x1*DUM
gen x1_sq_DUM=x1_sq*DUM

*Pregunta 6
*--------------------------------------------
///Estimate the global parametric model - 

reg lattend x1 x1_sq x1_DUM x1_sq_DUM DUM i.season i.club_id, robust 



*Pregunta 7
*--------------------------------------------

*** Local linear regression with bandwidth of 1 - 

reg lattend DUM if (rating >5 & rating<8),robust

*Pregunta 8
*--------------------------------------------

///Now add covariates to the parametric regression model -
reg lattend x1 x1_sq x1_DUM x1_sq_DUM DUM midweek ldistance derby season, robust 

///Now add covariates to the non-parametric local linear regression model
reg lattend DUM midweek ldistance derby season if (rating >5 & rating<8),robust


////Check whether covariate ip_win should be included in the RDD specification - Question 11 
rdplot ip_win rating, c(7) kernel(tri) p(2) ci(95) shade graph_options(title(RD plot of Win Probability))









 