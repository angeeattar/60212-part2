import re
import string
import csv
#anaconda is super awesome
import pandas as pd
import json


df = pd.read_csv("pittsburgh.csv")
typeOfRoad = df['Type']
print (typeOfRoad)
 
# manually made a dictionary with the different types of roads
# it works, wtvr

data = { "Avenue":0, 
         "Square":0, 
         "Street":0, 
         "Boulevard":0, 
         "Bridge":0, 
         "Bypass":0, 
         "Trail":0, 
         "Drive":0, 
         "Plaza":0, 
         "Hub":0, 
         "Road":0,
         "Way":0,
         "Alley":0,
         "Place":0,
         "Court":0,
         "Lane":0,
         "Terrace":0,
        }

# go through each piece in the csv
# if one of the types from my dictionary is in the piece
# count it in that type's dictionary
n = 0

while n < len(typeOfRoad):
    s = typeOfRoad[n]
    s = re.sub(r'[^\w\s]','',s)
    for key in data:
        if key in s:
            data[key]+=1
    n+=1
# print(data)


### if I want percentage representation instead of the actual value:
# count all the road types to make sure I've got everything
total = 0
for key in data:
    total += data[key]
#print (total)

# duplicate the dictionary so that I can put the percentage values
# don't want to overwrite the old dictionary 
# in case I want a different viz
dataPercent = data

for key in dataPercent:
    val = (dataPercent[key]/total)
    dataPercent[key] = val
#print(dataPercent)

## Check if percents are adding up correctly
# percentTotal = 0
# for key in dataPercent:
#     percentTotal += dataPercent[key]
# print (percentTotal)


# creating a list that will have a dictionary for each typy
# kinda hack-ish way to make the json list

jsonData = []
for key in data:
    d = {"type":key,"frequency":dataPercent[key]}
    jsonData.append(d)

print(jsonData)

# creating and saving the json file

with open('pittsburghData.json', 'w') as f:
     json.dump(jsonData, f)

