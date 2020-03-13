# -*- coding: utf-8 -*-
"""
Created on Sat Mar  7 14:10:57 2020

@author: Colepink3
"""
from pyspark import SparkConf, SparkContext


def loadMovieNames():
    movieNames = {}
    with open("ml-100k/u.iTEM") as f:
        for line in f:
            fields = line.split('|')
            movieNames[int(fields[0])] = fields[1]
    return movieNames

def parseLine(line):
    fields = line.split()
    rating = int(fields[2])
    movieID = int(fields[1])
    return (movieID, ((int(rating)), 1))


conf = SparkConf().setMaster("local[*]").setAppName("BestMovies")
sc = SparkContext(conf = conf)
    

# Load Movie Name
movieNames = loadMovieNames()

# Load up the raw u.data file
lines = sc.textFile("file:///sparkcourse/ml-100k/u.data")

movieRatings = lines.map(parseLine)

ratingTotalsAndCount = movieRatings.reduceByKey(lambda movie1, movie2: ( movie1[0] + movie2[0], movie1[1] + movie2[1] ) )


# Take top 10
results = ratingTotalsAndCount.sortByKey(False).take(10)
# Print
for result in results:
    print(movieNames[result[0]], result[1])
