*****
** TABLE 2
*****

use Input/GP, clear
	keep AgeCat TotalGPContacts$year RegionNum
	encode AgeCat, gen(AgeCatNum)
	drop AgeCat
joinby RegionNum AgeCatNum using Input/AgeCat10yr
	gen double TotalGPperperson = round(TotalGPContacts$year/TotalAgeCat$year, 0.1) 
save Input/GPTemp, replace

* GP contacts per resident (including calculation of CV)
use Input/GPTemp, clear
	keep TotalGP* RegionNum AgeCatNum TotalAgeCat$year
	collapse (sum) TotalGPContacts TotalAgeCat, by(RegionNum) 
joinby RegionNum using Input/Total
	assert TotalTotal$year==TotalAgeCat$year
	gen n = 1
	gen TotalGPContactsPerResident = TotalGPContacts/TotalAgeCat		
	sum(TotalGPContactsPerResident) if RegionNum!=1, detail 
	return list
	local CV=`r(sd)'/`r(mean)'
	gen CV=`CV'
	keep n TotalGPContactsPerResident RegionNum CV
	reshape wide  TotalGPContactsPerResident, i(n) j(RegionNum) 
	forvalues x = 1/6 {
		gen txt_`x' = string(TotalGPContactsPerResident`x',"%10.1fc")
		}
	gen txt_CV=string(CV, "%10.3fc")
	gen parameter = "GP" + string(1)
	gen order = 1
	keep parameter order txt_*
joinby order parameter using Program/Seed/Table2Seed, unm(using)
	sort order parameter
	drop _merge
	compress
save OutputSTATA/Table2_$year, replace

* In-and Outpatient care (including calculation of CV)
use Input/AdmissionOutPatient, clear
	keep AdmOutPatient TotalAdmOutPatient$year RegionNum
	gen InOut = 1 if AdmOutPatient=="Ambulante patienter (pr. 1000 indbyggere)"
	replace InOut = 2 if AdmOutPatient=="Ambulante behandlinger (pr. 1000 indbyggere)"
	replace InOut = 3 if AdmOutPatient=="Indlagte patienter (pr. 1000 indbyggere)"
	replace InOut = 4 if AdmOutPatient=="Indlæggelser (pr. 1000 indbyggere)"
	replace InOut = 5 if AdmOutPatient=="Sengedage (pr. 1000 indbyggere)"
	drop if RegionNum==.
	label define InOutLab 1 "Outpatients" 2 "Outpatient contacts" 3 "Admitted patients" 4 "Admissions" 5 "Hospital (inpatient) bed-days"
	label values InOut InOutLab
	keep RegionNum InOut TotalAdmOutPatient$year
	levelsof InOut, local(admtype)
	disp "`admtype'"
	gen CV=0
	qui foreach xx in `admtype' {
		summ TotalAdmOut if InOut==`xx' & RegionNum!=1, detail
		replace CV=`r(sd)'/`r(mean)' if InOut==`xx'
			}	
	bys RegionNum (InOut): gen n = _n
	reshape wide  TotalAdmOutPatient$year, i(n) j(RegionNum) 
	forvalues x = 1/6 {
		gen txt_`x' = string(TotalAdmOutPatient$year`x',"%10.0fc")
		}
	gen txt_CV=string(CV, "%10.3fc")
	gen parameter = "InOut" + string(_n) 
	gen order = 2
	keep parameter txt_* order 
merge 1:1 order parameter using OutputSTATA/Table2_$year, update nogen
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
save OutputSTATA/Table2_$year, replace
