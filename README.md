# misc_stata_ados
Misc Utility programs in Stata. Brief intros below.

## freq_table
Replaces dataset in memory with a frequency table of variables and interactions. Accepts dummy variables, factor variables, and their interactions. 
Example of use:
```stata
  use exampledata, clear // contains individual level data on income, sex, education, country, rural/urban location
  gl rhs_vars female rur_urb i.educ i.country i.education#i.country
  preserve
  freq_table $rhs_vars
  save freqs, replace
  restore
```
freqs.dta now contains:

| Raw                       | Label                                         | Count | Pct  |
|---------------------------|-----------------------------------------------|-------|------|
| rur_urb == 1              | Urban == 1                                    | 24    | 0.2  |
| educ == 1                 | Education == No HS                            | 43    | 0.36 |
| educ == 2                 | Education == HS                               | 40    | 0.33 |
| educ == 3                 | Education == College                          | 24    | 0.2  |
| educ == 1 X country == 2  | Education == No HS X Country == United States | 12    | 0.1  |

and so on. 

This produces a labelled table (by extracting appropriate variable and value labels, if they exist) of counts for dummies (e.g. female, rur_urb), each level of factor variables (i.education, i.country) and each cell in the crosstab between categorical variables separated by * or # (i.education#i.country).

## fix_labels
Adds prefix of variable label / variable name to stata value labels so that regression output can be filtered and sorted in excel. So, value labels for values 1 "United States" 2 "Nepal" 3 "United Kingdom" become 1 "Country: United States" 2 "Country: Nepal" 3 "Country: United Kingdom", so that excel's filter and sort functions work nicely. 

```stata
  use exampledata, clear // contains individual level data on income, sex, education, country, rural/urban location
  fix_labels sex country education
  reg income sex education 
  esttab using "output.csv", label replace
```

Will upload sthlp files at some point. 
