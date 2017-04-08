cap pr drop lower_varnames 
program lower_varnames
	version 10.0
	foreach var of varlist _all {
		cap ren `var' `=lower("`var'")'
	}
end

