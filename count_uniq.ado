pr count_uniq, rclass sortpreserve byable(recall)
	version 10
	syntax varlist [if] [in]  
	marksample touse, strok  
	qui {		
		tempvar tag
		bys `varlist': g byte `tag'= _n==1   
		count if `tag'==1 
		ret scalar nv = r(N)		
	}
end
