function RR_Plot_Truss(Q,P,C,U,x);
N=[Q P]; [m,n]=size(C); [d,q]=size(Q); [d,p]=size(P);
axis equal, axis tight, grid, axis([-0.05 1.05 -0.3 0.4]), hold on
h=max(Q(2,:));
if h==0; fac=0; else, fac=1; end
fill(P(1,1)+[-.035     0 .035*fac],P(2,2)+[-.05 0 -.05],'k-')
fill(P(1,2)+[-.035*fac 0 .035    ],P(2,2)+[-.05 0 -.05],'k-')
N=[Q P]; 
disp('In members: blue=tension, red=compression, black=no force')
mn=min(x); fprintf('maximum tension     = %0.5g\n',mn)
mx=max(x); fprintf('maximum compression = %0.5g\n',mx)
for i=1:m
  [i1,d1]=max(C(i,:)); [i2,d2]=min(C(i,:)); lw=3; 
  if x(i)<-0.01,    sy='r-'; if x(i)<mn*0.9, lw=6; end
  elseif x(i)>0.01, sy='b-'; if x(i)>mx*0.9, lw=6; end
  else, sy='k-'; end
  plot([N(1,d1) N(1,d2)],[N(2,d1) N(2,d2)],sy,"LineWidth",lw)
end
fac=0.1; for i=1:q
  if h>0
     f=quiver(N(1,i),N(2,i),fac*U(1,i),fac*U(2,i),0);
  else
     f=quiver(N(1,i)-fac*U(1,i),N(2,i)-fac*U(2,i),fac*U(1,i),fac*U(2,i),0);
  end
  set(f,'MaxHeadSize',10000,'linewidth',3,'color','k');
end