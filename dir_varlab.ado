* ! V0.1 08082019, Apoorva Lal
cap pr drop dir_varlab
pr define dir_varlab
    /*
    bulk export metadata for all dta files in folder
     */
    args p
    local files : dir "`p'" files "*.dta"
    foreach f in `files' {
      use "`p'/`f'", clear
      loc outfile = subinstr("`f'",".dta","_cb.csv",1)
      varlabelbook // personal ado file
      export delimited using "`p'/`outfile'", replace 
    }
end


