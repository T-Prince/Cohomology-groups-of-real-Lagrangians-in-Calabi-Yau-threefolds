# On the cohomology groups of real Lagrangians in Calabi-Yau threefolds
Code and documentation associated to the article 'On the cohomology groups of real Lagrangians in Calabi-Yau threefolds' by H. Argüz and T. Prince.

The source files contained in this repository are associated with the following results and computations. Magma source files can be tested online at 'http://magma.maths.usyd.edu.au/calc/'. 

'course_cover_computations.m' assembles the Cech cohomology computations described in Theorems 6.3 and 7.1. This script loads:
  1) 'setup_cover.m', which encodes the 7-to-1 cover described in Section 4, and various monodromy matrices.
  2) 'coarse_cech_1_Z_functions.m' and 'course_cech_1_Z.m', which compute the Cech cohomology groups E^{i,1}_2 for i in {0,1} which appear in the statement of Theorem 7.1.
  3) 'coarse_cech_0_1.m' and 'coarse_cech_0_2.m', which compute the Cech cohomology groups E^{i,0}_2 for i in {1,2,3} which appear in the statements of Theorems 6.3 and 7.1.
  
'Heegaard_splitting.m' contains the computation described in Section 7.2, confirming the calculation of the groups E^{i,0}_2 which appear in the statements of Theorems 6.3 and 7.1.

'sq_for_smooth' contains the SageMath script for computing the Square map for toric Fano fourfolds. This is used to construct Table 1 in Section 6.

The file 'documentation.pdf' describes the computations made 'coarse_cech_1_Z_functions.m' and 'course_cech_1_Z.m'.
