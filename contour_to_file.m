function [] = contour_to_file(ls_phi,ls_X,ls_Y,ls_dx,r_ring,out_file_name,N);
	% extract r(theta) data from the septum variables and write to the given
	% file. N such points are written out.
	
	% NOTE: if there are overhangs, this method may fail.

	% obtain contour where level set function = 0
	zeroSet = contourc(ls_phi,[0 0]);
	xx = zeroSet(1,2:end);
	yy = zeroSet(2,2:end);

	% set up some arrays
	X = 0*xx;
	Y = 0*yy;
	X2 = 0*xx;
	Y2 = 0*yy;

	% convert contour indices (I,J) to actual
	% (X,Y) values
	for k=1:length(xx)

		x1 = floor(xx(k));
		x2 = ceil(xx(k));
		alpha = xx(k) - x1;
		
		y1 = floor(yy(k));
		y2 = ceil(yy(k));
		beta = yy(k) - y1;
		
		X(k) = ls_X(x1,y1) + alpha*ls_dx;
		Y(k) = ls_Y(x1,y1) + beta*ls_dx;
		
	end

	% 3-point moving average

	X2(1) = (X(end) + X(1) + X(2))/3;
	X2(end) = (X(end) + X(1) + X(end-1))/3;

	Y2(1) = (Y(end) + Y(1) + Y(2))/3;
	Y2(end) = (Y(end) + Y(1) + Y(end-1))/3;

	for k=2:length(X)-1
		X2(k) = (X(k) + X(k-1) + X(k+1))/3;
		Y2(k) = (Y(k) + Y(k-1) + Y(k+1))/3;
	end

	% convert to r,theta, averaging over
	% any duplicate thetas
	[theta,r] = cart2pol(Y2,X2);
	theta(theta < 0) = theta(theta < 0) + 2*pi;
	[theta,I] = sort(theta);
	r = r(I);

	array =  zeros(length(r),2);
	array(:,1) = theta;
	array(:,2) = r;
	[C,ia,idx] = unique(array(:,1),'stable');
	val = accumarray(idx,array(:,2),[],@mean); 
	your_mat = [C val];

	r = your_mat(:,2);
	theta = your_mat(:,1);
	theta(1) = 0;
	theta(end) = 2*pi;

	% interpolate to produce theta,r where theta is uniform
	% in [0,2*pi] & subtract the mean ring radius.
	thetaOut = linspace(0,2*pi,N+1);
	rOut = interp1(theta,r,thetaOut)-r_ring;
	
	% write to file
	csvwrite(out_file_name,rOut');

	% debug plot function
	% plot(rOut.*cos(thetaOut),rOut.*sin(thetaOut)); axis equal; hold on; st_plot_ring;

end
