import csv
import itertools

with open('pittsburgh.txt', 'r') as in_file:
    stripped = (line.strip() for line in in_file)
    lines = (line for line in stripped if line)
    grouped = zip(*[lines])
    with open('pittsburgh.csv', 'w') as out_file:
        writer = csv.writer(out_file)
        writer.writerows(grouped)