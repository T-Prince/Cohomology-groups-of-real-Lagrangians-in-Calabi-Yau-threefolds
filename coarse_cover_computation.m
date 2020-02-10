////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
// Here we carry out the computation of the E_2 page of the Cech-to-derived 
// spectral sequence for the sheaf \pi_\star \ZZ, with respect to the open cover
// \mathcal{U} of B.
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

// As in acyclic_cover_computation, we set up the arrays and matrices required to compute the Cech differentials.
print "We first setup the cover, this file includes various sanity checks, which should all return 'true'.\n";
load "setup_cover.m";

print "We next define and combine the cech differential matrices out of various submatrices. These three files should produce no output.\n";

// Compute the matrices appearing in the cech complex of the first cohomology of preimages of open sets under \pi.
load "coarse_cech_1_Z_functions.m";
load "coarse_cech_1_Z.m";

// Compute the matrices appearing in the cech complex of the zeroth cohomology of preimages of open sets under \pi.
load "coarse_cech_0_1.m";
load "coarse_cech_0_2.m";

print "We now compute ranks and normal forms of the various matrices we have constructed.";
print "Note the arrays displayed for the Smith normal form display the diagonal entries of the matrix\n";
print "Smith normal form for integral Cohomology calculation, presheaf of first cohomology groups:\n";
[SmithForm(Matrix(Cech_H1))[i,i] : i in [1..240]];

print "Smith normal form for integral Cohomology calculation, presheaf of zeroth cohomology groups.\n";
print "The first Cech differential has Smith normal form:\n";
[SmithForm(Matrix(Cech_H0_1))[i,i] : i in [1..710]];
print "\nThus the Cech differential with integral coefficient ring has rank:\n";
Rank(Cech_H0_1);

print "The second Cech differential has Smith normal form:\n";
[SmithForm(Matrix(Cech_H0_2))[i,i] : i in [1..595]];
print "\nThus the Cech differentials with both integral and Z2 coefficient rings have rank:\n";
Rank(Cech_H0_2);