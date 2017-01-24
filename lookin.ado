* !CJM 20012017
*********************************
*Lookin
*********************************
//Looks for matching strings within other string variables
capture program drop lookin
program define lookin
    syntax varlist, for(str) [g(str)]    
	tempvar temp
	qui gen `temp' = 0
	foreach var in `varlist'{
	    tempvar lvar
	    gen `lvar' = lower(`var')
	    qui replace `temp' = `temp' + strpos(`lvar', "`for'")
	    drop `lvar'
	}
	qui replace `temp' = `temp' > 0
	assert `temp' != . 
	qui summ `temp'
	if(r(max) == 0){
	    display "`for' not found in `varlist'. Remember to use lowercase"
	}
	if(r(max) > 0){
	    display "`for' found in `varlist'"
	    capture rename `temp' `g'
	}
	capture drop `temp'
	display ""
	end
