* !ALAL 20022017
/*  winsorizes variable specified either at cutpoints specified
 OR limits (where 5 = 5th and 95th percentile ), and optionally 
 generates variable specified in generate
 */
pr def winsorize, rclass
	version 10
	syntax varlist [, GENerate(name) AT(numlist max = 2) LIMits(numlist)]
	loc ncutpoints : list sizeof at
	if `ncutpoints' > 2 {
		di "Cannot have more than 2 cutpoints"
		error
	}
	else if `ncutpoints' > 0 {
		if `ncutpoints' != 1 {
			tokenize `at'
			loc lower `1'
			loc upper `2'
		}
		else {
			loc lower 0
			loc upper `at'
		}
	}
	else {
		loc lower 0 
		loc upper 99
	}
	if "`limits'" != "" {
		loc lower `limits'	
		loc upper `=1-`limits''
	}
	if "`generate'" != "" {
		loc targetvar `generate'
		g `targetvar' = `varlist'
	}
	else {
		loc targetvar `varlist'
	}
	if `lower' != 0 {
		_pctile `varlist' , p(`lower' `upper')
		loc ll = r(r1)
		loc ul = r(r2)
		replace `targetvar' = `ll' if `varlist' == `ll'
	}
	else {
		_pctile `varlist' , p(`upper')
		loc ul = r(r1)
		loc ll "."
	}
	replace `targetvar' = `ul' if `varlist' > `ul'
	return scalar lower = `ll'
	return scalar upper = `ul'
	return local targetvar `targetvar'
end

