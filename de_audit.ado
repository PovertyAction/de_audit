

program de_audit
	syntax [anything(name=ssize)] , id(string) ///
		[exclude(varlist) blanks stringblanks(string asis) numblanks(numlist missingok) ]  // seed(integer) --> work the seed out


quietly {

	*First check if there are enough to sample or if they should just be 
	*all checked. If the number of cells is only 3000, it is probably harder to 
	*check a sample than the whole dang thing.
	
	*Set default sample size
		if `"`ssize'"' == "" local ssize 1500
	
	*Define the variables to check
		unab varss : _all
		loc varss : list varss - id
		loc varss : list varss - exclude
		loc varnum : list sizeof varss
		
		loc cellnum = `varnum'*c(N)

	*Make a dataset of only the IDs, and sample them
		isid `id' // breaks if the id is not unique


	*Check if there are enough non-blank observations to sample from.
		loc numblankslist 
		loc countt = 0
		foreach vall of local numblanks {
			if `countt' == 0 local numblankslist `"`"`vall'"'"'
			else local numblankslist `"`numblankslist',`"`vall'"'"'
			local ++countt
		}

		loc numblanks_check : subinstr local numblanks `" "' `","' , all

		loc countt = 1
		foreach vall of local stringblanks {
			if `countt' == 1 local stringblankslist `"`"`vall'"'"'
			else local stringblankslist `"`stringblankslist',`"`vall'"'"'
			local ++countt
		} 

		local totalnonblank = 0
		local totalblank = 0
		ds `varss' , has(type string)
		foreach var in `r(varlist)' { 
			count if !inlist(`var',`stringblankslist')
			local totalnonblank = `totalnonblank' + r(N)
		}
		ds `varss' , has(type numeric)
		foreach var in `r(varlist)' { 
			count if !inlist(`var',`numblanks_check')
			local totalnonblank = `totalnonblank' + r(N)
		}	

		local blankratio = `cellnum' / `totalnonblank'	

		

	
di in red `"Non-Blank: `totalnonblank'"'
di in red `"Total: `cellnum'"'

	*The ratio of blanks to non-blanks determines how much excess needs to be sampled. 
	*My rule of thumb will be: you need 5*nonblanks SAMPLED to get a good sample without duplicates. 
	*That's only sampling from the nonblanks.
	*In addition, you have to look at how much of your sample is nonblanks at all. So if it's 20%
	*nonblanks for a sample of 100, you would want to sample 500 nonblanks. But only 20% of your sample
	*is nonblanks. So you should really sample 500*5 = 2500 to get 100 unique nonblanks.

	*The formula then becomes: 5*(desired sample size)*(total obs/nonblanks)
		local sizetosample = ceil(5*`ssize'*`blankratio')

		tempfile file
		qui save `file' , replace

		cap assert `cellnum' > `ssize' // make an error message.
		if _rc != 0 di as error "The cells to sample exceeds the total number of cells."

		keep `id'
		while c(N) < `sizetosample' {
			expand 2
		} // this almost certainly assures enough unique cells --> maybe not in cases with tons of blanks!!
		bsample `sizetosample'
		
		tempfile sample_ids
		qui save `sample_ids', replace 

	*Make dataset of variables
		clear
		set obs `varnum'
		
		gen Variables="" // make a tempvar
		local i=1
		foreach var of local varss {
			qui replace Variables="`var'" in `i'
			local i=`i'+1
		}
		drop if Variables=="" 
		
		while c(N) < `sizetosample' {
			expand 2
		} // this almost certainly assures enough unique cells
		bsample `sizetosample'
		
		tempfile sample_vars
		qui save `sample_vars', replace 

	*Merge the two samples to intersect
		use `sample_ids' , clear
		cap drop _merge
		merge using `sample_vars'
		drop _merge
		
		tempfile sample_cells
		tostring `id' , replace
		qui save `sample_cells' , replace
		
	*Merge with full dataset
		use `file' , clear
		qui tostring _all, replace force 
		
		cap drop _merge
		qui merge 1:m `id' using `sample_cells'
		drop if _merge != 3
		drop _merge
		

	*Here we just take the value of the variable that needs to be checked in a given row, 
	*and put it into the new variable "VarVal", which is what the manual check operators
	*will use to compare to the paper survey
		gen VarVal="" 

		forvalues i=1/ `=_N' {
			local v = Variables[`i'] 
			qui replace VarVal = `v' in `i' 
			qui replace VarVal=trim(VarVal)
		}
		
		duplicates drop `id' Variables, force
		gen double sorter=runiform()
		sort sorter

		*Just use nonblanks, unless the option is specified
		
		if `"`blanks'"' != `"blanks"' {
			gen Blank = 0
			*if `"`stringblankslist'"' == "" replace Blank = 1 if mi(VarVal)
			*else replace Blank = 1 if inlist(VarVal,`stringblankslist')
			replace Blank = 1 if inlist(VarVal,`stringblankslist')
			replace Blank = 1 if inlist(VarVal,`numblankslist')
			drop if Blank == 1
		}
		
		assert c(N) >= `ssize'
		keep in 1/`ssize'
		
		keep `id' Variables VarVal
		sort `id' Variables

	}
	if `"`blanks'"' == "blanks" di as result "Sampled `ssize' cells, including blank cells."
	else di as result "Sampled `ssize' cells, excluding blank cells."
	di `"`numblankslist'"'
	di `"`stringblankslist'"'
	di `"`stringblanks'"'

	

end










	
