// Apoorva Lal
// V 1.0
program define freq_table
	version 10
	/*
	SYNTAX:
	freq_table var1 var2 i.var3 i.var4#i.var4
	*/
	syntax anything // not quite, but easist to handle programmatically this way

	loc codedir "`c(pwd)'"
	qui cd "`codedir'"

	loc temp1 : list clean anything
	loc temp2 : list uniq temp1
	loc var: list clean temp2
	loc masterdata "`c(filename)'"
	qui count
	sca denom = `r(N)'

	tokenize `var'
	loc n: word count `var'

	preserve
	qui {
		clear
		set obs 1
		g raw = "ALL"
		g label = "ALL"
		g count = denom
		qui compress 
		tempfile t0
		save "`t0'", replace
	}
	restore 
	qui {
		forv i = 1/`n' {
			preserve 
			loc prefix = substr("``i''",1,2)

			if ("`prefix'" == "i.") {			// stata's dummy notation
				loc interaction_split1 = strpos("``i''","*")
				loc interaction_split2 = strpos("``i''","#")
				loc interaction_split = max(`interaction_split1',`interaction_split2')
				if `interaction_split' != 0 {
					loc suffix1 = substr("``i''",3,`interaction_split'-3)
					cap conf var `suffix1'
					if _rc {
						noi di as error "`suffix1' does not exist." 
						error
					}
					loc suffix2 = substr("``i''",`interaction_split'+3,.)
					cap conf var `suffix2'
					if _rc {
						noi di as error "`suffix2' does not exist"
						error
					}
					forv x = 1/2 {
						qui levelsof `suffix`x'', clean loc(`suffix`x''_levels) miss
						loc n_var`x': list sizeof `suffix`x''_levels
						loc lab`x' : var l `suffix`x''
						if "`lab`x''" == "" loc lab`x' `suffix`x''
						loc vlab`x' : val l `suffix`x''
						cap conf string var `suffix`x''
						if !_rc {
							loc counter_type`x' string
						}
						else {
							loc counter_type`x' numeric
						}
					}

					loc x = 1
					foreach a in ``suffix1'_levels' {
						foreach b in ``suffix2'_levels' {
							if "`vlab1'" != "" loc val_lab1: lab `vlab1' `a'
							else loc val_lab1 "`a'"
							if "`vlab2'" != "" loc val_lab2: lab `vlab2' `a'
							else loc val_lab2 "`b'"

							loc raw`x' = "`suffix1' == `a' X `suffix2' == `b' "
							loc labels`x' = "`lab1' == `val_lab1' X `lab2' == `val_lab2'"
							if "`counter_type1'" == "string" & ///
								 "`counter_type2'" == "string" {
								qui count if `suffix1' == "`a'" & `suffix2' == `b'
							}
							else if "`counter_type1'" == "numeric" & ///
								 "`counter_type2'" == "string" {
								 qui count if `suffix1' == `a' & `suffix2' == "`b'"
							}
							else if "`counter_type1'" == "string" & ///
								 "`counter_type2'" == "numeric" {
								 qui count if `suffix1' == "`a'" & `suffix2' == `b'
							}
							else if "`counter_type1'" == "numeric" & ///
								 "`counter_type2'" == "numeric" {
								 qui count if `suffix1' == `a' & `suffix2' == `b'
							}
							sca N_`x' = `r(N)'
							loc ++x
						}
					}
				}
				else {
					loc suffix1 = substr("``i''",3,.)
					cap conf var `suffix1'
					if _rc {
						noi di as error "`suffix1' does not exist." 
						error
					}
					loc x 1
					qui levelsof `suffix`x'', clean loc(`suffix`x''_levels) miss
					loc n_var`x': list sizeof `suffix`x''_levels
					loc lab`x' : var l `suffix`x''
					if "`lab`x''" == "" loc lab`x' `suffix`x''
					loc vlab`x' : val l `suffix`x''
					cap conf string var `suffix`x''
					if !_rc {
						loc counter_type`x' string
					}
					else {
						loc counter_type`x' numeric
					}
					loc x = 1
					foreach a in ``suffix1'_levels' {	
						if "`vlab1'" != "" loc val_lab1: lab `vlab1' `a'
						else loc val_lab1 "`a'"
						loc raw`x' = "`suffix1' == `a'"
						loc labels`x' = "`lab1' == `val_lab1'"
						if "`counter_type1'" == "string" {
							qui count if `suffix1' == "`a'" 
						}
						else if "`counter_type1'" == "numeric" {
							qui count if `suffix1' == `a' 
						}
						sca N_`x' = `r(N)'
						loc ++x
					}
				}

			}
			else {
				cap conf var ``i''
				if !_rc {
					loc lab : var l ``i''
					if "`lab'" == "" loc lab ``i''
					loc raw1 = "``i''"
					loc labels1 = "`lab' == 1"
					qui count if ``i'' & !mi(``i'')
					sca N_1 `r(N)'
					loc x = 2
				}
				else {
					di as error "``i'' does not exist"
					error
				}				
			}
			clear
			set obs `=`x'-1'
			g raw = "" 
			g label = ""
			g count = 0
			forv r = 1/`=`x'-1' {
				replace raw = "`raw`r''" if _n == `r'
				replace label = "`labels`r''" if _n == `r'
				replace count = N_`r' if _n == `r'
			}
			g pct = count/denom
			tempfile t`i'
			save "`t`i''", replace
			restore
		}
		clear
		use "`t0'", clear
		forv f = 1/`n' {
			append using "`t`f''"
		}
	}
end
