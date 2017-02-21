# misc_stata_ados
Misc Utility programs in Stata. Brief intros below.

## freq_table
Replaces dataset in memory with a frequency table of variables and interactions. Accepts dummy variables, factor variables, and their interactions and produces a labelled table (by extracting appropriate variable and value labels, if they exist) of counts for dummies (e.g. `female, rur_urb` ), each level of factor variables (`i.education, i.country`) and each cell in the crosstab between categorical variables separated by * or # (`i.education#i.country`).

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


## prefix_labels
Adds prefix of variable label / variable name to stata value labels so that regression output can be filtered and sorted in excel. So, value labels for values `1 "United States" 2 "Nepal" 3 "United Kingdom"` become ` 1 "Country: United States" 2 "Country: Nepal" 3 "Country: United Kingdom" ` , so that excel's filter and sort functions work nicely. 

```stata
  use exampledata, clear // contains individual level data on income, sex, education, country, rural/urban location
  prefix_labels sex country education
  reg income sex education 
  esttab using "output.csv", label replace
```
## bettertab
Wrapper for default tab/tab2 commands that temporarily adds numeric value prefixes and drops them afterwards (so that they don't affect graphs etc.)
```
bettertab race sex
```
returns

| Race                      | 1.F                         | 2.M              | Total 	  |       
|---------------------------|-----------------------------|------------------|----------|       
| 1. Black                  | **counts**                  | **counts**       |**counts**|       
| 2. White                  | **counts**                  | **counts**       |**counts**|       
| 3. Asian                  | **counts**                  | **counts**       |**counts**|       
| 4. Native American        | **counts**                  | **counts**       |**counts**|       

## count_unique
Duplicate functionality with codebook, but returns scalar that can be used for calculations / stored as a variable in a loop.
```
count_unique teacher classroom
sca ntc = `r(nv)'
```
## duprep
Detailed report on duplicates / missing values in variable.

```
duprep student_id 
// returns
/*
*______student_id___________*
Distinct populated obs : 542
% Singletons : 45
Min obs : 1
Mean obs : 4
Max obs: 50
% of obs with missing values: 1
*/

```
## lookin
Searches for string specified in `for()` in `varlist`, optionally generates flag for observations where matches were found.
```
lookin enr2000 enr2001 enr2002, for("Y") g(enr_2000_2002)
```
## unstable
Checks for variation in variable(s) across other variable(s)
```
unstable gender age, by(student)
```
## partition_var
Takes `variable` and `cutpoints` and generates dummies with prefix specified in `prefix`. Example:
```
partition_var age, cut(0 35 50 75) prefix(age)
```
generates the variables (with the appropriate variable labels):
a_0_35
a_36_50
a_51_75
a76

# Installation
Either download ados and move to `c(sysdir_personal)` (where ssc-installed ados live) 
or  `net install lal_utilities, from(https://github.com/apoorvalal/misc_stata_ados/master/)`
Will upload sthlp files at some point. 

