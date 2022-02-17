%function is used to generate a 'bouquet' structure of myo2 beads emanating from p_sept coordinates 

function [f] = gen_bouquet(x,y,z,l1,l2,n1,n2, xog, yog,zog)
    
    %the og coordinates refer to rmyo and the xyz coordinates to p_sept coordinates and the bouquet is the difference between the two
    og = [xog, yog, zog];
    bq = [x, y, z];
    rm = (bq - og);
    
    %The branches angle out as per a constraint. The contraint is 45 degrees for the dot product of the emanating vector, 0.785 in radians
    const = 0.785;
   
    % set up output arrays
    x1= zeros(1,length(x)*n1);
    y1= zeros(1,length(x)*n1);
    z1= zeros(1,length(x)*n1);
    

    
    %for level 1
    for k=1:length(x)
		% for each point generate n1 rand vectors of length l1
		v = randn(n1,3);
		v = bsxfun(@rdivide,v,(sqrt(sum(v.^2,2))*1/l1));
        for i = 1:size(v(:,1))
            C = 1;
            while C > const
                v(i,:) = randn(1,3);
                v(i,:) = bsxfun(@rdivide,v(i,:),(sqrt(sum(v(i,:).^2,2))*1/l1));
                C = acos((dot(-rm, v(i,:)))/((norm(v(i,:))*norm(rm))));
            end
                    
        end       
		% make these random points emanate from x(k),y(k),z(k)
		x1((k-1)*n1+1:k*n1)=x(k)+v(:,1)';
		y1((k-1)*n1+1:k*n1)=y(k)+v(:,2)';
		z1((k-1)*n1+1:k*n1)=z(k)+v(:,3)';
    end
    
 
    %level 2 output arrays
    
    x2= zeros(1,length(x1)*n2); 
    y2= zeros(1,length(x1)*n2);
    z2= zeros(1,length(x1)*n2);
    
    %for level 2
    for k=1:length(x1)
        % for each point generate n2 rand vectors of length l2
        w = randn(n2,3);
		w = bsxfun(@rdivide,w,(sqrt(sum(w.^2,2))*1/l2));
        for i = 1:size(w(:,1))
            D = 1;
            while D > const
                w(i,:) = randn(1,3);
                w(i,:) = bsxfun(@rdivide,w(i,:),(sqrt(sum(w(i,:).^2,2))*1/l2));
                D = acos((dot(-rm, w(i,:)))/((norm(w(i,:))*norm(rm))));
            end
        
        end       
		% make these random points emanate from x1(k),y1(k),z1(k)
		x2((k-1)*n2+1:k*n2)=x1(k)+w(:,1)';
		y2((k-1)*n2+1:k*n2)=y1(k)+w(:,2)';
		z2((k-1)*n2+1:k*n2)=z1(k)+w(:,3)';
    end 
    
    %merging both arrays
    
    a = [ x1; y1 ; z1];
    a = a.';
    b = [x2; y2; z2];
    b = b.';
    
   
    f = [a;b];

end
