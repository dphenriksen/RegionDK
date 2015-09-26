*****
** MASTER - Demographic characteristics of the five Danish regions.
** Authors: Daniel Pilsgaard Henriksen <dphenriksen@health.sdu.dk>, Lotte Rasmussen <lorasmussen@health.sdu.dk>
** Code reviewed by: Morten Olesen <moolesen@health.sdu.dk>, Anton Pottegård <apottegaard@health.sdu.dk>
** Date: 2015-05-06
** Revision: 1.0
** Date 2015-15-09: addition of CV calculation of proportions in Table1, Lotte Rasmussen <lorasmussen@health.sdu.dk>
*****

set more off, perm
cap log close
cd  /Users/dphenriksen/Data/RegionDK
local logtime = "OutputLOGS/" + string(d(`c(current_date)'), "%dCY-N-D" ) + " " + subinstr(c(current_time), ":", ".",.)+" `c(username)'.log"
log using "`logtime'"

* Dataload
do Program/Dataload

* Analysis
foreach zz in 2008 2013 {
	global year=`zz'

* Output	
	do Program/Table1
	do Program/Table2
	do Program/Table3
	do Program/Figure2ABC
	do Program/Figure3
	do Program/Figure4
	}
do Program/Graphs
log close
