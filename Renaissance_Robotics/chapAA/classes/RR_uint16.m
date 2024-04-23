% classdef RR_uint16
% This class implements a modified uint16 behavior with wrap on overflow, because unfortunately
% Matlab doesn't wrap (unlike C and Rust and Jay-Z and Eminem).  :)
%
% Note that, as is standard, unsigned integer division and remainder are defined in RR such that
%   A = (A/B)*B + (A rem B) where (A rem B) has value less than the value of B.
% Unfortunately, as of April 2024, Matlab's built-in integer division,  A/B, doesn't conform to this
% standard, and thus should probably not be used when doing integer math, unless/until this is fixed.
% For example, taking the following in Matlab: [can replace 16 with any of {8,16,32,64}]
%             b=uint16(7), a=uint16(4), q=b/a, r=rem(b,a)  gives  q=2, r=3.  (doah!)
% On the other hand, taking the following:     [can replace 16 with any of {8,16,32,64,128,256,512}]
%             B=RR_uint16(7), A=RR_uint16(4),  [Q,R]=B/A   gives  q=1, r=3.  (yay!)
%
% DEFINITION:
%   A=RR_uint16(c) defines an RR_uint16 object from any integer 0<=c<=65535=2^16-1=0xFFFF
%
% STANDARD OPERATIONS defined on RR_uint16 objects
% (overloading the +, -, *, /, ^, <, >, <=, >=, ~=, == operators):
%   plus:     [SUM,CARRY]=A+B  gives the sum of two RR_uint16 integers
%   uminus:   -A gives the two's complement representation of negative A
%   minus:    B-A  gives the difference of two RR_uint16 integers (in two's complement form if negative)
%   mtimes:   [SUM,CARRY]=A*B  gives the product of two RR_uint16 integers
%   mrdivide: [QUO,REM]=B/A divides two  RR_uint16 integers, giving the quotient QUO and remainder REM
%   The relations <, >, <=, >=, ~=, == are also clearly defined.
%   {+,-,*,/} are all built on uint32 and uint16 primatives
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

classdef RR_uint16 < matlab.mixin.CustomDisplay
    properties % Each RR_uint16 object consists of just one field:
        v      % a uint16 value (with +,-,*,/ redefined to wrap on overflow)
    end
    methods
        function OBJ = RR_uint16(v)         % Create an RR_uint16 object OBJ
            OBJ.v = uint16(abs(v)); if sign(v)==-1, OBJ=-OBJ; end
        end
        function [SUM,CARRY] = plus(A,B)    % Define A+B (ignore CARRY for wrap on overflow)
            [A,B]=check(A,B); t=uint32(A.v)+uint32(B.v);  % Note: intermediate math is uint32
            SUM=RR_uint16(bitand(t,0xFFFFu32)); CARRY=RR_uint16(bitsrl(t,16)); 
        end
        function DIFF = minus(A,B)          % Define A-B
            [A,B]=check(A,B); Bbar=-B; DIFF=A+Bbar;
        end
        function OUT = uminus(B)            % Define -B
            [B]=check(B); OUT=RR_uint16(bitcmp(B.v)+1);
        end    
        function [PROD,CARRY] = mtimes(A,B) % Define A*B (ignore CARRY for wrap on overflow)
            [A,B]=check(A,B); t=uint32(A.v)*uint32(B.v);  % Note: intermediate math is uint32
            PROD=RR_uint16(bitand(t,0xFFFFu32)); CARRY=RR_uint16(bitsrl(t,16));
        end
        function [QUO,RE] = mrdivide(B,A)   % Define [QUO,RE]=B/A  Note: use idivide, not /
            [A,B]=check(A,B); QUO=RR_uint16(idivide(B.v,A.v)); RE=RR_uint16(rem(B.v,A.v));
        end
        function POW = mpower(A,n),  p=uint64(A.v)^n;
            if p==0xFFFFFFFFFFFFFFFF, error('Overflow'), end, POW=RR_uint16(bitand(p,0xFFFFu64)); end    
        function FAC = factorial(A), f=uint64(1);      for i=2:A.v, f=f*uint64(i); end
            if f==0xFFFFFFFFFFFFFFFF, error('Overflow'), end, FAC=RR_uint16(bitand(f,0xFFFFu64)); end
        function n = norm(A), n=abs(A.v); end    % Defines norm(A)          
            
        % Now define A<B, A>B, A<=B, A>=B, A~=B, A==B based on the values of A and B.
        function tf=lt(A,B), [A,B]=check(A,B); if A.v< B.v, tf=true; else, tf=false; end, end            
        function tf=gt(A,B), [A,B]=check(A,B); if A.v> B.v, tf=true; else, tf=false; end, end
        function tf=le(A,B), [A,B]=check(A,B); if A.v<=B.v, tf=true; else, tf=false; end, end
        function tf=ge(A,B), [A,B]=check(A,B); if A.v>=B.v, tf=true; else, tf=false; end, end
        function tf=ne(A,B), [A,B]=check(A,B); if A.v~=B.v, tf=true; else, tf=false; end, end
        function tf=eq(A,B), [A,B]=check(A,B); if A.v==B.v, tf=true; else, tf=false; end, end
        function [A,B]=check(A,B)
            if ~isa(A,'RR_uint16'), A=RR_uint16(A); end
            if nargin==2 & ~isa(B,'RR_uint16'), B=RR_uint16(B); end
        end

    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Access = protected)
        function displayScalarObject(obj)
            fprintf(getHeader(obj))
            disp(obj.v)
        end
    end
end