*! v1.0 Apoorva Lal
* drops variables with only missing values (and returns a local list of these vars)
program define drop_missing, rclass
    loc allmissing ""
    foreach v of varlist _all {
        cap assert mi(`v')
        if !_rc {
            drop `v'
            loc allmissing `allmissing' `v'
        }
    }
    return local dropped "`allmissing'"
end
