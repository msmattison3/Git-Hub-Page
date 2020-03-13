# -*- coding: utf-8 -*-
"""
Created on Fri Sep  6 20:55:53 2019

@author: Colepink3
"""

import requests

my_wm_username = 'nmmattison'
search_url = 'https://buckets.peterbeshai.com/api/?player=201939&season=2015'
response = requests.get(search_url, headers={
            "User-Agent": "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36"})
#print(response)

#Command Line Arguments




numJumpShotsAttempt = 0
numJumpShotsMade = 0
percJumpShotMade = 0.0

#Write your program here to populate the appropriate variables
Emptylist = []
for shot in response.json(): #I emailed about this problem earlier. I cannot get json to run.
    if shot["ACTION_TYPE"] == "Jump Shot":
        numJumpShotsAttempt = numJumpShotsAttempt + 1
    
    if shot["ACTION_TYPE"] == "Jump Shot" and shot["EVENT_TYPE"] == "Made Shot":
        numJumpShotsMade = numJumpShotsMade + 1
        
    else:
        pass


percJumpShotMade = numJumpShotsMade/numJumpShotsAttempt * 100  

print('Player ID: ',shot["PLAYER_ID"])        
print('Season Year: ',shot["SEASON"])
print(my_wm_username)
print(numJumpShotsAttempt)
print(numJumpShotsMade)
print(percJumpShotMade)