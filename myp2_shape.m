%function to generate a dumbell structure using 8 dimers from 2 adjacent myp2 coordinate points
function [matr] = myp2_shape(x1,y1,z1, x2,y2,z2) 
%1
%
%SINGLE DIMERS:

%angles constraining the structure of each dimer theta1 is rod to first sphere and theta2 is first to second sphere 
theta2 = 134; 
theta1 = 100 + (15*rand);
alpha = theta1 - (180 - theta2);

%initial points of two ends of the each dimer
p0= [0,0,0];
p1= [-13,0,0];

%radius vectors of each sphere
r1 = 0.95/2*((cosd(theta1)*[1,0,0]) + (sind(theta1)*[0,0,1]));
r2 = 0.75/2*((cosd(alpha)*[1,0,0]) + (sind(alpha)*[0,0,1]));
r3= 1/2*((cosd(alpha)*[1,0,0]) + (sind(alpha)*[0,0,1]));

%sphere centers for each sphere
p2 = [(-13+r1(1)), 0, r1(3)];
p3 = [(-13+r1(1)+r2(1)), 0, (r1(3)+r2(3))];
p4 = [(-13+r1(1)+r2(1)+r3(1)),0,(r1(3)+r2(3)+r3(3))];

%rotation matrix to change one dimer to 8 using rotation

    function [rm] = r_mat(angle)
        rm = [1,0,0; 0, cos(angle), sin(angle); 0, -sin(angle), cos(angle)];
    end


%myp2 dimer matrices
M1 = [p0; p1; p2; p3; p4]; %collection of points for each dimer from above
M2 = [(r_mat(pi)*p0.').'; (r_mat(pi)*p1.').'; (r_mat(pi)*p2.').'; (r_mat(pi)*p3.').'; (r_mat(pi)*p4.').']; %rotating the points

% 2
%
%CIRCLING THROUGH AND MAKING 8 DIMERS
gamma = (2*pi)/7;
r = 5 / cos((pi/2)-(pi/7));
r = r/30;


%dimer matrix that contains all the points together
Q(64, 3) = 0;


q = union(M1,M2,'rows','stable'); 

Q = [q; q; q; q; q; q; q; q];

for i = 9:8:64
    
    a_i = [0, (r*cos(ceil(i/8)*gamma)), (r*sin(ceil(i/8)*gamma))];
    a_j = [a_i; a_i; a_i; a_i; a_i; a_i; a_i; a_i;];
    Q((i:i+7),:)= Q((i:i+7),:) + a_j;
end


%3
%
%DISPLACING DIMERS to make 4 random dimers point in the opposite direction

%Picking 4 random dimers from 8
pick = randperm(8);

pick = 1+((pick-1)*8);
Qa = Q((pick(1):(pick(1)+7)),:);
Qb = Q((pick(2):(pick(2)+7)),:);
Qc = Q((pick(3):(pick(3)+7)),:);
Qd = Q((pick(4):(pick(4)+7)),:);
Qe = Q((pick(5):(pick(5)+7)),:);
Qf = Q((pick(6):(pick(6)+7)),:);
Qg = Q((pick(7):(pick(7)+7)),:);
Qh = Q((pick(8):(pick(8)+7)),:);

%reflecting the 4 chosen dimers

Q_ref = [Qa; Qb; Qc; Qd];

for i = 1:length(Q_ref(:,1))
    Q_ref(i,1) = -1*Q_ref(i,1)-13;
end
    
Qa= Q_ref((1:8),:);
Qb= Q_ref((9:16),:);   
Qc= Q_ref((17:24),:);   
Qd= Q_ref((25:32),:); 



%staggering dimers by 10nm
b0= [0,0,0];
b1= [1,0,0];
b2= [2,0,0];
b3= [3,0,0];

for i = 1:8
 
    Qa(i,:)= Qa(i,:)+b0;
    Qb(i,:)= Qb(i,:)+b1;
    Qc(i,:)= Qc(i,:)+b2;
    Qd(i,:)= Qd(i,:)+b3;

    Qe(i,:)= Qe(i,:)-b0;
    Qf(i,:)= Qf(i,:)-b1;
    Qg(i,:)= Qg(i,:)-b2;
    Qh(i,:)= Qh(i,:)-b3;
end

Qnew = [Qa; Qb; Qc; Qd; Qe; Qf; Qg; Qh];

%rotating dimers around axis
theta= 0:((2*pi)/7):(2*pi);

for i = 1:8:64
    Qnew((i:i+7),:) = (r_mat(theta(ceil(i/8)))*Qnew((i:i+7),:).').';
end

%one myp2 structure
myp2_fin = [ Qnew((1:8),:);Qnew((9:16),:); Qnew((17:24),:);  Qnew((25:32),:); Qnew((33:40),:);...
    Qnew((41:48),:); Qnew((49:56),:); Qnew((57:64),:)];

%
%
%MOVING DIMERS TO CORRECT LOCATION ACCORDING TO rmyp COORDINATES
q1 = [x1, y1,z1]';     %first rmyp point
q2 = [x2, y2, z2]';    %second rmyp point
qc = (q1+q2)/2;
R = st_rot_mat(q1 - q2); %see st_rot_mat.m file for rotation detailes


myp2_fin = (R * myp2_fin.').';


meanQ = [(sum(myp2_fin(:,1))/64),(sum(myp2_fin(:,2))/64), (sum(myp2_fin(:,3))/64)]' ; %arranging dimers together

for i = 1:64
    myp2_fin(i,1) = myp2_fin(i,1) - meanQ(1) + qc(1);
    myp2_fin(i,2) = myp2_fin(i,2) - meanQ(2) + qc(2);
    myp2_fin(i,3) = myp2_fin(i,3) - meanQ(3) + qc(3);
end

matr = myp2_fin; %final matrix containing 64 points to be used in the main matlab file 

end


