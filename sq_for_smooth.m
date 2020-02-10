# The following script computes the matrix corresponding to the map D -> D^2,
# where D is an element of H^2(Y,Z2) and Y is a smooth toric Fano fourfold.
# In this example Y is the toric variey CP^4.

P = LatticePolytope([(-1,-1,-1,-1),
					 (4,-1,-1,-1),
					 (-1,4,-1,-1),
					 (-1,-1,4,-1),
					 (-1,-1,-1,4)])

Y = ToricVariety(NormalFan(P))

HH = Y.cohomology_ring()

basis = Y.cohomology_basis(1)
K = sum(HH.gens())
size = len(basis)

Sq = matrix(GF(2),size,size)
for i in range(size):
	for j in range(size):
	    Sq[i,j] = Y.integrate(basis[i]^2*basis[j]*K)
        
Sq.rank()