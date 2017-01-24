* !CJM 20012017
*********************************
*Duprep
*********************************
//Gives a report on duplicate values
capture program drop duprep
program define duprep
    syntax varlist, [gs(str)] [gd(str)]
    tempvar group max
                    
    qui egen `group' = group(`varlist')
    qui summ `group' 
    local obs = r(N)
    display ""
    display "*______`varlist'______*"
    *Note that if any variable in varlist is missing, the value is non-populated
    display "Distinct populated obs: " %-15.4gc r(max)
    if(r(N) == r(max)){
        display "No duplicates"
    }
    if(r(N) > r(max)){
        qui bys `varlist': gen `max' = _N
        qui replace `max' = . if `group' == .
        
        qui count if `max' == 1
        display "% Singletons: " round(r(N)/`obs',.0001)*100
        qui sum `max'
        display "Min obs: " %-15.4gc r(min)
        display "Mean obs: " %-15.2fc round(r(mean), .01)
        display "Max obs: " %-15.4gc r(max)
        
        capture gen `gs' = (`max' == 1) 
        capture gen `gd' = (`max' != 1 & `max' != .) 
        drop `max'
        
    }
    display "% of obs with missing values: " round((_N -`obs')/_N, 0.0001)*100
    drop `group'
    display ""
                    
end
