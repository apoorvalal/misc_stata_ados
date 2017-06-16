capture program drop dot_product
program define dot_product, rclass
	syntax namelist(min=3)
	loc targetvar `: word 1 of `namelist''
	loc vector `: word 2 of `namelist''
	cap conf matrix `vector'
	if _rc {
		noi di as error "matrix `vector' not found"
		exit
	}
	loc firsttwo `vector' `targetvar'
	loc xvars : list namelist - firsttwo
	loc ndim : list sizeof xvars
	loc rows `=rowsof(`vector')'
	loc cols `=colsof(`vector')'
	if `rows' != `ndim' {
		noi di as result "`vector' needs to be a column vector (N X 1) matrix where N == number of covars"
		if `cols' == `ndim' {
			noi di as result "Using transpose of `vector' instead"
			mat `vector'_t = `vector''
			loc coeffVector `vector'_t
		}
		else {
			noi di as error "Conformability error : coefficient vector not the same size as design matrix"
			exit
		}
	}
	else {
		loc coeffVector `vector'
	}
	mat coeffs = `coeffVector'
	qui mata: matrix_multiply("`xvars'","coeffs","`targetvar'")
end

mata:
void matrix_multiply(string scalar varlist, string scalar CoeffMatrix, ///
	 			string scalar newvar) {
	real matrix X
	B = st_matrix(CoeffMatrix)
	st_view(X=.,.,tokens(varlist),)
	product = X*B
	st_addvar("double",(newvar))
	st_store(.,newvar,product)
}
end
