# Import Libary for Spark and collections to allow us to use dictionaries
# and order by dictionaries
import sys
from pyspark import SparkConf, SparkContext
import collections


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

# Map Movie Name, Sum Ratings and Number of Ratings for each movie
ratingTotalsAndCount = movieRatings.reduceByKey(lambda movie1, movie2: ( movie1[0] + movie2[0], movie1[1] + movie2[1] ) )
# Filter out Movies with more than 150 ratings
popularTotalsAndCount = ratingTotalsAndCount.filter(lambda x: x[1][1] >= 150)
# Calculate Average Rating
averageRatings = popularTotalsAndCount.mapValues(lambda x: (x[0], round(x[0]/x[1])))
# Take top 10
results = averageRatings.sortByKey(True).take(10)

# Print
for result in results:
   print(movieNames[result[0]], result[1])


# !spark-submit Mattison_Nicole13.py
