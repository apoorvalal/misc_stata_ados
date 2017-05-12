* ! V0.1 30042017, Apoorva Lal
cap pr drop okeep
ver 10.0
pr def okeep, nclass
	syntax varlist
	keep `varlist'
	order `varlist'
end
