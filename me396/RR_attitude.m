% script RR_attitude.m
%
% If you have a widget on your bot (UUV, UAV, spacecraft ...) that measures
% what direction down is (i.e., a "3-axes accelerometer", assuming you are
% not accelerating significantly), you can figure out pitch and roll, but
% you can't figure out your rotation (yaw) around the down direction.
%
% If you have a widget on your bot that measures what direction magnetic N
% is (i.e., a "3-axis magnetometer", assuming magnetic N is a predictable
% direction in your local environment), you can figure out yaw and pitch,
% but you can't figure out your rotation (roll) around the N direction.
%
% But, if you have both widgets, you can figure out all 3 (yaw, pitch, and roll
% of your bot, compared to a standard reference orientation), ... in fact,
% you have more information than you need (7 equations in 4 unknowns).
% This script sets up and solves ("best fits") the associated (quadratic) equations
% using quaternions (which are singularity free), then converts the answer
% to yaw/pitch/roll (which might be easier for the user to interpret).

clear; format short; global g gr m mr; disp(' ')
m=[1; 0; 0];  g=[0; 0; 1];
an(1)=round(-180+360*rand); c1=cos(an(1)*pi/180); s1=sin(an(1)*pi/180);
an(2)=round( -90+180*rand); c2=cos(an(2)*pi/180); s2=sin(an(2)*pi/180);
an(3)=round(-180+360*rand); c3=cos(an(3)*pi/180); s3=sin(an(3)*pi/180);
fprintf('Some (random) 321 rotation angles: {yaw,pitch,roll} (deg) ='); disp(an)
disp('Here is the rotation matrix corresponding to these three rotation angles:')
R_321=[c3*c2,          -c2*s3,          s2;   ...
   c3*s2*s1+c1*s3, c3*c1-s3*s2*s1, -c2*s1; ...
   s3*s1-c3*c1*s2, c1*s3*s2+c3*s1, c2*c1 ]
mr=R_321*m;  gr=R_321*g;

disp(' '), disp('Now, given ONLY the magnetic and gravity vectors, m and g, in')
disp('body coordinates in the NED reference frame, m=[1; 0; 0] and g=[0; 0; 1],')
disp('and the rotated magnetic and gravity vectors, mr=R_321*m and gr=R_321*g,')
disp('in body coordinates in a frame that has been rotated by {yaw,pitch,roll},')
disp('we now reconstruct all three of these rotation angles.'), disp(' ')

% (remove the semicolon below to display the optimization options used)
options = optimoptions('fsolve','Algorithm','levenberg-marquardt','Display','off');
tic, [x,fval,EXITFLAG,OUTPUT]=fsolve(@func,0.5*[1 1 1 1],options); t=toc;
fprintf('Optimization residual=%0.5g after %d iterations of levenberg-marquardt.\n',norm(fval),OUTPUT.funcCount)
fprintf('Optimization took %0.5g seconds to converge\n',t)

disp('Here is the rotation matrix for the optimized quaternion q:')
q0=x(1); q1=x(2); q2=x(3); q3=x(4);
R_q = [q0^2+q1^2-q2^2-q3^2, 2*q1*q2 - 2*q0*q3,   2*q1*q3 + 2*q0*q2; ...
       2*q1*q2 + 2*q0*q3,   q0^2-q1^2+q2^2-q3^2, 2*q2*q3 - 2*q0*q1; ...
       2*q1*q3 - 2*q0*q2,   2*q2*q3 + 2*q0*q1,   q0^2-q1^2-q2^2+q3^2 ]

% The rotation matrix by Euler/Rodrigues for the corresponding {u,theta}
c=x(1); u(1:3,1)=x(2:4); s=norm(u); u=u/s;
phi=atan2(s,c)*180/pi; if phi>90, phi=phi-180; end, theta=2*phi;
C=cos(theta*pi/180); S=sin(theta*pi/180);
R_u_theta=eye(3)*C+(1-C)*u*u'+S*[0 -u(3) u(2); u(3) 0 -u(1); -u(2) u(1) 0];
% (uncomment the above line to check)

% The reconstructed angles from (both) of these (identical) rotation matrices
an1=[ atan2(-R_q(2,3),R_q(3,3)), asin( R_q(1,3)), atan2(-R_q(1,2),R_q(1,1)) ]*180/pi;
fprintf('reconstructed yaw, pitch, roll (in degrees) = %0.10f, %0.10f, %0.10f\n',...
    an1(1),an1(2),an1(3));

function F=func(x)
global g gr m mr
% This code determines the error F corresponding to the fit between the
% unrotated magnetic and gravity vectors, {m,g}, and the rotated magnetic
% and gravity vectors, {mr,gr}, due to rotation by a unit quaternion q.
% Driving F to zero using the levenberg-marquardt algoritm implemented in
% fsolve thus optimizes the rotation matrix R generated by this unit
% quaternion q in order to recover both gr=R*g and mr=R*m.
q0=x(1); q1=x(2); q2=x(3); q3=x(4);
R = [q0^2+q1^2-q2^2-q3^2, 2*q1*q2 - 2*q0*q3,   2*q1*q3 + 2*q0*q2; ...
     2*q1*q2 + 2*q0*q3,   q0^2-q1^2+q2^2-q3^2, 2*q2*q3 - 2*q0*q1; ...
     2*q1*q3 - 2*q0*q2,   2*q2*q3 + 2*q0*q1,   q0^2-q1^2-q2^2+q3^2 ];
gr1=R*g;
mr1=R*m;
F(1:3)= gr1(1:3) - gr(1:3);
F(4:6)= mr1(1:3) - mr(1:3);
F(7)= q0^2+q1^2+q2^2+q3^2 - 1;
end
