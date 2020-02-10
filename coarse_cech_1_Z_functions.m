////////////////////////////////////////////////////////////////////////////
// We describe functions:
// 1) find_face_signs, and
// 2) find_edge_matrix
// which are used in the construction of the coarse_cech_1_Z.m 
////////////////////////////////////////////////////////////////////////////

 
// The open sets in the cover with non-trivial H^1 are:
// 1) open sets U_e associated to edges, homotopy equivalent to three copies of the wedge product of four circles.
// 2) open sets U_f associated to triangular faces. The cohomology of these investigated in Section five.
// The only intersections of open sets whose preimages have non-trivial H^1 are the intersection of an open set
// corresponding to an edge with one corresponding to a triangular face.

// We recall that, fixing a two-dimensional face f, and edge e of f, there is a 8x12 matrix
// corresponding to the pair (f,e). The torsion free part of H_1 of the preimage of the open set U_f 
// is generated by 12 elements. This generating set (descrbied in the attached documentation)
// divides into three groups of four elements. Moreover, H_1 of the preimage of the intersection of U_e
// and U_f is generated by the classes of 8 circles which divide into two groups of four circles.
// Hence the 8x12 block corresponding to the pair (f,e) divides into six 4x4 submatrices arranged as:

// A_1 | A_2 | A_3
// --------------
// B_1 | B_2 | B_3.

// If the edge e has place i in {1,2,3} the matrices A_i and B_i are zero. Moreover, within each 4x4 block
// all non-zero elements are equal, and equal to either +1 or -1. Thus we determine 4 signs for each pair (f,e).

// The function find_face_signs takes in the index of an edge e, face f and the place of e in f,
// as calculated in coarse_cech_1_Z.m. The function returns two pairs of signs, as described above.
// In particular, if place  = 1, signs[1] stores the signs of entries in the non-zero 4x4 blocks  A_2, and A_3
// while signs[2] stores the signs of the non-zero entries B_2 and B_3.
function find_face_signs(f,e,place)

	// Initialize all signs to be positive
	signs := [[1,1],[1,1]];
	
	// Verify the validity of the input data.
	if f notin [1..10] or e notin [1..10] or place notin [1..3] then
		print "Error in find_face_signs, invalid input data\n";
		return signs;
	end if;
	
	// Check that place value of this edge is correct.
	deleted_vertex := [v : v in vertices_of_fs[f] | v notin vertices_of_es[e]][1];
    new_place := Index(vertices_of_fs[f],deleted_vertex);
	if new_place ne place then
		print "Incorrect place value\n";
		return signs;
	end if;

	// Identify a tetrahedron containing the face f to provide a trivialisation of \breve{\pi}.
	nearby := Explode([t : t in [1..5] | f in faces_of_ts[t]]);
	
	// The preimage of U_f and U_e contains two connected components with non-trivial H^1.
	// Each connected component contains a pair of sheets of covering \breve{\pi}.
	// We record the indices of these two pairs of sheets in 'sheets_used'.
	// This uses the trivialisation over a neighbouring tetrahedron. We order the
	// pairs so that the lowest index sheet appears in the first pair.
	e_index := Index(edges_of_fs[f],e)
	sheets_used := Sort([[j : j in [1..7] | sing_paste[[nearby,f,e_index,1]][j,i] ne 0] : i in [4,5]]);
	
	// for our given place value, we store place+1 and place+2, treating these indices cyclically.
	next_places := [place mod 3 +1, (place+1)mod 3 +1];

	// edges_from_places stores the indices of the edges (in {1..10}) from the pair 'next_places'.
	edges_from_places := [ Explode([e : e in edges_of_fs[f] | vertices_of_fs[f][pl] notin vertices_of_es[e]]) : pl in next_places ];

	// e_indices stores the indices elements of edges_from_places among edges of the face f.
	// This is used as input data to 'sing-paste'.
	e_indices := [ Index(edges_of_fs[f],edges_from_places[i]) : i in [1,2]];

	// Each circle in the preimage of an intersection between two open sets U_e and U_f is homotopic to a wedge union of a pair
	// of circles in the preimage of U_f. The two circles comprising this wedge union are labelled by pairs of sheets of 
	// the covering \breve{\pi} and combining_sheets_i stores the indices of these pairs of sheets.
	combining_sheets_1 := Sort([[j : j in [1..7] | sing_paste[[nearby,f,e_indices[1],1]][j,i] ne 0] : i in [4,5]]);
	combining_sheets_2 := Sort([[j : j in [1..7] | sing_paste[[nearby,f,e_indices[2],1]][j,i] ne 0] : i in [4,5]]);

	// We assign signs, looping over each connected component of the preimage of U_f and U_e with non-trivial H^1.
	// The value sheets_used[i][1] records the lowest index sheet which appears in the ith connected component. 
	for i in [1,2] do
		// We recall sheets_used[i][1] contains the lowest index sheet which appears in the ith connected component.
		if sheets_used[i][1] in combining_sheets_1[2] then
			signs[i][1] := -1;
		end if;
		if sheets_used[i][1] in combining_sheets_2[1] then
			signs[i][2] := -1;
		end if;
	end for;
	
	// Reverse all signs if we are in place 2. Recall that the edge in place 2 is oriented from
	// its lowest index vertex to highest, while the vertices of the face are indexed cyclically
	// from lowest to highest. In particular the lowest index vertex follows the highest index vertex.
	if place eq 2 then
		signs := [[-1*signs[1][1],-1*signs[1][2]],[-1*signs[2][1],-1*signs[2][2]]];
	end if;

	return signs;
end function;


// This function returns the incidence of connected components of the preimage of \pi over the intersections
// of U_f and U_e with the connected components of pre-images of U_e, together with the sign involved.
function find_edge_matrix(f,e)

	edge_mtx := Matrix(Z,2,3,[]);

	if f notin [1..10] or e notin [1..10] then
		print "Error in find_edge_matrix, invalid input data\n";
		return edge_mtx;
	end if;

	// Compute a nearby tetrahedron and sheets_used, as in find_face_signs.
	nearby := Explode([t : t in [1..5] | f in faces_of_ts[t]]);
	sheets_used := Sort([[j : j in [1..7] | sing_paste[[nearby,f,Index(edges_of_fs[f],e),1]][j,i] ne 0] : i in [4,5]]);

	// For each edge we use the trivialisation at a vertex to work out which sheets come together
	// at the positive vertices along that edge. We therefore need to use paste to compare the
	// trivialisations over the tetrahedron indexed by 'nearby' and the trivialisation over
	// a vertex of this edge.	
	first_vertex := vertices_of_es[e][1];
	for pair in [1..2] do
		sheets_used[pair][1] := sheets_used[pair][1]^Paste[[nearby,first_vertex]];
		sheets_used[pair][2] := sheets_used[pair][2]^Paste[[nearby,first_vertex]];
		sheets_used[pair] := Sort(sheets_used[pair]);
	end for;
	sheets_used := Sort(sheets_used);

	// There are three pairs of sheets which combine over each positive vertex along the edge e.
	// We compute these using p_sing, which describes sheets which combine over positive vertices,
	// using a trivialisation from a nearby tetrahedron.
	sheets_used_p := [[j : j in [1..7] | p_sing[[nearby,e]][j,i] ne 0] : i in [2,3,4]];
	for pair in [1..3] do
		sheets_used_p[pair][1] := sheets_used_p[pair][1]^Paste[[nearby,first_vertex]];
		sheets_used_p[pair][2] := sheets_used_p[pair][2]^Paste[[nearby,first_vertex]];
		sheets_used_p[pair] := Sort(sheets_used_p[pair]);
	end for;
	sheets_used_p := Sort(sheets_used_p);

	for i in [1,2] do
		for j in [1..3] do

			// We check whether the entry edge_mtx[i,j] should be set to a non-zero value.
			if sheets_used[i] eq sheets_used_p[j] then

				// To determine the sign we see if Paste has preserved the order of the sheets.
				// sheets_used[i][1] records the lowest index sheet which appears in the ith component
				// of the preimage of the intersection of U_e and U_f with non-trivial H_1.
				if sheets_used[i][1] eq sheets_used_p[j][2] then
					edge_mtx[i,j] := -1;
				else
					edge_mtx[i,j] := 1;
				end if;
			end if;
		end for;
	end for;
	
	return edge_mtx;
end function;