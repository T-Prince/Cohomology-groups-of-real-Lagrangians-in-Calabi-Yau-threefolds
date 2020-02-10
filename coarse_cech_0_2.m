
//////////////////////////////////////////////////////
// Row 1233
//////////////////////////////////////////////////////
 
M_1233_233 := SparseMatrix(Z,0,210,[]);
M_1233_123 := SparseMatrix(Z,0,420,[]);
M_1233_133 := -1*IdentitySparseMatrix(Z,420);

row_233 := SparseMatrix(Z,7,0,[]); 
row_123 := SparseMatrix(Z,7,0,[]);
inds := [];

for m_1233 in Meets_1233 do
 
	row_233 := SparseMatrix(Z,7,0,[]);
	row_123 := SparseMatrix(Z,7,0,[]);

	for m_233 in Meets_233 do
		if m_233 eq [m_1233[2],m_1233[3]] then
			row_233 := HorizontalJoin(row_233,IdentitySparseMatrix(Z,7));
		else
			row_233 := HorizontalJoin(row_233,SparseMatrix(Z,7,7,[]));
		end if;
	end for;
	M_1233_233 := VerticalJoin(M_1233_233,row_233);
	
	inds := [];
	for m_123 in Meets_123 do
		if m_123[1] eq m_1233[1] and m_123[2] eq m_1233[2] and m_1233[3] ne m_123[3] then
			Append(~inds,m_123);
		end if;
	end for;
	upper_edge := Max([i[3] : i in inds]);

	for m_123 in Meets_123 do
		if m_123 in inds then
			v := [u : u in vertices_of_fs[m_123[2]] | u notin vertices_of_es[m_1233[3]]][1];
			to_add := SparseMatrix(PermutationMatrix(Z,Paste[[m_123[1],v]]));
			if m_123[3] eq upper_edge then
				to_add := -1*to_add;
			end if;
			row_123 := HorizontalJoin(row_123,to_add);
		else
			row_123 := HorizontalJoin(row_123,SparseMatrix(Z,7,7,[]));
		end if;
	end for;
	M_1233_123 :=  VerticalJoin(M_1233_123,row_123);
 end for;

M_1233 := HorizontalJoin(HorizontalJoin(HorizontalJoin(M_1233_233,M_1233_123),M_1233_133),SparseMatrix(Z,420,140,[]));

 

//////////////////////////////////////////////////////
// Row 1333
//////////////////////////////////////////////////////

M_1333_133 := SparseMatrix(Z,0,420,[]); 
M_1333_333 := SparseMatrix(Z,0,140,[]);

row_133 := SparseMatrix(Z,7,0,[]); 
row_333 := SparseMatrix(Z,7,0,[]);

for m_1333 in Meets_1333 do
 
	row_133 := SparseMatrix(Z,7,0,[]); 
	row_333 := SparseMatrix(Z,7,0,[]);

	for m_133 in Meets_133 do
		if  m_133[1] eq m_1333[1] and m_1333[2] in vertices_of_fs[m_133[2]] and m_1333[2] notin vertices_of_es[m_133[3]] then

			edge_list := Sort([i : i in edges_of_ts[m_133[1]] | i in es_of_vs[m_1333[2]]]);
			removed_edge := [e : e in edge_list | e notin edges_of_fs[m_133[2]]][1];
			sign := 1;
			if Index(edge_list,removed_edge) mod 2 eq 1 then
				sign := -1;
			end if;
			row_133 := HorizontalJoin(row_133,sign*IdentitySparseMatrix(Z,7));
		else
			row_133 := HorizontalJoin(row_133,SparseMatrix(Z,7,7,[]));
		end if;
	end for;
	M_1333_133 := VerticalJoin(M_1333_133,row_133);
	
	for m_333 in Meets_333 do
		if m_1333[2] eq m_333[1] and m_333[2] notin edges_of_ts[m_1333[1]] then
			row_333 := HorizontalJoin(row_333,IdentitySparseMatrix(Z,7));
		else
			row_333 := HorizontalJoin(row_333,SparseMatrix(Z,7,7,[]));
		end if;
	end for;
	M_1333_333 :=  VerticalJoin(M_1333_333,row_333);
 end for; 
M_1333 := HorizontalJoin(SparseMatrix(Z,140,630,[]),HorizontalJoin(M_1333_133,M_1333_333));
 
 
 
//////////////////////////////////////////////////////
// Row 3333
//////////////////////////////////////////////////////

M_3333_333 := SparseMatrix(Z,0,140,[]);
row_333 := SparseMatrix(Z,7,0,[]); 
sign := 1;
for m_3333 in Meets_3333 do
	row_333 := SparseMatrix(Z,7,0,[]);
	for m_333 in Meets_333 do
		if m_333[1] eq m_3333 then
			// Sign: this is determined by the place m_333[2] appears in the list es_of_vs[m_333[1]]
			sign := 1;
			if Index(Sort(es_of_vs[m_333[1]]),m_333[2]) mod 2 eq 0 then
			sign := -1;
			end if;
			row_333 := HorizontalJoin(row_333, sign*IdentitySparseMatrix(Z,7));
		else
			row_333 := HorizontalJoin(row_333,SparseMatrix(Z,7,7,[]));
		end if;
	end for;
	M_3333_333 :=  VerticalJoin(M_3333_333,row_333);
 end for; 
M_3333 := HorizontalJoin(SparseMatrix(Z,35,1050,[]),M_3333_333);

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////

Cech_H0_2 := VerticalJoin(VerticalJoin(M_1233,M_1333),M_3333);