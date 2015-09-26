*****
** GRAPHS
*****

* Figure 2A-C
set scheme s2color
foreach xx in Figure2A_2008 Figure2A_2013 Figure2B_2008 Figure2B_2013 Figure2C_2008 Figure2C_2013 {
	use OutputSTATA/`xx', clear
		twoway(line Denmark Capital Zealand Southern Central Northern AgeCatNum, graphregion(fcolor(white)) lwidth(thick)), ytitle("Proportion of residents (%)") ///
		xtitle(Age categories) xlabel(#10, labels valuelabel)	
graph export OutputGRAPH/`xx'.tif, replace 
}

* Figure 4
set scheme s2color
foreach xx in Figure4_2008 Figure4_2013 {
	use OutputSTATA/`xx', clear
		if "`xx'"=="Figure4_2008" {
		twoway(line Denmark Capital Zealand Southern Central Northern AgeCatNum, graphregion(fcolor(white)) lwidth(thick)), ytitle("Mean number of GP contacts 2008") ///
		xtitle(Age categories) xlabel(#10, labels valuelabel)	
		}
		if "`xx'"=="Figure4_2013" {
		twoway(line Denmark Capital Zealand Southern Central Northern AgeCatNum, graphregion(fcolor(white)) lwidth(thick)), ytitle("Mean number of GP contacts 2013") ///
		xtitle(Age categories) xlabel(#10, labels valuelabel)	
		}
graph export OutputGRAPH/`xx'.tif, replace 
}
