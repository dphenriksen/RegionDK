*****
** DATALOAD
*****

* Changing the name of Regions in every file from "Raw" folder
foreach n in Meanage Total AdmissionOutPatient AgeCat AgeCat10yr Area Education Gender GP IncomeGroups MaritalStatusny Urban 1569yr Unemployment Med_use {
	clear
	import excel Input/Raw/`n'.xlsx, firstrow
	
	if "`n'" == "AgeCat10yr" {
		encode AgeCat, gen(AgeCatNum)
		drop AgeCat
	}
	
	if "`n'" == "IncomeGroups" {	
		replace IncomeGroup = subinstr(IncomeGroup,"kr.","DKK",.)		
	}
	
	gen RegionNum = 1 if Region=="Hele landet"
	replace RegionNum = 2 if Region=="Region Hovedstaden" | Region=="Hovedstaden"
	replace RegionNum = 3 if Region=="Region Sjælland"    | Region=="Sjælland" | Region=="Region Sj¾lland" | Region=="Sj¾lland"
	replace RegionNum = 4 if Region=="Region Syddanmark"  | Region=="Syddanmark"
	replace RegionNum = 5 if Region=="Region Midtjylland" | Region=="Midtjylland"
	replace RegionNum = 6 if Region=="Region Nordjylland" | Region=="Nordjylland"
	label define RegionLab 1 "Total" 2 "Capital Region of Denmark" 3 "Region Zealand" 4 "Region of Southern Denmark" 5 "Central Denmark Region" 6 "Region of Northern Denmark"
	label values RegionNum RegionLab
	drop Region
save Input/`n', replace
}
