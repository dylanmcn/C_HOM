/* Estimate county-by-year price indices and plots coastal price indexes over time
 *
 * Version 2 (May 2023) Aggregate price indices and plot county-level prices
 * Version 1 (September 2022) Price indices estimated at the blk-grp from Core Logic data 
 */

#delim;
clear;
clear matrix;
set mem 4g;
set more off;
set matsize 10000;

/********************************************************************/
/* Step 1:  Load data and Estimate Price Indices at the County-level*/
/********************************************************************/

/*

/*REGRESSION ANALYSIS TO ESTIMATE COUNTY LEVEL PRICE INDICES REQUIRE PROPRIETARY SALES TRANSACTION DATA */

/* Set Globals */
global geo "tract fips blkgrp"
global time "year quarter"

foreach g of global geo {
	foreach t of global time {
		di "---------------------------------------------------" 

scalar ng = 3
forvalues key=1/`=ng' {
	display `key'
	if `key'==1 {
	**Block group by year price index
	global geo "blkgrp"
	global time "year"
	}
	else if `key'==2 {
	**Census tract by year price index
	global geo "tract"
	global time "year"
	}
	else if `key'==3 {
	**County by year price index 
	global geo "fips"
	global time "year"
	}
	

		timer on 1
		use data/appendcsv/sale_trim.dta,clear /* Sales transaction from proprietary Core Logic Data */
		dis "data loaded for `g'_`t'"
		gen dummy_s=`g' + `t'
		*gen dummy_s = blkgrp+year
		destring dummy_s,gen(dummy_n)
		format %20.0g dummy_n

		xtset dummy_n

		dis "Hedonic regressionon Structural Attributes"
		preserve 
		eststo basic: xtreg log_price acres living stories garage_ind pool_ind, fe
		esttab basic using "index/`g'_`t'.rtf", replace wide
		predict fe, u
		gen index_b=fe+ _b[_cons]
		sort dummy_n
		collapse (mean) index_b, by(`g' `t')
		label var index "Price index by $geo and $time, controlling for basic covariates"
		save "index/`g'_`t'.dta", replace 
		restore

		dis "regression on additional variables"
		preserve 
		eststo additional: xtreg log_price acres living bedrooms age garage_ind pool_ind, fe
		esttab additional using "index/`g'_`t'.rtf", append wide
		predict fe, u
		gen index_a=fe+ _b[_cons]
		sort dummy_n
		collapse (mean)index_a, by(`g' `t')
		label var index_a "price index by $geo and $time, with additional covariates"
		merge 1:1 `g' `t' using "index/`g'_`t'.dta"
		drop _merge
		save "index/`g'_`t'.dta", replace 
		restore


		timer off 1
		timer list 1
	}
	
}

*/

/**********************************************************************************************************/
/* Step 2:  Load county x year price indices from hedonic reg and merge 2010 population by county */
/**********************************************************************************************************/

#delim;
use "county_yearly_price_index_V5.dta", clear;

summarize;
sort countyid year;

/* Merge 2010 Population by County*/

#delim;
use "county_population_est_2000_2010.dta", clear;

rename stname statename;
rename ctyname countyname;

merge m:m statename countyname using "county_yearly_price_index_V5.dta", 
keepusing(countyid countyname statename);

keep if _merge == 3;
drop _merge sumlev region division state;

order county countyid;
keep county countyid statename countyname census2010pop;
sort countyid statename countyname;

save "county_pop_2010.dta", replace;

#delim;
use "county_yearly_price_index_V5.dta", clear;
sort countyid statename countyname year;
merge m:m countyname statename using "county_pop_2010.dta", 
keepusing(countyid statename countyname census2010pop);

drop _merge;
sort countyid statename countyname year;

save "county_yearly_price_index_V6.dta", replace;

/********************************************************************************************************/
/* Step 3:  Aggregate Price indices by inland vs coastal counties and PLOT population weighted indices */
/*******************************************************************************************************/

/* Collapse price_index by county by state by Year*/
#delim;
use "county_yearly_price_index_V6.dta", clear;

gen pop_10 = 0;
gen pop_90 = 0;

replace pop_10 = 1 if census2010pop < 16500;
replace pop_90 = 1 if census2010pop > 500000;

collapse (first) statename (mean) east_coast (mean) gulf_mexico (mean) index (mean) index_5 [aweight = census2010pop], by(state year shoreline_county);

twoway ((line index_5 year if shoreline_county == 1) (line index_5 year if shoreline_county == 0), by(state));

save "county_yearly_price_index_V7.dta", replace;

/* Collapse price index by coastal vs non-coastal counties*/

#delim;
use "county_yearly_price_index_V7.dta", clear;
gen price = exp(index);

collapse (mean) index index_5 (mean) price, by(year shoreline_county);

twoway (line price year if shoreline_county == 1) (line price year if shoreline_county == 0);
twoway (line index_5 year if shoreline_county == 1) (line index_5 year if shoreline_county == 0);

save "county_yearly_price_index_V8.dta", replace;
