Z2 :=  FiniteField(2);
Z := Integers();
S7 := Sym(7);

//////////////////////////////////////////////////////////////////////
// the simplicial complex
//////////////////////////////////////////////////////////////////////

// There are 5 vertices, numbered 1..5
// There are 10 edges, numbered 1..10
// There are 10 triangles, numbered 1..10
// There are 5 tetrahedra, numbered 1..5

// faces_of_ts records the triangles that are the faces of each tetrahedron
faces_of_ts := [[2,4,8,9],[1,3,8,10],[3,4,5,6],[1,5,7,9],[2,6,7,10]];
// edges_of_ts records the edges of each tetrahedron
edges_of_ts := [[3,5,6,8,9,10],[1,2,4,5,9,10],[2,3,4,5,6,7],[1,2,3,7,8,9],[1,4,6,7,8,10]];
// vertices_of_ts records the vertices of each tetrahedron
vertices_of_ts := [[2,3,4,5],[1,3,4,5],[1,2,4,5],[1,2,3,5],[1,2,3,4]];

// edges_of_fs records the edges of each triangle
edges_of_fs := [[1,9,2],[8,10,6],[4,5,2],[6,5,3],[7,3,2],[7,6,4],[7,8,1],[10,5,9],[8,9,3],[1,10,4]];
// vertices_of_fs records the vertices of each triangle
vertices_of_fs := [[1,3,5],[2,3,4],[1,4,5],[2,4,5],[1,2,5],[1,2,4],[1,2,3],[3,4,5],[2,3,5],[1,3,4]];

// vertices_of_es records the vertices of each edge
vertices_of_es := [[1,3],[1,5],[2,5],[1,4],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]];

// ts_of_fs records the tetrahedra incident to each triangle
ts_of_fs := [[i : i in [1..5] | j in faces_of_ts[i]] : j in [1..10]];

// ts_of_fs records the tetrahedra incident to each edge
ts_of_es := [[i : i in [1..5] | j in edges_of_ts[i]] : j in [1..10]];

// es_of_vs records the edges incident to each vertex
es_of_vs := [[i : i in [1..10] | j in vertices_of_es[i]] : j in [1..5]];

// We store tuples of indices of faces which intersect.
// Note that the label 'be' denotes 'bad edge' and stores an edge which
// does not appear in an intersection. For example Meets_333 stores a vertex v
// together with a single edge meeting v excluded from the intersection.

Meets_1233 := [[t,f,be] : t in [1..5], f in [1..10], be in [1..10] | be in edges_of_fs[f] and f in faces_of_ts[t]];
Meets_1333 := [[t,v] : t in [1..5], v in [1..5] | v in vertices_of_ts[t]];
Meets_3333 := [1..5];

Meets_233 := [[f,be] : f in [1..10], be in [1..10] | be in edges_of_fs[f]];
Meets_123 := [[t,f,e] :  t in [1..5], f in [1..10], e in [1..10] | e in edges_of_fs[f] and f in faces_of_ts[t]];
Meets_133 := [[t,f,be] :  t in [1..5], f in [1..10], be in [1..10] | be in edges_of_fs[f] and f in faces_of_ts[t]];
Meets_333 := [[v,be] :  v in [1..5], be in [1..10] | v in vertices_of_es[be]];

Meets_12 := [[t,f] :  t in [1..5], f in [1..10] | f in faces_of_ts[t]];
Meets_13 := [[t,e] :  t in [1..5], e in [1..10] | e in edges_of_ts[t]];
Meets_23 := [[f,e] :  f in [1..10], e in [1..10] | e in edges_of_fs[f]];
Meets_33 := [[f,be] : f in [1..10], be in [1..10] | be in edges_of_fs[f]];

//////////////////////////////////////////////////////////////////////
// the affine structure
//////////////////////////////////////////////////////////////////////

// We now fix trivializations of the sheaf over the 5 vertices and the interiors of the 5 tetrahedra.
// Paste[[i,j]] records the identification between the trivialization over the i-th tetrahedron
// and the j-th vertex.

Paste := AssociativeArray();


// Without loss of generality we can insist that everything glues to the 5-th vertex via the identity map
for t in [1..4] do
    Paste[[t,5]] := (S7 ! 1);
end for;

// Without loss of generality we may assume that tetrahedron 1 glues to all vertices via the identity map,
// and that tetrahedron 3 glues to vertex 1 by the identity map, and that tetrahedron 5 glues to vertex 1
// via the identity map.  (Here we have chosen a maximal tree in the incidence graph and set the
// corresponding gluing maps to be the identity.)

// The other gluing maps then follow, by considering the standard model of the affine manifold structure
// on tetrahedron 4 and performing monodromy calculations.
Paste[[2,1]] := S7 ! (1,2)(4,5);
Paste[[3,1]] := S7 ! 1;
Paste[[4,1]] := S7 ! (1,2)(6,7);

Paste[[1,2]] := S7 ! 1;
Paste[[3,2]] := S7 ! (1,6)(3,4);
Paste[[4,2]] := S7 ! (3,4)(2,7);

Paste[[1,3]] := S7 ! 1;
Paste[[2,3]] := S7 ! (2,3)(5,6);
Paste[[4,3]] := S7 ! (2,3)(4,7);

Paste[[1,4]] := S7 ! 1;
Paste[[2,4]] := S7 ! (2,5)(3,6);
Paste[[3,4]] := S7 ! (1,4)(3,6);


Paste[[5,1]] := S7 ! 1;
Paste[[5,2]] := Paste[[4,2]]*Paste[[4,1]]^-1*(S7 ! (2,6)(3,5));
Paste[[5,3]] := Paste[[4,3]]*Paste[[4,1]]^-1*(S7 ! (2,3)(5,6));
Paste[[5,4]] := Paste[[2,4]]*Paste[[2,1]]^-1*(S7 ! (3,7)(2,4));

// tfe_monos[[i,j,k]] records the monodromy transformation given by transport, with respect to
// the trivialization in the i-th open set of type t, around the five 'legs' specified by edge
// k in triangle j.
tfe_monos := AssociativeArray();
for i in [1..5] do
    for j in faces_of_ts[i] do
	for k in edges_of_fs[j] do
	    other_t := [l : l in [1..5] | j in faces_of_ts[l] and l ne i][1];
	    v1, v2 := Explode(vertices_of_es[k]);
	    tfe_monos[[i,j,k]] := Paste[[i,v2]]^-1*
				  Paste[[other_t, v2]]*
				  Paste[[other_t,v1]]^-1*
				  Paste[[i,v1]];
	end for;
    end for;
end for;

MPaste_Inv := AssociativeArray();
MPaste := AssociativeArray();
for A in Keys(Paste) do
	MPaste_Inv[A] := SparseMatrix(PermutationMatrix(Z2,Paste[A]^-1));
	MPaste[A] := SparseMatrix(PermutationMatrix(Z2,Paste[A]));
end for;

fe_monos := AssociativeArray();
for i in [1..10] do
	for j in edges_of_fs[i] do
		tetra := ts_of_fs[i];
		fe_monos[[i,j]] := Paste[[tetra[2],vertices_of_es[j][1]]]*
			Paste[[tetra[2],vertices_of_es[j][2]]]^-1*
				Paste[[tetra[1],vertices_of_es[j][2]]]*
					Paste[[tetra[1],vertices_of_es[j][1]]]^-1;
	end for;
end for;

// We fix a trivialization over each of the segments of the singular locus and record
// the paste maps to neighbouring tetrahedra in the array 'sing_paste'.
sing_paste := AssociativeArray();

// We form a projection matrix by looking at the orbits of the monodromy matrix.
// There is parity issue: we cannot simultaneously fix a single trivialisation for 
// every segment in a two dimensional face with the same direction, the ordering 
// of the final two columns is recorded seperately.

for j in [1..10] do
	i := ts_of_fs[j][1];
	for k in [1..3] do
			X := Orbits(sub<S7 | tfe_monos[[i,j,edges_of_fs[j][k]]]> );
			entries := [<a,b,1> : a in [1..7], b in [1..5] | a in X[b]];
			sing_paste[[i,j,k,1]] := SparseMatrix(Z2,7,5,entries);
			
			// Monodromy around loops based at a point in the discriminant locus can interchange 
			// columns recording which pairs of sheets combine over the given segement of the discriminant locus.
			// Therefore we record each possibility using a fourth index in the associate array.
			non_trivial_pair := [b : b in [1..5] | #[c : c in [1..7] | <c,b,1> in entries] eq 2];
			sing_paste[[i,j,k,2]] := sing_paste[[i,j,k,1]]*SparseMatrix(PermutationMatrix(Z2,Sym(5)!(non_trivial_pair[1],non_trivial_pair[2])));
	end for;
end for;

// Restriction maps to the remaining tetrahedra can be related to those already defined using paste maps between open sets
// corresponding to tetrahedra and vertices.
for j in [1..10] do
	i := ts_of_fs[j][2];
	iprime := ts_of_fs[j][1];
		sing_paste[[i,j,1,1]] := MPaste_Inv[[i,vertices_of_fs[j][1]]]*MPaste[[iprime,vertices_of_fs[j][1]]]*sing_paste[[iprime,j,1,1]];
		sing_paste[[i,j,2,1]] := MPaste_Inv[[i,vertices_of_fs[j][2]]]*MPaste[[iprime,vertices_of_fs[j][2]]]*sing_paste[[iprime,j,2,1]];
		sing_paste[[i,j,3,1]] := MPaste_Inv[[i,vertices_of_fs[j][3]]]*MPaste[[iprime,vertices_of_fs[j][3]]]*sing_paste[[iprime,j,3,1]];
		sing_paste[[i,j,1,2]] := MPaste_Inv[[i,vertices_of_fs[j][3]]]*MPaste[[iprime,vertices_of_fs[j][3]]]*sing_paste[[iprime,j,1,2]];
		sing_paste[[i,j,2,2]] := MPaste_Inv[[i,vertices_of_fs[j][1]]]*MPaste[[iprime,vertices_of_fs[j][1]]]*sing_paste[[iprime,j,2,2]];
		sing_paste[[i,j,3,2]] := MPaste_Inv[[i,vertices_of_fs[j][2]]]*MPaste[[iprime,vertices_of_fs[j][2]]]*sing_paste[[iprime,j,3,2]];
end for;


// We describe the restriction map from an open set containing a positive vertex
// to an open subset contained inside the interior of a tetrahedron.

p_sing := AssociativeArray();

for i in [1..10] do
	t1, t2, t3 := Explode(ts_of_es[i]);
	v1, v2 := Explode(vertices_of_es[i]);
	faces := [f : f in faces_of_ts[t1] | i in edges_of_fs[f]];
	X := Orbits(sub<S7 | tfe_monos[[t1,faces[1],i]],tfe_monos[[t1,faces[2],i]] > );
	entries := [<a,b,1> : a in [1..7], b in [1..4] | a in X[b]];
	p_sing[[t1,i]] := SparseMatrix(Z2,7,4,entries);
	p_sing[[t2,i]] := MPaste_Inv[[t2,v1]]*MPaste[[t1,v1]]*p_sing[[t1,i]];
	p_sing[[t3,i]] := MPaste_Inv[[t3,v1]]*MPaste[[t1,v1]]*p_sing[[t1,i]];
end for;