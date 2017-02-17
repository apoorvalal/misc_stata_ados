cap pr drop cond_stitcher
pr def cond_stitcher, rclass 
	// stitches together a long OR or AND statement given an array of dummy variables
	syntax anything , SEPerator(string)
	tokenize `anything'
	loc cond "if"
	while "`1'" != "" {
		if "`2'" == "" {
			loc separator ""
		}
		loc cond `cond' `1' `separator'
		macro shift
	}
	return local condition = "`cond'"
end
