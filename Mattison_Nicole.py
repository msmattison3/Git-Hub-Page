# -*- coding: utf-8 -*-
"""
Created on Thu Feb 27 13:03:59 2020

@author: Colepink3
"""

import sys
from pyspark import SparkConf, SparkContext
from math import sqrt

def loadMovieNames():
    movieNames = {}
    with open("ml-100k/u.ITEM", encoding='ascii', errors='ignore') as f:
        for line in f:
            fields = line.split('|')
            movieNames[int(fields[0])] = fields[1]
    return movieNames

conf = SparkConf().setMaster("local[*]").setAppName("MovieSimilarities")
sc = SparkContext(conf = conf)

print("\nLoading movie names...")
nameDict = loadMovieNames()

'''from pyspark import SparkConf, SparkContext
conf = SparkConf().setMaster("local").setAppName("MovieRating")
sc = SparkContext(conf = conf)



data = sc.textFile("file:///sparkcourse/ml-100k/u.data")'''
