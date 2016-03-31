# de_audit
Program to automate sampling for data entry auditing.

**Syntax:**
de\_audit  , id(_id variable_) [ [no]blanks ]

This produces a dataset containing id-variable pairs, with the value of the pair in the dataset. This can then be used for checking against paper or scanned copies of the completed questionnaires.

**Notes:**

1. You must set the seed prior to running this program.
2. Only data entries that are non-missing are sampled using this program, as it currently is. This is a feature.
3. By default 1500 pairs are sampled.

You must specify all blank values, including sysmiss (.)
and the empty string (""). The one exception is strings
that are all spaces, which are treated the same as the
empty string. All string variables are processed with
the "trim" command before determining whether they are
considered blank. So you should specify "dont know" instead of "dont know   " even if the latter occurred in the
raw dataset.