%function that reads the r_ring variables in selected matfiles to find inner radius of septum
%and then uses that in the function 'mesh_an_implicit_function' to generate .off files
%these .off files contain a triangulated mesh for the septum

function mat_to_off

    % these commands are pretty easy to understand.
    % find all dot mat files, extract ring radius from them.
    % then, use system commands to generate the meshes.
    
    files = dir('*.mat');
    r = ones(size(files));
    flg = false(size(files));
	
    for i = 1:length(files)
        m = matfile(files(i).name,'Writable',false);
        r(i,1)= m.r_ring;
	variableInfo = who('-file', files(i).name);
	if ismember('ls_dx', variableInfo)
		flg(i) = true;
		name = files(i).name;
		fin_name= name(1:end-4);
		fin_name= strcat(fin_name,'_rth.txt');
		try
			contour_to_file(m.ls_phi,m.ls_X,m.ls_Y,m.ls_dx,...
				m.r_ring,fin_name,1000);
		catch EEE
			flg(i) = false;
		end
	end
    end


	
    for i = 1:length(files)
        name = files(i).name;
        fin_name= name(1:end-4);
	fin_name_2 = strcat(fin_name,'_rth.txt');
        fin_name= strcat(fin_name,'_septum.off');
	if ~flg(i)
		fin_name_2 = '';
	end
        str = sprintf('./mesh_an_implicit_function 0.02 2 %f 30 0.01 0.01 %s %s\n',...
		r(i,1),fin_name,fin_name_2);
	try
		system(str);
	catch EEE
		1 == 1;
		% do nothing
	end
    end
	
end
