#
# invpolsolver.py
#
"""
Use odeint to solve differential equations defined by vinvpol in twomode.py
"""

from scipy.integrate import odeint
import twomode

#Parameter values:
mu1 = 1 
a1 = 0.47 
b1 = -1 
c1 = 1 
mu2 = -1 
a2 = 0 
b2 = 0 
c2 = -1 
e2 = 0
#mu1 = -2.8 
#a1 = -1 
#b1 = 0 
#c1 = -7.75 
#mu2 = 1 
#a2 = -2.66 
#b2 = 0 
#c2 = 1 
#e2 = 1

#Initial conditions:
x10 = 0.181612
x20 = -0.512500
y10 = 1.939339
y20 = -0.010343

# ODE solver parameters
abserr = 1.0e-8
relerr = 1.0e-6
stoptime = 100
numpoints = 10000

# Create the time samples for the output of the ODE solver:
t = [stoptime * float(i) / (numpoints - 1) for i in range(numpoints)]

# Pack up the parameters and initial conditions:
p = [mu1, a1, b1, c1, mu2, a2, b2, c2, e2]
x0 = [x10,x20,y10,y20]

# Call the ODE solver
xsol = odeint(twomode.vfullssp, x0, t, args=(p,), atol = abserr, rtol = relerr)

#Print the solution
for t1, x1 in zip(t,xsol):
	print t1, x1[0], x1[1], x1[2], x1[3]
