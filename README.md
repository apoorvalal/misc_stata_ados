# misc_stata_ados
Misc Utility programs in Stata. Brief intros below.

### discretize
Creates discrete values (bins) for a specified continuous variable, either using the percentile cutpoints specified in `cutpoints(a, b, c)` or into N number of uniform sized bins as specified in `nbins(n)`.
Useful when trying to frame a regression specification as a classification problem to be handled using an ordered/multinomial logit (e.g. low / medium / high cost based on cutpoints).

```stata
discretize total_cost, gen(cost_level) cut(25 50 75)
discretize total_cost, gen(bins) nbins(200)
```

### winsorize
Winsorizes specified variable at cutpoints specified in `AT(lowerbound upperbound)` or `lim(limit 100-limit)` and optionally generates new variable.

```stata
winsorize price, gen(newprice) at (1 99)
```
### freq_table
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

### dot_product

Calculates the variable `Y = XB` where X is a subset of N variables in the currently loaded dataset, B is an arbitrary column vector (NX1 matrix). Basically a way to construct predicted values from a regression when the coefficients have been stored in a matrix / read in from elsewhere. Produces identical results to `predict` when used with the postestimation `e(b)` coefficient vector.

```stata
sysuse auto, clear
mat A = [1\2\3]
dot_product fitted_val A price weight trunk
```

### prefix_labels
Adds prefix of variable label / variable name to stata value labels so that regression output can be filtered and sorted in excel. So, value labels for values `1 "United States" 2 "Nepal" 3 "United Kingdom"` become ` 1 "Country: United States" 2 "Country: Nepal" 3 "Country: United Kingdom" ` , so that excel's filter and sort functions work nicely.

```stata
  use exampledata, clear // contains individual level data on income, sex, education, country, rural/urban location
  prefix_labels sex country education
  reg income sex education
  esttab using "output.csv", label replace
```
### bettertab
Wrapper for default tab/tab2 commands that temporarily adds numeric value prefixes and drops them afterwards (so that they don't affect graphs etc.)
```stata
bettertab race sex
```
returns

| Race                      | 1.F                         | 2.M              | Total    |
|---------------------------|-----------------------------|------------------|----------|
| 1. Black                  | 1                           | 2                |3|
| 2. White                  | 4                           | 5                |9|
| 3. Asian                  | 7                           | 8                |15|
| 4. Native American        | 10                          | 11               |21|

### count_unique
Duplicate functionality with codebook, but returns scalar that can be used for calculations / stored as a variable in a loop.
```stata
count_unique teacher classroom
sca ntc = `r(nv)'
```
### duprep
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

### dtimer
A display-friendly wrapper of the default timer that displays runtime of any section of code between `dtimer on` and `dtimer off` in hours/minutes/seconds.


### lookin
Searches for string specified in `for()` in `varlist`, optionally generates flag for observations where matches were found.
```
lookin enr2000 enr2001 enr2002, for("Y") g(enr_2000_2002)
```
### unstable
Checks for variation in variable(s) across other variable(s)
```
unstable gender age, by(student)
```
### partition_var
Takes `variable` and `cutpoints` and generates dummies with prefix specified in `prefix`. Example:
```stata
partition_var age, cut(0 35 50 75) prefix(age)
```
generates the variables (with the appropriate variable labels):
a_0_35
a_36_50
a_51_75
a76

### pathmake
Generates entire folder structure for `path` necessary, which the native `mkdir` command cannot do.
```
pathmake "C:/Users/alal/Desktop/test1/temp/test2/test3/test4/test5"
```
creates the entire folder structure, even though the subdirectories didn't exist to begin with.

### cond_stitcher
Returns a long string separated by OR (|) or AND(&) operators that can be used in subsequent calculations.

```stata
loc test "age05 age610 age1115 male old"
cond_stitcher `test', sep(|)
// returns "age05|age610|age1115|male|old"
count if `r(cond)'
> 55
```

### ds2
Wrapper for ds command that does not abbreviate variable names. Preferable to ds for interactive use.

### okeep
Order and Keep varlist.


# Installation
Run the following line in the Stata console:

`net install lal_utilities, from(https://raw.github.com/apoorvalal/misc_stata_ados/master/)`

Or, if you prefer, download ados and move to your personal ado folder / `c(sysdir_personal)` (where ssc-installed ados live)
Will upload sthlp files at some point.

