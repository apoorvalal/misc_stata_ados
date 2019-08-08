* ! V0.1 08082019, Apoorva Lal
cap pr drop dir_varlab
pr define dir_varlab
    /*
    bulk export metadata for folders of dta
     */
    args p
    local files : dir "`p'" files "*.dta"
    cd `p'
    foreach f in `files' {
      use "`f'", clear
      loc outfile = subinstr("`f'","dta","csv",1)
      loc outfile "cb_`outfile'"
      varlabelbook
      export delimited using "`outfile'", replace 
    }
end


