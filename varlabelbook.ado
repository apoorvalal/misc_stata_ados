*! v0.1 Apoorva Lal
// returns dataset with dataset's <describe> output
// useful for very wide datasets / datasets with useless/uninformative
// variable names
// e.g. USAID's Demographic and Health Surveys

pr define varlabelbook
    syntax [anything]
    qui compress
    qui ds `anything'
    loc vl "`r(varlist)'"
    loc nrows: word count `vl'
    forv i = 1/`nrows' {
        loc vname_`i'    :word `i' of `vl'
        loc var_label_`i':var l `vname_`i''
        loc type_`i'     :type `vname_`i''
        if inlist("`type_`i''", "byte","int") {
            count_uniq `vname_`i''
            loc distinct_vals_`i' = `r(nv)'
            if `r(nv)' <= 20 {
                loc la_`vname_`i'': val l `vname_`i''
                loc label_exists = cond("`la_`vname_`i'''" != "",1,0)
                if `label_exists'{
                loc values_and_labels_`i' ""
                qui levelsof `vname_`i'', loc(`vname_`i''_l) clean
                    foreach val in ``vname_`i''_l' {
                        loc vlab: label `la_`vname_`i''' `val'
                        loc curr_value_label = subinstr("`vlab'",`"""',"",.)  // " for pesky embedded quotes
                        loc values_and_labels_`i' "`values_and_labels_`i''; `val': `curr_value_label'"
                    }
                }
            }
        }
        else {
            if "`=substr("`type_`i''",1,3)'" ==  "str" {         // "
                count_uniq `vname_`i''
                loc distinct_vals_`i' = `r(nv)'
            }
            else {
                loc distinct_vals_`i' = 99999 // set number of distinct values to 99999 if
            }
        }
    }
    qui count
    loc nobs_tot `r(N)'
    clear
    set obs `nrows'
    qui g variable = ""
    qui g type = ""
    qui g var_label = ""
    qui g distinct_vals = .
    qui g vals_and_labels = ""
    qui replace variable = "NObs" if _n == 1
    qui replace distinct_vals = `nobs_tot' if _n == 1
    forv i = 2/`nrows' {
        qui replace variable        = "`vname_`i''"             if _n == `i'
        qui replace var_label       = "`var_label_`i''"         if _n == `i'
        qui replace distinct_vals   = `distinct_vals_`i''       if _n == `i'
        qui replace type            = "`type_`i''"              if _n == `i'
        qui replace vals_and_labels = "`values_and_labels_`i''" if _n == `i'
    }

end
