*! V0.1 31012017, Apoorva Lal
// wrapper for tab / tab2 that adds value prefixes for factor variables
cap pr drop bettertab
pr def bettertab 
	version 6
	syntax varlist [if] [in]
	marksample touse
	loc nvars : list sizeof varlist
	if `nvars' == 1 {
		loc tabcmd tab
	}
	else {
		loc tabcmd tab2
	}
	loc label_list ""
	foreach v in `varlist' {
		cap conf var `v'
		if !_rc {
			loc la_`v': value label `v'
			loc label_list `label_list' `la_`v''
		}
		else {
			noi di "`v' not found"
			error
		}
	}
	numlabel `label_list', add
	`tabcmd' `varlist'
	numlabel `label_list', remove
end
