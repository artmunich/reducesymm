#
#psectandretmap.py
#
"""
	Calculates the poincare section intersections using the previously computed
	solution on the slice.
	Plots the poincare section.
	Computes and plots the return map.
	This will produce correct results only if the xhatp=[1,0,0,0] slice 
	is used.
"""

import numpy as np
from scipy.optimize import fsolve

import numpy as np

import twomode
import onslicesolver
#import psectslice

#Load parameters:
p = np.loadtxt('data/parameters.dat')

def rpo(xt):
	#print "xt"
	#print xt
	abserr = 1.0e-14
	relerr = 1.0e-12
	#stoptime = xt[4]
	stoptime = xt[3]
	numpoints = int(stoptime/0.01 + 1.0)
	#print "numpoints:"
	#print numpoints
	#numpoints = 2
	#xphi0=[xt[0], xt[1], xt[2], xt[3], 0]
	xphi0=[xt[0], 0, xt[1], xt[2], 0]
	
	# Create the time samples for the output of the ODE solver:
	t = [stoptime * float(i) / (numpoints - 1) for i in range(numpoints)]
	
	xsol = onslicesolver.integrate(xphi0, p, t, abserror=abserr, relerror=relerr)
	xsol3d = np.concatenate((np.array([xsol[:,0]]).T, xsol[:,2:4]), axis=1)
	
	#diff = np.concatenate((xsol[10:len(xsol),0:4], np.array([t[10:len(xsol)]]).T), axis=1) - xt[0:5]
	diff = np.concatenate((xsol3d[10:len(xsol),0:3], np.array([t[10:len(xsol)]]).T), axis=1) - xt[0:5]
	#diff = np.linalg.norm(diff, axis=1)

	#diff = xsol[10:len(xsol),0:4] - xt[0:4]
		
	#diff[:,4] = diff[:,4]/xt[4]
	diff = np.linalg.norm(diff, axis=1)
	
	imin = np.argmin(diff)+10
	
	#print "imin"
	#print imin
	
	#xf = [xsol[imin, 0], 
		  #xsol[imin, 1], 
		  #xsol[imin, 2], 
		  #xsol[imin, 3], 
		  #t[imin]] 
	xf = [xsol3d[imin, 0], 
		  xsol3d[imin, 1], 
		  xsol3d[imin, 2], 
		  t[imin]] 
	
	#print "xf"
	#print xf
	
	return xf - xt

def findrpo(xt0):
	rpos = fsolve(rpo, xt0)
	return rpos

if __name__ == "__main__":

	#candidate:
	x10=0.4525858904295301
	y10=0.0000000000000000
	x20=0.0510590529667102
	y20=0.0318533099915381
	phi0=0
	t0 = 3.63
	
	xt0 = np.array([x10, y10, x20, y20, t0], float)
	
	#xt0 = np.array([4.551491852618429479e-01, 0.000000000000000000e+00, 1.398837906790846852e-01, 4.074262645591256171e-03, 1.096855715200001669e+01], float)
	xt0 = np.array([4.551491852618429479e-01, 1.398837906790846852e-01, 4.074262645591256171e-03, 1.096855715200001669e+01], float)
	
	rpos = findrpo(xt0)
	
	print rpos
