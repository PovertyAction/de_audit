# de_audit
Program to automate sampling for data entry auditing.

**Syntax:**

de\_audit [_#_] , id(_id variable_ ) [exclude(_varlist_ ) [no]blanks stringblanks(_list of strings_ ) numblanks(_numlist_ ) ]

**Description**

This produces a dataset containing _#_ (default 1500) of id-variable pairs, with the value of the pair in the dataset. This can then be used for checking against paper or scanned copies of the completed questionnaires.

**Notes:**

1. You must set the seed prior to running this program.
2. By default 1500 pairs are sampled.
3. Blank values are automatically excluded, unless the **blanks** option is specified. The purpose is to calculate the keystroke error rate of values that were actually entered and not skipped by the data entry software. Ideally this would be accompanied by a separate check of filter questions to ensure no DEO cheating has occurred.
4. If you want to exclude blank values, you must specify all blank values, including sysmiss (.)
and the empty string (""). The one exception is strings
that are all spaces, which are treated the same as the
empty string. All string variables are processed with
the "trim" command before determining whether they are
considered blank. So you should specify "dont know" 
instead of "dont know   " even if the latter occurred in the raw dataset.
5. exclude() excludes a list of variables from the sample.
6. For large samples (>1500), this program might run for over a minute. It is particularly slow when the number of blank cells exceeds the number of non-blank cells. If it is running far too long, you may able to get performance by adjusting the sampling parameter down using the multiply() option. Default is 2 but lower values will take less time. Values less than 1.5 are likely to lead to errors.
7. The _nsurveys()_ option allows you to first sample N surveys, and and then randomly select questions within the surveys. There will be approximately equal numbers of questions per survey. **This option is not totally exact.** Sometimes the total number of questions sampled does not exactly equal the number desired---in these cases you should slightly oversample and drop any extras. If the specified number of questions per survey is less than 2, the program will often select significantly fewer surveys than what was specified. For example, if you sample 100 questions from only 95 surveys, you may get a dataset with 76 surveys, some of which have 2 questions.