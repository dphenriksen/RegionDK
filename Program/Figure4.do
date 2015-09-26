*****
** FIGURE 4
*****

use Input/GP, clear
	keep AgeCat TotalGPContacts$year RegionNum
	split AgeCat, parse(år)
	drop AgeCat
	ren AgeCat1 AgeCat
	encode  AgeCat, gen(AgeCatNum)  
	drop AgeCat
joinby RegionNum AgeCatNum using Input/AgeCat10yr
	gen double TotalGPperperson = round(TotalGPContacts$year/TotalAgeCat$year, 0.1) 
	reshape wide TotalGPperperson TotalGPContacts$year TotalAgeCat2013 TotalAgeCat2008, i(AgeCatNum) j(RegionNum) 
	keep AgeCatNum TotalGPperperson*
	ren TotalGPperperson1 Denmark
	ren TotalGPperperson2 Capital 
	ren TotalGPperperson3 Zealand
	ren TotalGPperperson4 Southern 
	ren TotalGPperperson5 Central
	ren TotalGPperperson6 Northern		
	label variable Denmark "Total"
	label variable Capital "Capital Region of Denmark"
	label variable Zealand "Region Zealand"
	label variable Southern "Region of Southern Denmark"
	label variable Central "Central Denmark Region"
	label variable Northern "Region of Northern Denmark"
save OutputSTATA/Figure4_$year, replace

