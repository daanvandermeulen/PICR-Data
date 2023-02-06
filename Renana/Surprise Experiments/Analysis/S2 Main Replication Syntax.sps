* Encoding: UTF-8.

*remove outliers of thermometer.

DATASET ACTIVATE DataSet1.
FREQUENCIES VARIABLES=thermometer_A  homogeneity SDA Age Sex Edu Income PolOr RCL relig cond
  /STATISTICS=STDDEV MEAN
  /ORDER=ANALYSIS.

*correlation of 4 main variables S2.
CORRELATIONS
  /VARIABLES=thermometer_A homogeneity SDA PolOr
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*manipulation check S2.
UNIANOVA mc_surprise BY cond
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /POSTHOC=cond(LSD) 
  /EMMEANS=TABLES(cond) COMPARE ADJ(LSD)
  /PRINT ETASQ DESCRIPTIVE
  /CRITERIA=ALPHA(.05)
  /DESIGN=cond.


*delete RCL and recreate as numeric using the following code .
RECODE PolOr (4=2) (1 thru 3=1) (5 thru 7=3) (ELSE=SYSMIS) INTO RCL.
EXECUTE.

*naturally the next step would have been to give interaction codes, followed by planned contrasts.
*however, the code for the interactions is too long, and would make this doscument unreadabe..
*Thus: here you have the planned contrasts, while the interactions have separate syntax files.
*NOTE: turn the split command off (command line bellow) before running intercations.

SORT CASES  BY RCL.
SPLIT FILE SEPARATE BY RCL.

*no validation vs. control.
ONEWAY thermometer_A homogeneity SDA BY cond
  /CONTRAST=1 -1 0 0 
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS.

*insinuated validation vs. control.
ONEWAY thermometer_A homogeneity SDA BY cond
  /CONTRAST=1 0 -1 0 
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS.

*explicit validation vs control.
ONEWAY thermometer_A homogeneity SDA BY cond
  /CONTRAST=1 0 0 -1 
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS.

SPLIT FILE OFF.