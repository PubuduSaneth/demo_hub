"""Compute ECDF for a one-dimensional array of measurements."""
import numpy as np

def ecdf(data):

    # Number of data points: n
    n = len(data)

    # x-data for the ECDF: x
    x = np.sort(data)

    # y-data for the ECDF: y
    #  data of the ECDF go from 1/n to 1 in equally spaced increments.

    y = np.arange(1, n+1) / n

    return x, y
