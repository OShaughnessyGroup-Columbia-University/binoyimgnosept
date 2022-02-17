%function to generate a dumbell structure using 8 dimers from 2 adjacent myp2 coordinate points
function [matr] = myp2_shape_march(x,y,z, n, l) 
%
%
%SINGLE DIMERS:

%Generating n random vectors from a single point of length l
% set up output arrays
    x1= zeros(1,length(x)*n);
    y1= zeros(1,length(x)*n);
    z1= zeros(1,length(x)*n);
    disp(length(x))
    %for level 1
    for k=1:length(x)
		% for each point generate n rand vectors of length l
		v = randn(n,3);
		v = bsxfun(@rdivide,v,(sqrt(sum(v.^2,2))*1/l));
        
    % make these random points emanate from x(k),y(k),z(k)
		x1((k-1)*n+1:k*n)=x(k)+v(:,1)';
		y1((k-1)*n+1:k*n)=y(k)+v(:,2)';
		z1((k-1)*n+1:k*n)=z(k)+v(:,3)';  
    end
    
    stem = zeros(n, 3);
    stem = [x1' y1' z1'];
  

 
    %sphere centers for each sphere
    
    sphere = zeros(5*n,3);
    
    for i = 1:length(sphere)
        
        %angles constraining the structure of each dimer theta1 is rod to first sphere and theta2 is first to second sphere 
        theta2 = 134; 
        theta1 = 90 + (90*rand);
        alpha = theta1 - (180 - theta2);



        %radius vectors of each sphere
        r1 = 0.95/2*((cosd(theta1)*[1,0,0]) + (sind(theta1)*[0,0,1]));
        r2 = 0.75/2*((cosd(alpha)*[1,0,0]) + (sind(alpha)*[0,0,1]));
        r3= 1/2*((cosd(alpha)*[1,0,0]) + (sind(alpha)*[0,0,1]));   
        
        disp(r1)
        if mod(i,5) ==1
            sphere(i,:) = [x,y,z]; %p0 for each
            
        elseif mod(i,5) == 2
            sphere(i,:) = [x1(ceil(i/5)),y1(ceil(i/5)),z1(ceil(i/5))]; %p1 for each 
        
        elseif mod(i,5) == 3
            p2 = [(x1(ceil(i/5))+r1(1)), y1(ceil(i/5)), z1(ceil(i/5))+r1(3)]; %p2
            sphere(i,:) = p2; 
            
        elseif mod(i,5) == 4
            p3 = [(x1(ceil(i/5))+r1(1)+r2(1)), y1(ceil(i/5)), z1(ceil(i/5))+(r1(3)+r2(3))]; %p3
            sphere(i,:) = p3;
            
        elseif mod(i,5) == 0
            p4 = [(x1(ceil(i/5))+r1(1)+r2(1)+r3(1)),y1(ceil(i/5)),z1(ceil(i/5))+(r1(3)+r2(3)+r3(3))]; %p4
            sphere(i,:) = p4;            
        end
    end

matr = sphere; %final matrix containing 65 points to be used in the main matlab file 

end


