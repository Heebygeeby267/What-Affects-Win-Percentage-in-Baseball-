*Geoffrey Hebertson and Deepak Basnet
*ECON 643 Group Project Dr. Straub
*Sabermetrics - What Is the Effect Of Total Salary Have An Effect On A Team's Win Percentage?

*Data source from http://www.seanlahman.com and 
*http://www.thebaseballcube.com/extras/payrolls/

*Combined together in excel made for this project

set more off

clear all
*Clear all stored data and graphs out of RAM


import delimited "/Users/gheberts/Dropbox/School/ECON 643/Group Project/Excel Data/Team Data 1871_2015.csv", encoding(ISO-8859-1)
*Geoff's Macbook

*Rename common baseball statistical variables to their common Sabermetric ID
rename games g
rename wins w
rename loses l
rename runs r
rename atbats ab
rename hits h
rename doubles db
rename triples tb
rename homeruns hr
rename walks bb
rename strikeouts so
rename stolenbases sb
rename caughtstealing cs
rename hitbypitch hbp
rename sacrificefly sf
rename runsallowed ra
rename earnedruns er
rename earnedrunsaverage era
rename completedgames cg
rename shutouts sho
rename saves s
rename outspitched iop
rename hitsallowed ha
rename homerunsallowed hra
rename walksallowed bba
rename strikeoutsallowed soa
rename errors e
rename fieldingpercentage fp
rename totalsalarymillions payroll
rename league lg
label var attendance "Attendance"
label var payroll "Total Payroll by Team; Adjusted for Inflation (2015 Dollars)"


drop if year < 2006
*Drops all observations before 2006

replace payroll = payroll*(242.247/205.9) if year == 2006
replace payroll = payroll*(242.247/210.729) if year == 2007
replace payroll = payroll*(242.247/215.572) if year == 2008
replace payroll = payroll*(242.247/219.235) if year == 2009
replace payroll = payroll*(242.247/221.337) if year == 2010
replace payroll = payroll*(242.247/225.008) if year == 2011
replace payroll = payroll*(242.247/229.755) if year == 2012
replace payroll = payroll*(242.247/233.806) if year == 2013
replace payroll = payroll*(242.247/237.897) if year == 2014

*Adjusted inflation payroll by year to 2015 dollars

encode lg, gen(league)
label var lg "League"
drop lg
*Converts league from a string to a numerical value and drops league from data
*set

encode divwin, gen(dvwin)
label var dvwin "Division Win"
drop divwin

encode wcwin, gen(wcwin2)
label var wcwin2 "WC Win"
drop wcwin

encode lgwin, gen(leaguewin)
label var leaguewin "League Win"
drop lgwin

encode wswin, gen(wswin2)
label var wswin2 "World Series Win"
drop wswin
 
sum
*Produce standard descriptive statistics for all years 2006-2015

bys league: sum 
*Standard descriptive statistics for years 2006-2015 

*bys year league: sum
*Standard descriptive statistics for each year by league

bys league: sum w payroll, detail
*Detailed descriptive statistics for years 2006-2015 over wins and payroll


*bys year league: sum w payroll
*Standard descriptive statistics for each year by league

bys league: centile w, centile (0 1 2 5 10 25 50 75 90 95 99 100)
*Centile of win percent over all years combined, by league

bys league: centile payroll, centile (0 1 2 5 10 25 50 75 90 95 99 100)
*Centile of payroll over all years, by league

*bys year league: centile w, centile (0 1 2 5 10 25 50 75 90 95 99 100)
*Descriptive statistic about the winning percentage of every team in the MLB by
*year, divided between AL and NL

*bys year league: centile payroll, centile (0 1 2 5 10 25 50 75 90 95 99 100)
*Descriptive statistic about the payroll of every team in the MLB,
*by year and divided between divided between AL and NL

bys league: corr w payroll
*Define correlation between win percentage and payroll, by league

*bys year league: corr w payroll
*Correlation between win percent and payroll by year and league

twoway (scatter w payroll if league == 2) (lfit w payroll if league == 2), ytitle(Wins) ytitle() yscale(titlegap(5)) xtitle(Total Salary (Millions)) xtitle() xscale(titlegap(5)) title(Wins vs Total Salary) subtitle(National League: 2006-2015) caption(National League) note(Source: seanlahman.com and thebaseballcube.com) legend(off) name(NL)
*Scatter graph with linear prediction of National League Win Percent and Payroll

twoway (scatter w payroll if league == 1) (lfit w payroll if league == 1), ytitle(Wins) ytitle() yscale(titlegap(5)) xtitle(Total Salary (Millions)) xtitle() xscale(titlegap(5)) title(Wins vs Total Salary) subtitle(American League: 2006-2015) caption(American League) note(Source: seanlahman.com and thebaseballcube.com) legend(off) name(AL)
*Scatter graph with linear prediction of American League Win Percent and Payroll

gr combine NL AL
*Combined graph showing win percentage and payroll for both league

bys league: regress w payroll
*Sorting by league, regress winpercentage (Y) to payroll (X) over all years


reg w payroll r ab h db tb hr bb so sb cs hbp sf if league == 1
*Initial  multiple regression on American League that tests wins as the dependent variable, 
*payroll as the independent variable, and with all relevant batting statistics.

test h db tb hr bb so sb cs hbp sf
*Test to evaluate signficance of variables that were not significant in the regression

reg w payroll r ab
*Regression omitting the tested variables that proved to not be significant.


reg w payroll r ab h db tb hr bb so sb cs hbp sf if league == 2
*Initial  multiple regression on National League that tests wins as the dependent variable, 
*payroll as the independent variable, and with all relevant batting statistics.

test ab h db bb so sb cs hbp sf
*Test to evaluate signficance of variables that were not significant in the regression


bys league: reg w payroll r ab h db tb hr bb so sb cs hbp sf ra er era fp s sho ha hra bba soa e doubleplays
*Multiple regression that includes all relevant variables, most notably pitching
*data to determine if there is a omitted variable bias.





