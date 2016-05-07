#!/usr/bin/env python2
# coding: utf-8
import numpy as np
import re
from os import listdir

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

Datas = np.array(
    [np.sort(
        np.loadtxt(f, delimiter=',', skiprows=1,
            usecols=(0,1,2),
            dtype = [('value','<f8'), ('r','<f8'), ('theta','<f8')]),
            order=['r', 'theta'])
    for f in files if f.endswith('.csv')]
)
sumData = np.sum(Datas['value'], axis=0)
print("Sum : ", sumData)

avgData = np.average(sumData)
print("Average : ", avgData)
