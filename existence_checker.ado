* ! V0.1 15052018, Apoorva Lal
cap pr drop existence_checker
pr def existence_checker, rclass
  /*
  checks whether each variable in varlist exists. Better than confirm
  because it doesn't fail after the first nonexisting variable
	*/
  syntax [anything]
  loc existing_vars ""
  loc nonexisting_vars ""
  foreach v in `anything' {
    cap conf variable `v'
      if !_rc {
        loc existing_vars `existing_vars' `v'
      }
      else {
        loc nonexisting_vars `nonexisting_vars' `v'
      }
  }
  di in red "Nonexisting Vars: `nonexisting_vars'"
  di in green "Existing Vars: `existing_vars'"
 	return local exist "`existing_vars'"
 	return local nexist "`nonexisting_vars'"
end
