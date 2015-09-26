*****
** FIGURE 2ABC
*****

* 2A: Proportions of residents by 10-year age categories
clear
use Input/AgeCat10yr, replace
joinby RegionNum using Input/Total
	reshape wide  TotalTotal2013 TotalTotal2008 TotalAgeCat2008 TotalAgeCat2013, i(AgeCat) j(RegionNum) 
	forvalues x = 1/6 {
		gen txt_`x' = string(TotalAgeCat$year`x',"%10.0fc") +   " (" + string(100*TotalAgeCat$year`x'/TotalTotal$year`x',"%10.1f")+"%)"
		gen percent`x' = round(100*TotalAgeCat$year`x'/TotalTotal$year`x',0.1) 
		}
	keep AgeCatNum txt_* percent*	
	ren percent1 Denmark
	ren percent2 Capital 
	ren percent3 Zealand
	ren percent4 Southern 
	ren percent5 Central
	ren percent6 Northern
save OutputSTATA/Figure2A_$year, replace

*  2B: Proportions of residents by 10-year age categories, female
clear 
use Input/Agecat, replace
	encode  AgeCat, gen(AgeCatNum) 
	drop AgeCat 
joinby RegionNum using Input/Total
	keep TotalAgeCatFemale$year Region AgeCatNum TotalTotal$year
	reshape wide  TotalTotal$year TotalAgeCatFemale$year, i(AgeCat) j(RegionNum) 
	forvalues x = 1/6 {
		gen txt_`x' = string(TotalAgeCatFemale$year`x',"%10.0fc") +   " (" + string(100*TotalAgeCatFemale$year`x'/TotalTotal$year`x',"%10.1f")+"%)"
		gen percent`x' = round(100*TotalAgeCatFemale$year`x'/TotalTotal$year`x',0.1)
		}
	keep AgeCatNum txt_* percent*
	ren percent1 Denmark
	ren percent2 Capital 
	ren percent3 Zealand
	ren percent4 Southern 
	ren percent5 Central
	ren percent6 Northern
save OutputSTATA/Figure2B_$year, replace

* 2C: Proportions of residents by 10-year age categories, male
clear
use Input/Agecat, replace
	encode  AgeCat, gen(AgeCatNum)  
	drop AgeCat 
joinby RegionNum using Input/Total
	keep TotalAgeCatMale$year Region AgeCatNum TotalTotal$year
	reshape wide  TotalTotal$year TotalAgeCatMale$year, i(AgeCat) j(RegionNum) 
	forvalues x = 1/6 {
		gen txt_`x' = string(TotalAgeCatMale$year`x',"%10.0fc") +   " (" + string(100*TotalAgeCatMale$year`x'/TotalTotal$year`x',"%10.1f")+"%)"
		gen percent`x' = round(100*TotalAgeCatMale$year`x'/TotalTotal$year`x',0.1)
		}
	keep AgeCatNum txt_* percent*
	ren percent1 Denmark
	ren percent2 Capital 
	ren percent3 Zealand
	ren percent4 Southern 
	ren percent5 Central
	ren percent6 Northern
save OutputSTATA/Figure2C_$year, replace
