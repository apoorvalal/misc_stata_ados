* !V0.1 ALAL 20012017
cap pr drop count_uniq
pr count_uniq, rclass sortpreserve byable(recall)
  /*
  counts unique values of a variable (by group or based on condition)
	*/
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
