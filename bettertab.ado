*! V0.1 31012017, Apoorva Lal
// wrapper for tab / tab2 that adds value prefixes for factor variables and tabulates missing values by default
cap pr drop bettertab
pr def bettertab 
	version 6
	syntax varlist [if] [in] [, NMissing]
	marksample touse, novarlist // without novarlist, marksample drops missing values
	loc nvars : list sizeof varlist
	if `nvars' == 1 {
		loc tabcmd tab
	}
	else {
		loc tabcmd tab2
	}
	if "`nmissing'" != "" {
		loc opt " "
	}
	else {
		loc opt ", m"
	}

	loc label_list ""
	foreach v in `varlist' {
		cap conf var `v'
		if !_rc {
			loc la_`v': value label `v'
		}
		else {
			noi di "`v' not found"
			error
		}
	}
	cap numlabel `label_list', add
	`tabcmd' `varlist' if `touse'`opt'  
	cap numlabel `label_list', remove
end
