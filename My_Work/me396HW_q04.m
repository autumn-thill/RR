%% ME396HW_q04
% By Autumn Thill
% Due on 23 September 

%This code takes a matrix and returns equations that model the
%row/column/nullspace/and left nullspace. 

A = [2 2 2 -3; 6 1 1 -4; 1 6 1 -4; 1 1 6 -4];  
[C,L,R,N,Ap,r,n,m]=RR_Subspaces(A) 

%i) Yc = AXR and X = A+YC 

%Yc = A*XR [189; 222; 307; 227]
%X = Ap*YC [12;29;13;-27]

%ii) AXn 
%AXn = [0;0;0;0]

%iii) A+YL
% 1.0e-15 *
  %  0.0555
  % -0.2082
  %  0.1110
   % 0.0139
