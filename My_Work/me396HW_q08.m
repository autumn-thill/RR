%% me396HW_q08 
% By Autumn Thill
% Due on 23 September 

%This code provides the three second order equations governing a 3 mass 3
%spring system. It determines a 6th order SISO ODE in standard form
%relating the output (x3) to the input (u1). 

% 3 masses and 3 spring system where u1, u2 and u3 are forces in the positive x direction and mu is the force of friction 
%M1:      mx_dd = u1 - k1x1 - k2(x1-x2)  - mu3 * m1*gravity*x_d 
%M2:      mx_dd = u2 - k2(x2-x1) - k3(x2 - x3) - mu3 * m2* gravity *x_d 
%M3:      mx_dd = u3 - k3(x3 - x2) - mu3*m3*gravity*x_d 




clear; syms L1 L2 L3 L4 x1 x2 u x3 L5 L6 L7 L8 L9 
eqn1= L1*x1+L2*x2+ L3*x3 ==u;
eqn2= L4*x1+L5*x2 + L6*x3==0;
eqn3= L7*x1+L8*x2 + L9*x3==0;
sol=solve(eqn1,eqn2,eqn3,x1,x2,x3); 
G=sol.x3/u;

syms m1 m2 mu1 mu2 g k1 k2 s k3 m3 mu3
G=subs(sol.x3/u,{L1,L2,L3,L4, L5, L6, L7, L8, L9},{m1*s^2+mu1*m1*g*s+k1+k2, -k2, 0,-k2,m2*s^2+mu2*m2*g*s+k2+k3, -k3, 0, -k3, m3*s^2+mu3*m3*g*s+k3})
[numG,denG] = numden(G);      % this extracts out the num and den of G
numG=coeffs(numG,s);          % this extracts the powers of s in the num and den
denG=coeffs(denG,s);
numG=simplify(numG/denG(end)); % this makes the den monic
denG=simplify(denG/denG(end));

numG=numG(end:-1:1) ;  % this reverses the order of the vector of coefficients.
denG=denG(end:-1:1) ;
