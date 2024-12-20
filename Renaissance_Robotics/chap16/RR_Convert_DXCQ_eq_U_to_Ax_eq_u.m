function [A,u]=RR_Convert_DXCQ_eq_U_to_Ax_eq_u(Q,P,C,U); 
% Sets up to calculate the internal forces in a truss defined by Q,P,C and loading U

N=[Q P]; [m,n]=size(C); [d,q]=size(Q); [d,p]=size(P);
CQ=C(:,1:q); CP=C(:,q+(1:p)); M=N*C';       % partition connectivity matrix, compute M
for i=1:m; D(:,i)=M(:,i)/norm(M(:,i)); end  % compute the direction vectors D(:,i)
x=sym('x',[1 m]); X=diag(x);                % set up a symbolic and diagonal X matrix
% set up (3a) in RR symbolically.  note that sys has d rows and q cols. 
sys=D*X*CQ-U;                               % we seek the (diagonal) X s.t. sys=0.

% Now, set up x1 to xm as symbolic variables, and convert (3a) to (3b) [i.e., A*x=u]
for i=1:m; exp="syms x"+i; eval(exp); end
% set up a symbolic equationsToMatrix command in SYS
SYS='equationsToMatrix(['; for i=1:d, for j=1:q, SYS=SYS+"sys("+i+","+j+")==0";
       if i<d | j<q, SYS=SYS+","; end, end, end, SYS=SYS+"],[";
for i=1:m, SYS=SYS+"x"+i; if i<m, SYS=SYS+","; end, end, SYS=SYS+"])";
% finally, execute the symbolic equationsToMatrix command assembled above
[A,u]=eval(SYS);        
A=eval(A); u=eval(u); % convert A and u to a regular matrix and vector
disp("A has mhat="+d*q+" equations, nhat="+m+" unknowns, and rank="+rank(A))
