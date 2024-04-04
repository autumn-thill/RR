function X=RR_randi(IMAX,M,N,P)
% function X=RR_randi(IMAX,M,N,P) or X=RR_randi(IMAX,[M N P]) or X=RR_randi(IMAX,size(A))
% Pseudorandomly generate a scalar, vector (length M), matrix (size MxN), or rank-3 array (size MxNxP),
% each entry of which is a integer with discrete uniform distribution on 1:IMAX
% INPUTS: IMAX  = max integer generated        (OPTIONAL, default IMAX=10)
%         M,N,P = dimension(s) of output array (OPTIONAL, default M=N=P=1)
% OUTPUT: X     = scalar, vector, matrix, or rank-3 array of random integers on 1:IMAX
% TEST: X=RR_randi(99,10,10)                % 10x10 array of integers on 1:99
%         Min=min(min(X)), Max=max(max(X)) 
%       Y=10+RR_randi(10,5000);             % 5000 integers on 11:20
%         histogram(Y,[10.5:1:20.5],'Normalization','probability')
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

% Calculate IMAX, M, N, and P from input data
if nargin==0, IMAX=1, end
if nargin==2 & length(M)>1, N=M(2); if length(M)>2, P=M(3); end, M=M(1); end
if ~exist('M'), M=1; end, if ~exist('N'), N=1; end, if ~exist('P'), P=1; end

cat_total=double(floor(4294967295/IMAX)); % total number of integers per catagory
draw_max=cat_total*IMAX-1;                % prepare to draw integers from [0,draw_max]

% Then, select a random uint32 integer on [0,draw_max] using RR_PCG32, normalize X by cat_total
% and round down to generate integers on 1:IMAX, and reshape into the desired matrix form
Z=RR_PCG32(M*N*P); for i=1:M*N*P, while Z(i)>draw_max, Z(i)=RR_PCG32; end, end
X=reshape(uint32(floor(double(Z)/cat_total))+1,M,N,P);