function ps = poincare(xhatp, nhat)
%Poincare section calculator using method described in ChaosBook sect 3.2 
%xname=string to tell the name of file keeping the time evolved x values
%xhatp = a point on the poincare section
%n = normal of the poincare section

load('timeev.mat'); % Load x, tfinal, deltat integrated by RK4

%Plane equation for the Poincare section (ChaosBook eq 3.6):

U = @(x) dot((x-xhatp),nhat);

n=size(x,2);
N=10; % Number of divisions to look for intersection
tol=1e-10; %Tolerance for 'zero'
ps = [xhatp;0]; %Assign a dummy value to ps vector to be able to fill afterwards

for i = 1:n-1
	%If plane equation change sign from positive to negative, look for the intersection:
	if U(x(:,i)) > 0 && U(x(:,i+1)) < 0 
			
		%Integration until the plane condition is satisfied:
			
		xdummy = x(:,i);
			
		DotProduct = U(xdummy); 
		deltatadaptive = deltat/2;
		pstime = (i-1)*deltat;
		
		while DotProduct > tol
		
			%Adaptive integration: 
			
			xint=integrator(xdummy, deltatadaptive, deltatadaptive);
			pstime = pstime + deltatadaptive;
			
			xdummy = xint(:,2);
			
			DotProduct = U(xdummy);
			
			% If the Poincare section is passed get back in integration
			
			if DotProduct < 0 % If the Poincare section is passed
				
				xdummy = xint(:,1);
				pstime = pstime - deltatadaptive;
				deltatadaptive = deltatadaptive/2;
				
			end
		
		end
		
		ps(:,size(ps,2)+1) = [xdummy;
							  pstime];
		
	end
	
end

ps = ps(:, 2:size(ps,2));
