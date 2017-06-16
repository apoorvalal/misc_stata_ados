* v 1.0 052017, Apoorva Lal
// wrapper for ds that doesn't inexcplicably abbreviate variables
program define ds2, rclass
	syntax [anything]
	qui ds `anything'
	noi di "`r(varlist)'"
	return loc varlist = "`r(varlist)'"
end
