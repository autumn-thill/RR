%% ME396HW_q09
% By Autumn Thill
% Due on 23 September 


%This code takes three polynomials that follow the equation a1*x + b1*y = f
% It calculates the family of solutions. 


%a1 = (s-1)*(s+1)*(s-2)*(s+2) 

%b1 = (s-3)*(s+3) 

%f1 = (s+1)*(s+1)*(s+2)*(s+2)


b=RR_poly([-3 3],1) ; %This takes the roots of the polynomials and inputs it into the 
a=RR_poly([-1 1 -2 2],1);
f=RR_poly([-1 -1 -2 -2],1);


disp('Set up a new Diophantine problem')

[x,y,r,t] = RR_diophantine(a,b,f), test=trim(a*x+b*y), residual=norm(f-test)

fprintf('Note that the solution {x,y} is improper (x.n<y.n), but solves a*x+b*y=f with ~ zero residual\n\n')

%general solution 
% a*x + b*y 

k = RR_poly([1 2 3],1) 
x1 = x+b*k %This is the general family of solutions for x since k can be anything. 
y1 = y - a*k %This is the general family of solutions for y since k can be anything 
residual= a*x1 + b*y1 - f %This confirms that the solution works because the residual is near zero. 