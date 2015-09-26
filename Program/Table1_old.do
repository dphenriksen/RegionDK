*****
** TABLE 1
*****

* Proportion of residents by regions 
clear
use Input/Total, clear
	gen n = 1
	reshape wide  TotalTotal2013 TotalTotal2008, i(n) j(RegionNum) 
	forvalues x = 1/6 {
		ren TotalTotal$year`x' Total$year`x'
		gen txt_`x' = string(Total$year`x',"%10.0fc") +   " (" + string(100*Total$year`x'/Total$year 1,"%10.1f")+"%)"
		}
	gen parameter = "Total1"
	gen order = 1
	keep parameter order txt_*
joinby order parameter using Program/Seed/Table1Seed, unm(using)
	sort order parameter
	drop _merge
	compress
save OutputSTATA/Table1_$year, replace

* Proportion of residents by regions and by gender 
use Input/Gender, clear
	ren Gender GenderStr
	gen Gender = 1 if GenderStr =="Kvinder"
	replace Gender = 2 if GenderStr=="Mænd"
	keep Gender RegionNum TotalGender$year
joinby RegionNum using Input/Total
	reshape wide TotalTotal2013 TotalTotal2008 TotalGender$year, i(Gender) j(RegionNum) 
	label define GenderLab 2 "Men" 1 "Women"
	label values Gender GenderLab
	forvalues x = 1/6 {
		gen txt_`x' = string(TotalGender$year`x',"%10.0fc") +   " (" + string(100*TotalGender$year`x'/TotalTotal$year`x',"%10.1f")+"%)"
		}
	gen parameter = "Gender" + string(_n)
	gen order = 2
	keep parameter txt_* order
merge 1:1 order parameter using OutputSTATA/Table1_$year, update nogen
	compress
save OutputSTATA/Table1_$year, replace

* Mean age by regions and by gender (including calculation of CV)
use Input/Meanage, clear
	gen Gender = 1 if A =="Kvinder"
	replace Gender = 2 if A=="Mænd"
	replace Gender = 3 if A=="I alt"
	keep Gender RegionNum Age$year
	levelsof Gender, local(gendertype)
	disp "`gendertype'"
	gen CV=0
	qui foreach xx in `gendertype' {
		summ Age if Gender==`xx' & RegionNum!=1, detail
		replace CV=`r(sd)'/`r(mean)' if Gender==`xx' 
		}	
 	reshape wide Age$year, i(Gender) j(RegionNum) 
	label define GenderLab 2 "Men" 1 "Women" 3 "Total"
	label values Gender GenderLab
	forvalues x = 1/6 {
		gen txt_`x' = string(Age$year`x',"%10.1fc") 
		}
	gen txt_CV=string(CV, "%10.3fc")
	gen parameter = "meanage" + string(_n)
	gen order =3
	keep parameter txt_* order
merge 1:1 order parameter using OutputSTATA/Table1_$year, update nogen
	compress
save OutputSTATA/Table1_$year, replace
	
* Population density (including calculation of CV)
use Input/Area, clear
	drop if RegionNum==.
joinby RegionNum using Input/Total
	gen TotalPopDensity$year = round(TotalTotal$year/TotalAreal$year, 1)
	keep RegionNum TotalPop
	gen n = 1
	sum(TotalPopDensity$year) if RegionNum!=1, detail 
	return list
	local CV=`r(sd)'/`r(mean)'
	gen CV=`CV' 
	reshape wide  TotalPopDensity, i(n) j(RegionNum) 
	forvalues x = 1/6 {
		gen txt_`x' = string(TotalPopDensity$year`x',"%10.0fc")
		}
	gen txt_CV=string(CV,"%10.3fc" )
	gen parameter = "PopDensity" + string(1)
	gen order = 4
	keep parameter txt_* order
merge 1:1 order parameter using OutputSTATA/Table1_$year, update nogen
	compress
save OutputSTATA/Table1_$year, replace

* Urbanizatation 
use Input/Urban, clear
	gen n=1
	reshape wide Urban2008 Urban2013, i(n) j(RegionNum)
	forvalues x = 1/6 {
		gen txt_`x' = string(Urban$year`x',"%10.0fc")+ "%"
		}
	gen parameter="Urban" + string(1) 
	gen order = 5
	keep parameter txt* order
merge 1:1 order parameter using OutputSTATA/Table1_$year, update nogen
	compress
	sort orderGlobal
	order var1 var2
	keep var1 var2 txt*
	ren txt_1 Denmark
	ren txt_2 Capital 
	ren txt_3 Zealand
	ren txt_4 Southern 
	ren txt_5 Central
	ren txt_6 Northern
save OutputSTATA/Table1_$year, replace
