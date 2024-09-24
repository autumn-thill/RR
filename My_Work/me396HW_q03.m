%% ME396HW_q03
% By Autumn Thill
% Due on 23 September 

%This code takes a Matrix A and additional vectors b1 and b2. It returns
%the solution using the pseudoinverse. 


A = [2 2 2 -3; 6 1 1 -4; 1 6 1 -4; 1 1 6 -4]; 
b1 = [0; -5; 0; 5] ; 
b2 = [1; 2; 3; 4]; 

A2 = A*A
A3 = A*A*A 
A4 = A*A*A*A 

rank(A) 
Aplus = pinv(A) %creates pseudoinverse of the matrix and any values less than the tolerance are treated as zero
aug = [A b1]
rref(aug) %since there is a row of zeroes in the reduced row echeleon form of the augmented matrix, there are many solutions to this problem
rank(aug) %since the rank of the augmented matrix is 3 which is less than the number of columns, the augmented matrix has some dependent vectors inside it, meaning there are many solutions  


x1 = Aplus + b1 
x2 = Aplus + b2 
e1 = A*x1 - b1 
e2 = A *x2 -b2 
%why are x1 and x2 the best solutions?
%Because transpose matrices take much more computing power than the
%pseudoinverse. Additionally, A inverse doesn't exist because it is singular and doesn't take into
%account the nullspace. These solutions are the best because epsilon (which represents the error) is equal to zero if the solution is perfect. 
% Since this is not a perfect solution, we are looking for the solution that reduces epsilon as much as possible. The pseudoinverse minimizes x without adding stuff from null space. 
% Amongst all x that you can try, x2 minimizes the size of epsilon. It also
% minimizes ||x|| for solutions that have the same value for epsilon. 