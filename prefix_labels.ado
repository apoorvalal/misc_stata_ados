// Apoorva Lal
// V 1.0
pr prefix_labels
	version 8
	syntax varlist 
	/*
	SYNTAX:
	fix_labels var1 var2 ... 
	*/
	foreach v in `varlist'	 {
		cap conf var `v'
		if !_rc {
			qui levelsof `v', loc(`v'_l) clean
			loc vla_`v': var l `v'
			loc vla_`v' = cond("`vla_`v''"=="","`v'","`vla_`v''")
			loc la_`v': val l `v'
			loc label_exists = cond("`la_`v''" != "",1,0)
			foreach val in ``v'_l' {
				if `label_exists'{
					loc curr_value_label: label `la_`v'' `val'
					la def `v'_lab_new `val' "`v': `curr_value_label'",modify
				}
				else {
					la def `v'_lab_new `val' "`v': `val'", modify
				}
			}
			la val `v' `v'_lab_new
		}
		else noi di "variable `v' not found"
	}
end

