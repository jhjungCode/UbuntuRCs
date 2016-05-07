#!/usr/bin/env python3
# coding: utf-8
import numpy as np
from scipy.interpolate import Rbf
from scipy.interpolate import interp1d

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib import cm

(time0, NH3) = np.loadtxt('nh3.csv', unpack=True, delimiter=',', skiprows=1, usecols=(0,1))
(time1, NH3UI) = np.loadtxt('nh3ui.csv', unpack=True, delimiter=',', skiprows=1, usecols=(0,2))

# plot data
font = {'weight' : 'normal',
        'size'   : 12}

matplotlib.rc('font', **font)

fig, ax1 = plt.subplots(figsize=(12,8))
ax2 = ax1.twinx()

ax1.grid(b=True, which='both')

plt.title('NH3 UI and Concentration', fontsize = 20, y=1.05)
ax1.set_xlabel('time(s)')
ax1.set_ylabel('UI')

ln1 = ax1.plot(time0, NH3UI, 'r')
ln2 = ax2.plot(time1, NH3, 'b--')

ax1.legend(ln1+ln2, ['NH3 UI', 'NH3 Conecentration'], loc=1)

# added two lines of UI
sTime0 = time0[time0>0.00]
sTime1 = time1[time1>0.05]
sNH3 = NH3[time0>0.00]
sNH3UI = NH3UI[time1>0.05]
maxNH3UI1 = sNH3UI[np.argmax(sNH3)]
maxNH3UI2 = sNH3UI[np.argmax(sNH3UI)]

ax1.axvline(x=sTime0[np.argmax(sNH3)], linewidth=4, color='b', ls='--')
ax1.axvline(x=sTime1[np.argmax(sNH3UI)], linewidth=4, color='r', ls='--')
ax1.annotate(
    '{:.2f}'.format(maxNH3UI1), xy=(sTime0[np.argmax(sNH3)], maxNH3UI1),
    xytext=(-10, 10), ha='right', color='b',
    textcoords='offset points',
    arrowprops=dict(arrowstyle='->', shrinkA=0)
)
ax1.annotate(
    '{:.2f}'.format(maxNH3UI2), xy=(sTime1[np.argmax(sNH3UI)], maxNH3UI2),
    xytext=(-10, 10), ha='right', color='r',
    textcoords='offset points',
    arrowprops=dict(arrowstyle='->', shrinkA=0)
)

plt.savefig('chart1.png')
