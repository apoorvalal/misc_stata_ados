*! Apoorva Lal V-0.1
// creates an entire path at once (rather than 1 folder at a time with mkdir)
pr def pathmake
	version 10
	args p
	loc cwd = "`c(pwd)'"
	loc makedir mkdir
	if "`p'" == "" {
		di as error "pathmake needs an argument"
		error
	}
	loc p = subinstr("`p'","\","/",.)
	tokenize "`p'", p("/")
	loc st = 1
	loc tmp = ""
	if substr("`p'",1,2) == "//" {
		forv i = 1/5 {
			loc temp "`temp'``i''"
		}
		qui cd "`temp'"
		loc st = 6
	}
	loc i = `st'
	while "``i''" != "" {
		if "``i''" != "/" & "`"i"'" != "" {
			cap cd "``i''/"
			if _rc != 0 {
				`makedir' "``i''"
				qui cd "``i''/"
				if "``=`i'+1''" == "" {
					di in white "pathmake: generated path ", _c
					pwd
				}
			}
			if _rc == 0 & "``=`i'+1''" == "" {
				di in white "pathmake: path already exists;", _c
				pwd
			}
		}
		loc ++i
	}
	qui cd "`cwd'"
end

