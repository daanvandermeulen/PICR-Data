* Encoding: UTF-8.
*BOTH FOR S1 AND S2.

*to do interactions between the conditions, compute a new variable.
*for no surprise no validation as the comparison group:.
RECODE cond (1=4) (2=1) (3=2) (4=3) (ELSE=SYSMIS) INTO nos.nov.
VARIABLE LABELS  nos.nov 'no surprise = 1, insinuated = 2, es=3, control =4'.
EXECUTE.

*for exsplicit surprise validation as the comparison group:.
RECODE cond (1=4) (2=2) (3=3) (4=1) (ELSE=SYSMIS) INTO esv.
VARIABLE LABELS  esv 'es=1, no surprise = 2, insinuated = 3, control =4'.
EXECUTE.

*RCL for S1:.
RECODE PolOr2 (4=2) (1 thru 3=1) (5 thru 7=3) (ELSE=SYSMIS) INTO RCL.
EXECUTE.

*RCL for S2:.
RECODE PolOr (4=2) (1 thru 3=1) (5 thru 7=3) (ELSE=SYSMIS) INTO RCL.
EXECUTE.

*STUDY 1 PLANNED CONTRASTS.
SORT CASES  BY RCL.
SPLIT FILE SEPARATE BY RCL.

*produce interaction analysis - three interactions for each new condition construct (for the three DVs).

*compare no surprise - no validation to insinuated surprise validation.
ONEWAY thermometer_A homogeneity SDA BY cond
  /CONTRAST=0 -1 1 0 
  /STATISTICS= DESCRIPTIVES HOMOGENEITY
  /MISSING ANALYSIS.

*compare no surprise - no validation to explicit surprise validation.
ONEWAY thermometer_A homogeneity SDA BY cond
  /CONTRAST=0 1 0 -1 
  /STATISTICS= DESCRIPTIVES HOMOGENEITY
   /MISSING ANALYSIS.

*explicit surprise validation to insinuated surprise validation.
ONEWAY thermometer_A homogeneity SDA BY cond
  /CONTRAST=0 0 1 -1 
  /STATISTICS= DESCRIPTIVES HOMOGENEITY
  /MISSING ANALYSIS.

SPLIT FILE OFF.
####################################################


SPLIT FILE OFF.

DATASET ACTIVATE DataSet3.
ONEWAY Age2 Sex2 Region2 MaritalS2 Edu2 Income2 relig2 BY cond
  /STATISTICS DESCRIPTIVES HOMOGENEITY 
  /MISSING ANALYSIS.



