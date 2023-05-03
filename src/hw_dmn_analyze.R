# Study specific analysis of connectivity matrix for HW_DMN_1 ROI set

# Where is our conncalc connectivity matrix output?
matrix_csv <- '~/Downloads/conncalc/RMATRIX/R_removegm.csv'

# Read it in, accounting for the row names that are included
# in recent versions of conncalc
C = read.csv(matrix_csv,row.names=1)

# Extract just the DMN ROIs
dmnlist = c(
  'r0005_DMN_PCC',
  'r0006_DMN_MPFC',
  'r0007_DMN_PAR_L',
  'r0008_DMN_PAR_R',
  'r0009_DMN_INFTEMP_L', 
  'r0010_DMN_INFTEMP_R',
  'r0011_DMN_MDTHAL'
)
Cdmn = C[dmnlist,dmnlist]

# Get just the unique values (upper triangle)
Clist = Cdmn[upper.tri(Cdmn)]

# And compute the mean connectivity in that sub-network
Cmean = mean(Clist)
print(sprintf('Mean DMN connectivity from %s is %f',matrix_csv,Cmean))

# We can also extract specific values a fancy way and print...
roi1 = 'r0001_DLPFC_L'
roi2 = 'r0003_ANTINS_L'
print(sprintf('Connectivity between %s, %s is %f',
      roi1,roi2,C[roi1,roi2]))

# Or get them directly in at the command line
C['r0001_DLPFC_L','r0003_ANTINS_L']

