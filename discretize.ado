cap pr drop discretize
pr def discretize, rclass
	/*
	Discretises specified variable by constructing bins based
	on provided cutpoints / N number equal sized bins based on provided 
	NBins 
	*/  

	syntax varlist, GENerate(name) [CUTpoints(numlist) NBins(numlist)]
	if "`nbins'" != "" {
		loc increments = 100/`nbins'
		loc cutpoints ""
		forv i = `increments'(`increments')100 {
			if `i' < 100 {
				loc cutpoints `cutpoints' `i'
			}
		}	
	}
	loc ncutpoints: list sizeof cutpoints
	loc resolved_list ""
	_pctile `varlist',p(`cutpoints')
	forv i = 1/`ncutpoints' {
		loc resolved_list `resolved_list', `r(r`i')'
 	}
 	loc resolved_list `=substr("`resolved_list'",2,.)'
 	g `generate'=irecode(`varlist',`resolved_list')+1
 	if "`nbins'" != "" {
 		qui su `generate'
 		qui replace `generate' = `nbins' if `generate' > `nbins'
 	}
 	return local r_cut "`resolved_list'"
end
