%% ME396HW_q05 
% By Autumn Thill
% Due on 23 September 

%compute the principle moments of inertia of the Iphone 16 Pro Max 

Lz = 163; % mm 
Ly = 77.6; %mm 
Lx = 8.25; %mm 
m = 227; %grams  

%first principal axis (Spins like a frisbee) Axis out the screen
I1 = m*(Ly^2 + Lz^2)/12

%second principal axis (spins end over end) Axis goes out volumne botton 
I2 = m*(Lx^2 + Lz^2)/12

%third principal axis (spins like a football) Axis goes out charging port 

I3 = m*(Lx^2 + Ly^2)/12