* Encoding: UTF-8.

*remove demographic vars with ending x (PolOr.x, for example).

*spss gives the rows of the outs, the extraction is manual.
*create a full list of the row numbers, select all of them from the highest number to the lowest, and "clear" them from the file.

RECODE PolOr2 (4=2) (1 thru 3=1) (5 thru 7=3) (ELSE=SYSMIS) INTO RCL.
EXECUTE.

*Descriptive stats S1.
FREQUENCIES VARIABLES=thermometer_A Age2 Sex2 Edu2 Income2 PolOr2 relig2 cond RCL
  /STATISTICS=STDDEV MEAN
  /ORDER=ANALYSIS.

*correlation of 4 main variables S1.
CORRELATIONS
  /VARIABLES=thermometer_A homogeneity SDA PolOr2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*manipulation check S1.
UNIANOVA mc_surprise BY cond
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /POSTHOC=cond(LSD) 
  /EMMEANS=TABLES(cond) COMPARE ADJ(LSD)
  /PRINT ETASQ DESCRIPTIVE
  /CRITERIA=ALPHA(.05)
  /DESIGN=cond.
*step two for manipulation check - see if rightists are more surprised within the explicit surprise validation condition.
*you have to make the RCL variable into a numeric one: either manually, or by computing it again.

RECODE PolOr2 (4=2) (1 thru 3=1) (5 thru 7=3) (ELSE=SYSMIS) INTO RCL.
EXECUTE.

SORT CASES  BY cond.
SPLIT FILE SEPARATE BY cond.

ONEWAY mc_surprise BY RCL
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /POSTHOC=LSD ALPHA(0.05).

SPLIT FILE OFF.

*naturally the next step would have been to give interaction codes, followed by planned contrasts.
*however, the code for the interactions cannot be read, as it isn't a function the PROCESS allows.

*Thus: here you have the planned contrasts, while the interactions should be produced manually.
*NOTE: turn the split command off (command line bellow) before running intercations.

SORT CASES  BY RCL.
SPLIT FILE SEPARATE BY RCL.

*explicit surprise vs. control.
ONEWAY thermometer_A homogeneity SDA BY cond
  /CONTRAST=1 0 0 -1 
  /STATISTICS DESCRIPTIVES  HOMOGENEITY 
  /MISSING ANALYSIS.

*no surprise no validation vs. control.
ONEWAY thermometer_A homogeneity SDA BY cond
  /CONTRAST=1 -1 0 0 
  /STATISTICS DESCRIPTIVES  HOMOGENEITY 
  /MISSING ANALYSIS.

*insinuated surprise no validation vs control.
ONEWAY thermometer_A homogeneity SDA BY cond
  /CONTRAST=1 0 -1 0 
  /STATISTICS DESCRIPTIVES  HOMOGENEITY
  /MISSING ANALYSIS.

SPLIT FILE OFF.

