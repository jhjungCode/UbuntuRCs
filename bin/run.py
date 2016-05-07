#!/usr/bin/env python2
# coding: utf-8
import numpy as np
import re
from os import listdir

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

def grp(pat, txt):
    r = re.search(pat, txt)
    return r.group(1) if r else '&'

files = [f for f in listdir('.') if f.endswith('.csv')]
#files.sort(key=lambda l: float(grp("\((.*)\)\.",l)))
files.sort(key=lambda l: float(grp("_nh3_(.*)\.",l)))

Datas = np.array(
    [np.sort(
        np.loadtxt(f, delimiter=',', skiprows=1,
            usecols=(0,1,2),
            dtype = [('value','<f8'), ('r','<f8'), ('theta','<f8')]),
            order=['r', 'theta'])
    for f in files]
)
density = 0.7068824
velocity = 1.522755
dia = 0.1057
dA = 3.141592/4*dia**2/277
dt = 0.0002
sumData = np.sum(Datas['value'], axis=1)*density*velocity*dA*dt
print(sum(sumData))
plt.plot(sumData)
plt.savefig('chart.png')
print(sumData)

