function X=RR_rand_int(IMAX,M,N,P)
% function X=RR_rand_int(IMAX,M,N,P) or X=RR_randi(IMAX,[M N P]) or X=RR_randi(IMAX,size(A))
% Generate a scalar, vector (length M), matrix (MxN), or rank-3 (MxNxP) array, each entry
% of which is a SIGNED (int8,int16,int32,int64) or UNSIGNED (uint8,uint16,uint32,uint64)
% integer with discrete uniform distribution over the specified range. 
% INPUTS: IMAX  = max integer generated (OPTIONAL, default IMAX=100)
%               Note: IMIN=0 by default (unlike Matlab's randi).        
%               Replace IMAX with [IMIN,IMAX] to specify a different range of integers. 
%         M,N,P = dimension(s) of output array (OPTIONAL, default M=N=P=1)
% OUTPUT: X     = scalar, vector, matrix, or rank-3 array of random integers on 1:IMAX
% TEST:   X=RR_rand_int(100,10,10)         % 10x10 array of uint8 on 0:100
%         Y=RR_rand_int([-10,10],50000);   % 50000 integers on -10:10
%         clf, histogram(Y,[-10.5:1:10.5],'Normalization','probability')
%         hold on; plot([-10 10],[1 1]/21,'k-',linewidth=2)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

% Calculate IMAX and {M,N,P} from input data
if nargin==0, IMAX=100, elseif length(IMAX)==2, IMIN=IMAX(1); IMAX=IMAX(2); else, IMIN=0; end
if nargin==2 & length(M)>1, N=M(2); if length(M)>2, P=M(3); end, M=M(1); end
if ~exist('M'), M=1; end, if ~exist('N'), N=1; end, if ~exist('P'), P=1; end

if IMAX==IMIN, X=zeros(M,N,N); else
	global RR_PRNG_OUTPUT RR_PRNG_GENERATOR
	if ~strcmp(RR_PRNG_GENERATOR,'xoshiro256++'), RR_prng('stochastic','xoshiro256++'), end

	TOTAL=uint64(IMAX-IMIN+1); % TOTAL= # of catagories, cat_total= # of integers per catagory
	if RR_power_of_2_test(TOTAL), cat_total=idivide(0x8000000000000000,TOTAL/2); prune=false;
	else,                         cat_total=idivide(0xFFFFFFFFFFFFFFFF,TOTAL);   prune=true; end

	Z=RR_prng_draw(M*N*P);   % select the random integers
	if prune, for i=1:M*N*P, while Z(i)>cat_total*TOTAL-1, 
		Z(i)=RR_prng_draw(1);  % Replace those (few) draws that are > than the max allowed
	end, end, end

	% Normalize X by cat_total, round down to range 0:TOTAL-1, and reshape to desired matrix form
	X=reshape(idivide(Z,cat_total),M,N,P);
end

if     IMIN>=0           & IMAX<=255,        X=IMIN+uint8(X);
elseif IMIN>=0           & IMAX<=65535,      X=IMIN+uint16(X);
elseif IMIN>=0           & IMAX<=4294967295, X=IMIN+uint32(X);
elseif IMIN>=0                               X=IMIN+uint64(X);
elseif IMIN>=-128        & IMAX<=127,        X=IMIN+int8(X);
elseif IMIN>=-32768      & IMAX<=32767,      X=IMIN+int16(X);
elseif IMIN>=-2147483648 & IMAX<=2147483647, X=IMIN+int32(X);
else                                         X=IMIN+int64(X);
end