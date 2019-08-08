
/*cap pr drop codebook_dir*/
pr define dir_varlab.ado
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


