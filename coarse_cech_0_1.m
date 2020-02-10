
// Make a choice of neighbouring tetrahedron for each 2-dimensional face.
// We will use this to endow H^0(U,Z2) with a canonical trivialisation.

nearby := AssociativeArray();
for f in [1..10] do
	nearby[f] := [t : t in [1..5] | f in faces_of_ts[t]][1];
end for;

//////////////////////////////////////////////////////
// Row 123
//////////////////////////////////////////////////////
 
M_123_12 := SparseMatrix(Z,0,140,[]); 
M_123_13 := SparseMatrix(Z,0,210,[]); 
M_123_23 := SparseMatrix(Z,0,150,[]); 


row_12 := SparseMatrix(Z,7,0,[]); 
row_13 := SparseMatrix(Z,7,0,[]);
row_23 := SparseMatrix(Z,7,0,[]);

 for m_123 in Meets_123 do
 
	row_12 := SparseMatrix(Z,7,0,[]); 
	row_13 := SparseMatrix(Z,7,0,[]);
	row_23 := SparseMatrix(Z,7,0,[]);

	for m_12 in Meets_12 do
		if m_12 eq [m_123[1],m_123[2]] then
			row_12 := HorizontalJoin(row_12,IdentitySparseMatrix(Z,7));
		else
			row_12 := HorizontalJoin(row_12,SparseMatrix(Z,7,7,[]));
		end if;
	end for;
	M_123_12 := VerticalJoin(M_123_12,row_12);
	
	for m_13 in Meets_13 do
		if m_13 eq [m_123[1],m_123[3]] then
			// To get the sign right here note that the class 2 maximal cell
			// is always the second open set in the 123 triple.
			row_13 := HorizontalJoin(row_13,-1*IdentitySparseMatrix(Z,7));
		else
			row_13 := HorizontalJoin(row_13,SparseMatrix(Z,7,7,[]));
		end if;
	end for;
	M_123_13 :=  VerticalJoin(M_123_13,row_13);
	
	
	for m_23 in Meets_23 do
		if m_23 eq [m_123[2],m_123[3]] then
		
			vs := [u : u in vertices_of_es[m_23[2]]];
			other_t := [tet : tet in [1..5] | m_23[1] in faces_of_ts[tet] and tet ne nearby[m_23[1]]][1];
			g := Paste[[nearby[m_23[1]],vs[1]]]^-1 * Paste[[other_t,vs[1]]] * Paste[[other_t,vs[2]]]^-1 * Paste[[nearby[m_23[1]],vs[2]]];
			X := Orbits(sub<S7 | g> );
			entries := [<a,b,1> : a in [1..7], b in [1..5] | a in X[b]];
			block := SparseMatrix(Z,7,5,entries);
			if m_123[1] eq nearby[m_23[1]] then
				row_23 := HorizontalJoin(row_23,block);
			else
				row_23 := HorizontalJoin(row_23,SparseMatrix(PermutationMatrix(Z,Paste[[other_t,vs[1]]]^-1*Paste[[nearby[m_23[1]],vs[1]]]))*block);
			end if;
		else
			row_23 := HorizontalJoin(row_23,SparseMatrix(Z,7,5,[]));
		end if;
	end for;
	M_123_23 :=  VerticalJoin(M_123_23,row_23);	

 end for;
 
M_123 := HorizontalJoin(HorizontalJoin(HorizontalJoin(M_123_12,M_123_13),M_123_23),SparseMatrix(Z,420,210,[]));

//////////////////////////////////////////////////////
// Row 133
//////////////////////////////////////////////////////

M_133_13 := SparseMatrix(Z,0,210,[]); 
M_133_33 := SparseMatrix(Z,0,210,[]);

row_13 := SparseMatrix(Z,7,0,[]); 
row_33 := SparseMatrix(Z,7,0,[]);

for m_133 in Meets_133 do
 
	row_13 := SparseMatrix(Z,7,0,[]); 
	row_33 := SparseMatrix(Z,7,0,[]);

	for m_13 in Meets_13 do

		lower_edge := Min([e : e in edges_of_fs[m_133[2]] | e ne m_133[3]]);
		if (m_133[1] eq m_13[1]) and (m_13[2] in edges_of_fs[m_133[2]]) and (m_13[2] ne m_133[3]) then
			v := [u : u in vertices_of_fs[m_133[2]] | u notin vertices_of_es[m_133[3]]][1];
			to_add := SparseMatrix(PermutationMatrix(Z,Paste[[m_133[1],v]]));
			if m_13[2] eq lower_edge then
				to_add := -1*to_add;
			end if;
			row_13 := HorizontalJoin(row_13,to_add);
		else
			row_13 := HorizontalJoin(row_13,SparseMatrix(Z,7,7,[]));
		end if;
	end for;
	M_133_13 := VerticalJoin(M_133_13,row_13);
	
	for m_33 in Meets_33 do
		if m_33 eq [m_133[2],m_133[3]] then
			row_33 := HorizontalJoin(row_33,IdentitySparseMatrix(Z,7));
		else
			row_33 := HorizontalJoin(row_33,SparseMatrix(Z,7,7,[]));
		end if;
	end for;
	M_133_33 :=  VerticalJoin(M_133_33,row_33);
 end for; 

M_133 := HorizontalJoin(HorizontalJoin(SparseMatrix(Z,420,140,[]),M_133_13),HorizontalJoin(SparseMatrix(Z,420,150,[]),M_133_33));


//////////////////////////////////////////////////////
// Row 233
//////////////////////////////////////////////////////

M_233_23 := SparseMatrix(Z,0,150,[]);
M_233_33 := IdentitySparseMatrix(Z,210);

row_23 := SparseMatrix(Z,7,0,[]); 

for m_233 in Meets_233 do

	row_23 := SparseMatrix(Z,7,0,[]);
	lower_edge := Min([e : e in edges_of_fs[m_233[1]] | e ne m_233[2]]);
	for m_23 in Meets_23 do
		if (m_23[1] eq m_233[1]) and (m_23[2] ne m_233[2]) then

			vs := [u : u in vertices_of_es[m_23[2]]];
			other_t := [tet : tet in [1..5] | m_23[1] in faces_of_ts[tet] and tet ne nearby[m_23[1]]][1];
			g := Paste[[nearby[m_23[1]],vs[1]]]^-1 * Paste[[other_t,vs[1]]] * Paste[[other_t,vs[2]]]^-1 * Paste[[nearby[m_23[1]],vs[2]]];
			X := Orbits(sub<S7 | g> );
			entries := [<a,b,1> : a in [1..7], b in [1..5] | a in X[b]];
			block := SparseMatrix(Z,7,5,entries);			
			v := [u : u in vertices_of_es[m_23[2]] | u notin vertices_of_es[m_233[2]]][1];
			
			to_add := SparseMatrix(PermutationMatrix(Z,Paste[[nearby[m_23[1]],v]]))*block;
			if m_23[2] eq lower_edge then
				to_add := -1*to_add;
			end if;
			row_23 := HorizontalJoin(row_23,to_add);
		else
			row_23 := HorizontalJoin(row_23,SparseMatrix(Z,7,5,[]));
		end if;
	end for;
	M_233_23 :=  VerticalJoin(M_233_23,row_23);
 end for; 
M_233 := HorizontalJoin(HorizontalJoin(SparseMatrix(Z,210,350,[]),M_233_23),M_233_33);

//////////////////////////////////////////////////////
// Row 333
//////////////////////////////////////////////////////

M_333_33 := SparseMatrix(Z,0,210,[]);
row_33 := SparseMatrix(Z,7,0,[]); 

for m_333 in Meets_333 do
	row_33 := SparseMatrix(Z,7,0,[]);
	middle_edge := Sort([e : e in es_of_vs[m_333[1]] | e ne m_333[2]])[2];
	for m_33 in Meets_33 do
		if ([v : v in [1..5] | v in vertices_of_es[m_333[2]] and v in vertices_of_fs[m_33[1]]]) eq [m_333[1]] 
				and m_333[1] notin vertices_of_es[m_33[2]] then

			if middle_edge notin edges_of_fs[m_33[1]] then
				row_33 := HorizontalJoin(row_33,-1*IdentitySparseMatrix(Z,7));
			else
				row_33 := HorizontalJoin(row_33,IdentitySparseMatrix(Z,7));
			end if;
		else
			row_33 := HorizontalJoin(row_33,SparseMatrix(Z,7,7,[]));
		end if;
	end for;
	M_333_33 :=  VerticalJoin(M_333_33,row_33);
 end for; 
M_333 := HorizontalJoin(SparseMatrix(Z,140,500,[]),M_333_33);

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////

Cech_H0_1 := VerticalJoin(VerticalJoin(VerticalJoin(M_123,M_133),M_233),M_333);