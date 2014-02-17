#
# ssp3dplotter.py
#
"""
Plot the solution generated by invpolsolver.py
"""

from __future__ import unicode_literals
from numpy import loadtxt
from matplotlib.font_manager import FontProperties
import matplotlib as mpl
from pylab import figure, plot, xlabel, ylabel, grid, hold, legend, title, savefig
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import numpy as np

from subprocess import call

mpl.rcParams['text.usetex']=True
mpl.rcParams['text.latex.unicode']=True


t, x1, y1, x2, y2 = loadtxt('data/sspsolution.dat', unpack=True)

fig = plt.figure()
ax = fig.gca(projection='3d')

#points = range(int(len(x1))-30000, int(len(x1)))
points = range(0, 25000)

ax.plot(x1[points], x2[points], y2[points], linewidth=0.4, color='#a81800')
ax.set_xlabel('$x_1$', fontsize=10)
ax.set_ylabel('$x_2$', fontsize=10)
ax.set_zlabel('$y_2$', fontsize=10)
ax.w_xaxis.set_pane_color((1, 1, 1, 1.0))
ax.w_yaxis.set_pane_color((1, 1, 1, 1.0))
ax.w_zaxis.set_pane_color((1, 1, 1, 1.0))
ax.grid(False)
ax.view_init(30,30)

Nticks = 5

xticks = np.linspace(np.min(x1), np.max(x1), Nticks)
ax.set_xticks(xticks)
ax.set_xticklabels(["$%.1f$" % xtik for xtik in xticks], fontsize=8); # use LaTeX formatted labels

yticks = np.linspace(np.min(x2), np.max(x2), Nticks)
ax.set_yticks(yticks)
ax.set_yticklabels(["$%.1f$" % ytik for ytik in yticks], fontsize=8); # use LaTeX formatted labels

zticks = np.linspace(np.min(y2), np.max(y2), Nticks)
ax.set_zticks(zticks)
ax.set_zticklabels(["$%.1f$" % ztik for ztik in zticks], fontsize=8); # use LaTeX formatted labels

savefig('image/ssp.eps', bbox_inches='tight')
#savefig('image/ssp.pdf', bbox_inches='tight', dpi=100)

#call(["pdftops", "-level3", "-eps", "image/ssp.pdf", "image/ssp.eps"])

redref = 0

if redref:
	
	indexref = np.where(y2<0)
	
	y2refred = np.copy(y2)
	y2refred[indexref] = -y2[indexref]
	x2refred = np.copy(x2)
	x2refred[indexref] = -x2[indexref]

	fig = plt.figure()
	ax=fig.gca(projection='3d')
	ax.plot(x1, y2refred, y1, linewidth=0.3)
	ax.set_xlabel('$x_1$', fontsize=18)
	ax.set_ylabel('$y_2$', fontsize=18)
	ax.set_zlabel('$y_1$', fontsize=18)
	savefig('image/ssprefred.png', bbox_inches='tight', dpi=150)

reqv = 0

if reqv:
	
	ax.hold(True)
	ax.plot(x1[0:10000], x2[0:10000], y2[0:10000], linewidth=0.3, c='r')
	savefig('image/sspreqv.png', bbox_inches='tight', dpi=150)
	
plt.tight_layout()
plt.show()
