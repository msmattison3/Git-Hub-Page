# -*- coding: utf-8 -*-
"""
Created on Mon Sep 23 11:38:25 2019

@author: Colepink3
"""

#Imports
from math import sqrt
from math import log
from math import floor
#math.sqrt()
#math.log(x[,base])
#math.floor(x)


###### Setup ######
P = [2,4,5,6,3,7,45,3,23,22,67,87,3,56,78,2000,1000,234,567,765]
#print(P)
N = 20
A = list(range(1,N+1))
target = 5
k = 4



###### Linear Search ######

def linearSearch(P,target):
    for x in range(len(P)):
        if(P[x]==target):
            return x
    return False
print("Looking for [{0}] in array {1}".format(target,P))
print("Found at index: ",linearSearch(P,target))

###### Binary Search ######

def binarySearch(A, target):
    low = 0
    high = len(A) - 1
    
    while low <= high:
        mid = low + (high-low) // 2
        print("LOW {0} HI {1} MID {2}, comparing {3} to {4}".format(
                low,high,mid,target,A[mid]))
        if A[mid] == target:
            return mid
        if A[mid] > target:
            high = mid - 1
        else:
            low = mid + 1
    return False

F = range(20)

print("Bsearch ",binarySearch(P,target))
print(binarySearch (P,target))
print("Found at index:",binarySearch(P,target))


###### Exhaustive Search ######

def exhaustiveSearchSqrt(k):
    epsilon = 0.001
    x = 1000000
    while x*x < N - epsilon:
        x += epsilon
    return x

from math import sqrt
print(exhaustiveSearchSqrt(k))
print("For Comparison: ", sqrt(k)) 

###### Bisection Search ######

def bisection_search_kth_root(N, k):
    low = 0
    high = len(A) - 1
    epsilon = 0.001
    
    while (abs(high - low) > epsilon):
        mid = low + (high-low) // 2
        if A[mid] == target:
            return mid
        if A[mid] > target:
            high = mid - 1
        else:
            low = mid + 1
    return False

    epsilon = 0.001
    x = 1000000
    while x**k < N - epsilon:
        x += epsilon
    return x
 
print("Bisection Interval [low, high]".format(bisection_search_kth_root(N, k)))
print("For Comparison: ",sqrt(N))

###### def bisection_NlgN ######

def bisection_NlgN(N):
    P.sort()
    low = 0
    high = len(A) - 1
    epsilon = 0.001

    while (abs(high - low) > epsilon):
        mid = low + (high-low) // 2
        if A[mid] == target:
            return mid
        if A[mid] > target:
            high = mid - 1
        else:
            low = mid + 1
    return False
    
print("Bisection_NlgN:".format(bisection_NlgN(N)))

###### Newton Raphson ######

def newton_sqrt(k):
    epsilon = .001
    y = k / 2.0
    while abs(y*y-k) >= epsilon:
        y = y - (((y**2) - k)/(2-y))
    return y

#print(y)
print(newton_sqrt(k))
print("For Comparison: ",sqrt(k))