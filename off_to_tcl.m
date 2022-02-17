% function used to generate a tcl file per off file (filename argument) using the triangulation
% contained in the off file. output tcl
% file containes triangulated coordinates for the septum at each run. it is colored and opaque
% output file name is xx.tcl if the input filename is xx.off
function fname_tcl = off_to_tcl(filename)

	%load file
	[p0,t0,T0] = read_off(filename);
	y = filename(1:end-4);
	y = strcat(y,'.tcl');
	fileID = fopen(y, 'w');
	fname_tcl = fileID;

	l = length(t0(:,1));

	tri(l,9) = 0;

	p0= p0.*1000; %p0 contains coordinates so is scaled appropriately, t0 contains list of points in each triangle

	%the tri matrix is populated to have the coordinates of the three points in each triangle as 9 columns in each row
	for i = 1:l
		tri(i,:)=[(p0(t0(i,1),1)),p0(t0(i,1),2),p0(t0(i,1),3),...
		p0(t0(i,2),1),p0(t0(i,2),2),p0(t0(i,2),3),...
		p0(t0(i,3),1),p0(t0(i,3),2),(p0(t0(i,3),3))];
	end

	%fprintf(fileID,'material change ambient Opaque 0.5\n'); 
	fprintf(fileID,'draw material Opaque\n'); %prevent reflection
	fprintf(fileID, 'color change rgb 6 0.500000 0.240000 0.00000\n'); %can customize color rgb value here
	fprintf(fileID, 'draw color silver\n');
	fmt = '%21s %1s%8.3f %8.3f %8.3f%1s  %1s%8.3f %8.3f %8.3f%1s  %1s%8.3f %8.3f %8.3f%1s \n'; %.tcl file format

	%printing out tcl file
	for i= 1:l
		fprintf(fileID,fmt, 'graphics top triangle','{',tri(i,1:3),'}', ...
			'{',tri(i,4:6),'}','{',tri(i,7:9),'}');
	end

end
