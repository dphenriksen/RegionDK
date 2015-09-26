*****
** FIGURE 3
*****

* Education
use Input/Education, clear
	keep Education TotalEducation$year RegionNum
	drop if RegionNum==.
	gen EduNumber = substr(Education,1,2)
	destring EduNumber, replace
	gen Edu = 1 if EduNumber<11
	replace Edu = 2 if inrange(EduNumber,11,39)
	replace Edu = 3 if inrange(EduNumber,40,89)
	replace Edu = 4 if missing(Edu)
	label define EduLab 1 "Below 10 years" 2 "10-12 years" 3 "Above 12 years" 4 "Unknown"
	label values Edu EduLab
	collapse (sum) TotalEducation$year  , by(Edu RegionNum) 
	bys RegionNum: egen TotalTotal = sum( TotalEducation$year)       
joinby RegionNum using Input/1569yr
	assert Total$year==TotalTotal
	drop Total2013 Total2008
	gen txt_`x'= 100*TotalEducation$year`x'/TotalTotal`x'
	graph hbar (sum) txt_, over(Edu) over(RegionNum) xsize(20) asyvars stack bargap(15) blabel(bar, color(black) size(large) position(center) orientation(horizontal) ///
		margin(right) format(%10.1fc) justification(center) alignment(middle)) ytitle(Percent) title(Education (15-69 year)) legend(on) graphregion(color(white))
graph save OutputGRAPH/Edu_$year.gph, replace

* Income
use Input/IncomeGroups, clear
	replace IncomeGroup = ">750.000 DKK" if IncomeGroup=="1.000.000 - 1.999.999 DKK"
	replace IncomeGroup = ">750.000 DKK" if IncomeGroup=="2.000.000 - 2.999.999 DKK"
	replace IncomeGroup = ">750.000 DKK" if IncomeGroup=="3.000.000 - 3.999.999 DKK"
	replace IncomeGroup = ">750.000 DKK" if IncomeGroup=="4.000.000 - 4.999.999 DKK"
	replace IncomeGroup = ">750.000 DKK" if IncomeGroup=="5.000.000 - 9.999.999 DKK"
	replace IncomeGroup = ">750.000 DKK" if IncomeGroup=="750.000 - 999.999 DKK"
	replace IncomeGroup = ">750.000 DKK" if IncomeGroup=="10.000.000 DKK og derover"
collapse (sum) TotalIncome*, by(IncomeGroup RegionNum)
	keep Income RegionNum TotalIncomePersons$year
collapse (sum) TotalIncomePersons$year  , by(Income RegionNum)
	bys RegionNum: egen TotalTotal = sum( TotalIncomePersons$year)
	gen txt_`x'=100*TotalIncomePersons$year`x'/TotalTotal`x'
	gen order =1 
	replace order=2 if IncomeGroup=="100.000 - 199.999 DKK"
	replace order=3 if IncomeGroup=="200.000-299.999 DKK" 
	replace order=4 if IncomeGroup=="300.000-399.999 DKK"
	replace order=5 if IncomeGroup=="400.000-499.999 DKK"
	replace order=6 if IncomeGroup=="500.000 - 749.999 DKK"
	replace order=7 if IncomeGroup== ">750.000 DKK"
	replace IncomeGroup="0-100.000 DKK" if IncomeGroup=="Under 100.000 DKK"	
	sort RegionNum order
	graph hbar (sum) txt_, over(IncomeGroup, sort(order)) over(RegionNum) xsize(20) asyvars stack bargap(15) blabel(bar, color(black) size(large) position(center) orientation(horizontal) ///
		margin(right) format(%10.1fc) justification(center) alignment(middle)) ytitle(Percent) title(Annual Income) legend(on) graphregion(color(white))
graph save OutputGRAPH/Income_$year.gph, replace

* Marital status
use Input/MaritalStatusny, clear
	keep  MaritalStatus RegionNum TotalMaritalStatus$year
	gen CohabStatus = 1 if MaritalStatus=="Gift/separeret"
	replace CohabStatus = 1 if MaritalStatus=="Registreret partnerskab"
	replace CohabStatus = 2 if MaritalStatus=="Ugift"
	replace CohabStatus = 3 if MaritalStatus=="Fraskilt"
	replace CohabStatus = 3 if MaritalStatus=="Ophævet partnerskab"
	replace CohabStatus = 4 if MaritalStatus=="Længstlevende af to partnere"
	replace CohabStatus = 4 if MaritalStatus=="Enke/enkemand"
	label define CohabLab 1 "Married" 2 "Never married" 3 "Divorced" 4 "Widowed"
	label values CohabStatus CohabLab
	collapse (sum) TotalMaritalStatus  , by(CohabStatus RegionNum)
joinby RegionNum using Input/Total
	gen txt_`x'=100*TotalMaritalStatus$year`x'/TotalTotal$year`x'
	graph hbar (sum) txt_, over(CohabStatus) over(RegionNum) xsize(20) asyvars stack bargap(15) blabel(bar, color(black) size(large) position(center) orientation(horizontal) ///
		margin(right) format(%10.1fc) justification(center) alignment(middle)) ytitle(Percent) title(Marital status) legend(on) graphregion(color(white))
graph save OutputGRAPH/Marital_$year.gph, replace

* Unemployment 
use Input/Unemployment, clear
	gen RegionNum2 = RegionNum
	label define RegionNumLbl 1 "Total" 2 "Capital Region of Denmark" 3 "Region Zealand" 4 "Region of Southern Denmark" 5 "Central Denmark Region" 6 "Region of Northern Denmark"
	label values RegionNum2 RegionNumLbl	
	if $year==2008 local no=5 
	if $year==2013 local no=8
	graph hbar Total$year, over(RegionNum) over(RegionNum2) xsize(20) ascategory asyvars stack bargap(15) blabel(total, color(black) size(large)  position(center) ///
	orientation(horizontal) margin(right) justification(center) alignment(middle)) ytitle(Percent) title(Unemployment) legend(on) graphregion(color(white)) ylabel(1(1)`no')
graph save OutputGRAPH/Unemploy_$year.gph, replace

* Combining the above graphs in figure 3
graph combine OutputGRAPH/Marital_$year.gph OutputGRAPH/Income_$year.gph OutputGRAPH/Edu_$year.gph OutputGRAPH/Unemploy_$year.gph, xsize(20) ysize(20) col(1) altshrink graphregion(color(white))
graph export OutputGRAPH/All_$year.pdf, replace
