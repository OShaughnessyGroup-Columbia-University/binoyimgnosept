function M = st_rot_mat(q)
	M = vrrotvec2mat(vrrotvec([1 0 0]',q));
end