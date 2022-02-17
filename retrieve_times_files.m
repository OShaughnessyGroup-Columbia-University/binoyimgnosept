function [times,pngFile] = retrieve_times_files(x)
	pngFile = dir([x '*.png']);
	b = {pngFile(:).name};
	times = zeros(1,length(b));
	for k=1:length(b)
		c = strsplit(b{k},'_');
		if ~(length(c) == 4)
			error('Invalid filenames!')
		end
		d = strsplit(c{3},'sec');
			if ~(length(d) == 2)
			error('Invalid filenames!')
		end
		d1 = strrep(d{1},'p1','.25');
		d2 = strrep(d1,'p2','.5');
		d3 = strrep(d2,'p3','.75');
		times(k) = str2num(d3);
	end
end
