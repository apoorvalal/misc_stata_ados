* ! V0.1 08082019, Apoorva Lal
cap pr drop dir_to_csv
pr define dir_to_csv
    /*
    bulk export to csv
     */
    args p
    local files : dir "`p'" files "*.dta"
    foreach f in `files' {
      use "`p'/`f'", clear
      loc outfile = subinstr("`f'","dta","csv",1)
      qui compress
      export delimited using "`p'/`outfile'", replace 
    }
end


