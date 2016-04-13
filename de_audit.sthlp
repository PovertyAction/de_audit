{smcl}
{* *! version 1.0 Matthew White 21mar2014}{...}
{title:Title}

{phang}
{cmd:de_audit} {hline 2} Program to automate sampling for data entry auditing.


{marker syntax}{...}
{title:Syntax}

{p 8 10 2}
{cmd:de_audit }[{it:#}] {cmd:, }{opth id(varname)} [{it:options}]


{* Using -help duplicates- as a template.}{...}
{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{* Using -help ca postestimation- as a template.}{...}
{p2coldent:* {opth id(varname)}}the unique ID{p_end}

{syntab:Blanks}
{synopt:[{cmd:no}]{opt blanks}}Sample from blank entries (off by default){p_end}
{synopt:{opth numblanks(numlist)}}Specify numeric values that are counted as blanks {p_end}
{synopt:{opth stringblanks(list of strings)}}Specify string values that are counted as blanks {p_end}

{syntab:Options}
{synopt:{opth exclude(varlist)}} Exclude {it:varlist} from the sample{p_end}
{synopt:{opth nsurveys(#)}} Number of surveys to sample in the first stage {p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt id()} is required.{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:de_audit} produces a dataset containing {it:#} (default 1500) of 
id-variable pairs, along with the value of the pair in the dataset. 
This can then be used for checking against paper or scanned copies 
of completed questionnaires. This process is known as data entry auditing. 


{marker remarks}{...}
{title:Remarks}

{pstd}
The GitHub repository for {cmd:de_audit} is
{browse "https://github.com/PovertyAction/de_audit":here}.
Previous versions may be found there: see the tags.{p_end}

{pstd}
For large samples (>1500), this program might run for over a minute. 
It is particularly slow when the number of blank cells exceeds the 
number of non-blank cells. If it is running far too long, you may 
able to get performance by adjusting the sampling parameter down 
using the (undocumented) {cmd:multiply()} option. Default is 2 but lower values will 
take less time. Values less than 1.5 are likely to lead to errors.



{marker options}{...}
{title:Options}

{dlgtab:Blanks}

{phang}
{marker type1}
[{cmd:no}]{opt blanks} specifies whether blank entries will be sampled. By default,
blanks are not sampled. Only values specified using the stringblanks() and numblanks()
options will be excluded. Blank values correspond to sections of the questionnaire 
that were skipped, and thus are not relevant for data entry checks. The purpose 
is to calculate the keystroke error rate of values that were actually entered 
and not skipped by the data entry software. Ideally this would be accompanied 
by a separate check of filter questions to ensure no DEO cheating has occurred. 
See IPA's Data Entry Guide
for more discussion of this decision and how to define error rates. 

{phang}
{opth stringblanks(list of strings)} If you want to exclude blank values, 
you must specify all blank values, including the empty string (""). 
The one exception is strings
that are all spaces, which are treated the same as the
empty string. All string variables are processed with
the "trim" command before determining whether they are
considered blank. So you should specify "dont know" 
instead of "dont know   " even if the latter occurred in the raw dataset.

{phang}
{opth numblanks(numlist)} If you want to exclude blank values, 
you must specify all blank values, including sysmiss (.)
and extended missing values (.a through .z).


{dlgtab:Options}

{phang}
{opth nsurveys(#)} specifies the number of surveys to sample in the first stage. 
This allows you to first sample N surveys, and and then randomly select questions 
within the surveys. There will be approximately equal numbers of questions per 
survey. {it:This option is not totally exact.} Sometimes the total number of 
questions sampled does not exactly equal the number desired---in these cases 
you should slightly oversample and drop any extras. If the specified number 
of questions per survey is less than 2, the program will often select 
significantly fewer surveys than what was specified. For example, if you 
sample 100 questions from only 95 surveys, you may get a dataset with 76 
surveys, some of which have 2 questions.

{phang}
{opth exclude(varlist)} excludes a list of variables from the sample. The ID variable
is automatically excluded.



{marker examples}{...}
{title:Examples}

{pstd}Sample 1000 questions from 150 surveys, excluding blanks. Approximately 7 questions per survey.{p_end}


{phang2}{cmd:de_audit 1000 , id(KEY) numblanks(.) stringblanks("") nsurveys(150) ///}{p_end} 
{phang3}{cmd:exclude(SubmissionDate starttime endtime deviceid subscriberid simid devicephonenum ta_*)}{p_end}

		




		
{marker references}{...}
{title:References}

{marker data_entry_guide}{...}
{phang}
{browse "hyperlink here":IPA/J-PAL Data Entry Guide}


{marker author}{...}
{title:Author}

{pstd}Matthew Bombyk{p_end}

{pstd}For questions or suggestions, submit a
{browse "https://github.com/PovertyAction/de_audit/issues":GitHub issue}
or e-mail researchsupport@poverty-action.org.{p_end}


