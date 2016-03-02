# de_audit
Program to automate sampling for data entry auditing.

**Syntax:**
de\_audit using _dataset_ , id(_id variable_) [clear]

This produces a dataset containing id-variable pairs, with the value of the pair in the dataset. This can then be used for checking against paper or scanned copies of the completed questionnaires.

**Notes:**

1. You must set the seed prior to running this program.
2. Only data entries that are non-missing are sampled using this program, as it currently is. This is a feature.
3. By default 1500 pairs are sampled.
