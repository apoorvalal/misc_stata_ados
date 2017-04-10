*! V0.1 31012017 Apoorva Lal
/*  
takes variable and cutpoints and generates dummies 
example:
partition_var age, cut(0 35 50 75) prefix(age)
generates:
a_0_35
a_36_50
a_51_75
a76
*/
cap pr drop partition_var

pr partition_var, rclass
	syntax varname, CUTpoints(numlist min=1) PRefix(string)
	qui su `varlist', d
	loc m = r(max)
	loc n_bins : list sizeof cutpoints
	qui ds 
	loc oldvarlist `r(varlist)'
	tokenize `cutpoints'
	forv i = 1/`n_bins' {
		loc j = `i' + 1
		loc a = real("``i''") + 1*(`i'!=1)
		loc b = real("``j''")
		if `i' == `n_bins' {
			loc b = ceil(`m')
		}
		g `prefix'_`a'_`b' = inrange(`varlist',`a',`b')
		loc lab "`varlist' : `a' to `b'"
		la var `prefix'_`a'_`b' "`lab'"
	}
	ren `prefix'_`a'_`b' `prefix'_`a'
	qui ds
	loc newvarlist `r(newvarlist)'
	loc newvars: list newvarlist - oldvarlist
	return local newvars `newvars'
end
