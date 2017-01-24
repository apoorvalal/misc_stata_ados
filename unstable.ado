* !CJM 20012017
*********************************
*Unstable
*********************************
//Checks for variation in variable(s) across other variable(s)
capture program drop unstable
program define unstable
    syntax varlist, by(str) [g(str)]
    
    tempvar gtemp
    gen `gtemp' = 0 
    
    foreach var in `varlist'{
        tempvar tvar
        egen `tvar' = sd(`var'), by(`by')
        qui replace `tvar' = 0 if `tvar' == .
        qui replace `tvar' = 1 if `tvar' > 0
        
        qui replace `gtemp' = `gtemp' + `tvar'
        drop `tvar'
    }
    
    tab `gtemp'
    qui replace `gtemp' = 1 if `gtemp' > 1
    
    if(`r(r)' != 1 ){
        capture gen `g' = `gtemp'
    }
    
    drop `gtemp'
    
end
