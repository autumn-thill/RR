%% me396HW_q01 
% By Autumn Thill
% Due on 23 September 


%% part a  
% This performs Euclidean Division on the polynomial a1 and provides a quotient q1 and a remainder r1

b1 = RR_poly([1 -4 13]) ; %these are the coefficients to the polynomial
%roots are 2 - 3i and 2+3i
a1 = RR_poly([1 -2 3i]); %this is the root in polynomial form

[q1,r1] = b1/a1 %this gives the remainder and quotient from Euclidean Division
q1 
r1 
%check the roots by multiplying quotient with divisor and adding the remainder 
a1*q1 + r1

%% Part B
%b2(s) = s^5 + 12s^4 + 36s^3 - 58s^2 - 405s - 450
b2 = RR_poly([1 12 36 58 405 450]) 
a2 = RR_poly([1 2]);
[q2,r2] = b2/a2
%check by multiplying quotient with divisor and adding the remainder 
a2*q2+r2;

a2b = RR_poly([1 4]);
[q2,r2] = b2/a2b
%check by multiplying quotient with divisor and adding the remainder 
a2b*q2+r2;


%% Part C 

z1 = 0.866 + 0.5i  %This is the given complex number
plot(real(z1), imag(z1), 'o')
xlabel("real")
ylabel("imaginary")
title("Complex Plane")
axis([-1 1 -1 1])
grid on


r = -.5 + 0.866025i;   %this rotates the complex number by 120 degrees
hold on;
plot(real(r), imag(r), '-o');


z2 = r*z1           % this is the rotated complex number 
plot(real(z2), imag(z2), 'ok')
legend("z1", "r" ,"z2 (120 degrees from z1)")
hold off; 