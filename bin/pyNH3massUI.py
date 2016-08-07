#!/usr/bin/env python3
# coding: utf-8
import numpy as np
import re, os
from os import listdir
#from scipy.interpolate import Rbf
from scipy.interpolate import griddata

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.patches import Circle

def grp(pat, txt):
    r = re.search(pat, txt)
    return r.group(1) if r else '&'

files = listdir('.')
files.sort(key=lambda l: float(grp("_nh3_(.*)\.",l)))

#Coords = np.loadtxt(np.sort(listdir('.')[0], unpack=True, delimiter=',',\
        #skiprows=1, usecols=(1,2), axis=0))
Datas = np.array(
    [np.sort(
        np.loadtxt(f, delimiter=',', skiprows=1,
            usecols=(0,1,2),
            dtype = [('value','<f8'), ('r','<f8'), ('theta','<f8')]),
            order=['r', 'theta'])
    for f in files if f.endswith('.csv')]
)
sumData = np.sum(Datas['value'], axis=0)

X = Datas['r'][0]*np.cos(Datas['theta'][0])
Y = Datas['r'][0]*np.sin(Datas['theta'][0])

xi, xstep = np.linspace(X.min(), X.max(), 50, retstep=True)
yi, ystep = np.linspace(Y.min(), Y.max(), 50, retstep=True)
XI, YI = np.meshgrid(xi, yi)
print(X.min(), X.max())
#rbf = Rbf(X, Y, sumData)
#ZI = rbf(XI, YI)
#ZI = griddata(np.array((X, Y)).T, sumData, (XI, YI), method='nearest')
#ZI = griddata(np.array((X, Y)).T, sumData, (XI, YI), method='linear')
ZI = griddata(np.array((X, Y)).T, sumData, (XI, YI), method='cubic')

avgData = np.average(sumData)
diffAvgDAta = np.average(np.abs(sumData-avgData))
UI = 1 - 0.5*diffAvgDAta/avgData

print("UI : ", UI)

# plot data
fig, ax = plt.subplots(figsize=(8,5))
fig.subplots_adjust(right=0.8)
circle = Circle((0, 0), X.max() - xstep,
       facecolor='none', edgecolor=(0,0.8,0.8), linewidth=3, alpha=0.5)
#circle = Circle((0, 0), X.max(),
       #facecolor='none', edgecolor=(0.8 ,0.8,0.8), linewidth=3, alpha=0.5)
#ax.add_patch(circle)

if not os.path.exists('img'):
    os.makedirs('img')

#im = plt.pcolor(XI, YI, ZI, cmap=cm.jet)
im = plt.imshow(ZI, extent=(XI.min(), XI.max(), YI.min(), YI.max()), origin='upper')
#im = plt.imshow(ZI, extent=(XI.min(), XI.max(), YI.min(), YI.max()), origin='lower')
#im.set_clip_path(circle)
plt.title('cumulative NH3UI : {:.2f}'.format(UI))
X_mean = (XI.min() + XI.max())/2
Y_mean = (YI.min() + YI.max())/2
plt.xlim((XI.min() - X_mean)*1.2 + X_mean, (XI.max() - X_mean)*1.2 + X_mean)
plt.ylim((YI.min() - Y_mean)*1.2 + Y_mean, (YI.max() - Y_mean)*1.2 + Y_mean)
plt.clim(min(0,sumData.min()), sumData.max())
#plt.clim(min(0,sumData.min()), 0.4)
plt.colorbar()
plt.savefig('img/chart1.png')
plt.clf()

for i, filename in enumerate(files) :
    curData = Datas['value'][i]
    avgData = np.average(curData)
    diffAvgDAta = np.average(np.abs(curData - avgData))
    curUI = 1 - 0.5*diffAvgDAta/avgData
    curZI = griddata(np.array((X, Y)).T, curData, (XI, YI), method='cubic')

    im = plt.imshow(curZI, extent=(XI.min(), XI.max(), YI.min(), YI.max()), origin='upper')
    #im.set_clip_path(circle)
    plt.title('current NH3UI : {:.2f} / cumulative NH3UI : {:.2f}'.format(curUI, UI))
    plt.clim(min(0,curData.min()), curData.max())
    plt.colorbar()
    print(filename)
    plt.savefig('img/movie' + str(i) + '.png')
    plt.clf()

