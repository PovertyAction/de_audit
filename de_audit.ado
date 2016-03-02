
clear all
program de_audit
	syntax using , id(string) [clear] // seed(integer) --> work this out
	*--> include a seed.

	*First check if there are enough to sample or if they should just be 
	*all checked. If the number of cells is only 3000, it is probably harder to 
	*check a sample than the whole dang thing.


	*Make a dataset of only the IDs, and sample them
		loc file : copy local using
		
		if `"`clear'"' == "clear" use `file' , clear
		else use `file' 
		
		assert c(k)*c(N) > 3000 // make an error message.

		keep `id'
		while c(N) < 10000 {
			expand 2
		} // 10000 almost certainly assures 1500 unique
		bsample 10000
		
		tempfile sample_ids
		save `sample_ids', replace 


	*Make dataset of variables
		clear 
		use `file' , clear
		unab allvars: _all
		
		loc varnum = c(k)
		clear
		set obs `varnum'
		
		gen Variables="" // make a tempvar
		local i=1
		foreach var of local allvars {
			qui replace Variables="`var'" in `i'
			local i=`i'+1
		}
		drop if Variables=="" 
		
		while c(N) < 10000 {
			expand 2 
		} // 10000 almost certainly assures 1500 unique
		bsample 10000
		
		tempfile sample_vars
		save `sample_vars', replace 


	*Merge the two samples to intersect
		use `sample_ids' , clear
		cap drop _merge
		merge using `sample_vars'
		drop _merge
		
		*duplicates drop
		*keep in 1/1500
		tempfile sample_cells
		tostring `id' , replace
		save `sample_cells' , replace
		
	*Merge with full dataset
		use `file' , clear
		tostring `id' , replace
		foreach var of varlist _all { 
			qui tostring `var', replace force 
			qui replace `var'="" if `var'=="."
		} 
		
		cap drop _merge
		merge 1:m `id' using `sample_cells'
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
		
		gen Blank=mi(VarVal)
		replace Blank=1 if VarVal==".c" // ok this isn't great, what to do here? must incorporate codes.
		
		*Just use 1500 nonblank
		duplicates drop `id' Variables, force
		gen double sorter=runiform()
		sort sorter
		drop if Blank == 1
		assert c(N) >= 1500
		keep in 1/1500
		
		keep `id' Variables VarVal
		sort `id' Variables



end










	
