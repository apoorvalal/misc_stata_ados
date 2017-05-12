* ! V0.1 30042017, Apoorva Lal
cap program drop dtimer
program dtimer
	args tp i
	if !inlist("`tp'","on","off") {
		di as error "Enter on or off as parameter"
		noi error
	}
	if "`i'" == "" loc i 100
	if "`tp'" == "on" {
		timer clear `i'
		timer on `i'
	}
	if "`tp'" == "off" {
		timer off `i'
		qui timer list `i'
		loc mins `r(t`i')'/60
		loc seconds `r(t`i')'
		di as result "{hline}"
		di as text "---- Runtime -------"
		foreach t in seconds minutes {
			di as text "In `t':", _continue
			di as result %12.0g round(``t'',.01)
		}
		di as result "{hline}"
	}
end
