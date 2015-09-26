*****
** TABLE 3
*****

* Medication use (including calculation of CV)
use Input/Med_use, clear
	ren C Med_use2008
	ren D Med_use2013
	keep RegionN Med_use$year ATC
	encode ATC, generate (ATC1)
	drop ATC
	levelsof ATC1, local(ATCcode)
	disp "`ATCcode'"
	gen CV=0
	qui foreach xx in `ATCcode' {
		summ Med_use$year if ATC1==`xx' & RegionNum!=1, detail
		replace CV=`r(sd)'/`r(mean)' if ATC1==`xx'
			}	
	bys RegionNum (ATC1): gen n = _n
	reshape wide  Med_use$year ATC1, i(n) j(RegionNum) 
	forvalues x = 1/6 {
		gen txt_`x' = string(Med_use$year`x',"%10.0fc")
		}
	gen txt_CV=string(CV,"%10.4fc" )
	gen parameter = "Med_use" + string(_n)
	keep parameter txt_*
joinby parameter using Program/Seed/Table3Seed, unm(using)
	sort Globalorder
	drop _merge parameter Globalorder
	compress	
	order var1 txt_*
	ren txt_1 Denmark
	ren txt_2 Capital 
	ren txt_3 Zealand
	ren txt_4 Southern 
	ren txt_5 Central
	ren txt_6 Northern
save OutputSTATA/Table3_$year, replace
