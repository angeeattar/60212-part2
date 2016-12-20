import re
import string
import csv

#re = regex = regular expression

englishWords = set(line.strip() for line in open('words_test.txt'))
tweets = []

with open('tweets.csv', 'rb') as csvfile:
    tweetReader = csv.reader(csvfile, delimiter=' ', quotechar='|')
    for row in tweetReader:
        tweets.append(', '.join(row))

file = open("cleanTweets.txt", "w")

for t in tweets:
	input_string = t
	exclude = set(string.punctuation)
	input_string = ''.join(ch for ch in input_string if ch not in exclude)

	tweet = re.sub(r'\@\w+',"",input_string);
	tweet = re.sub(r'https\w+',"",input_string);
	tweet = re.sub(r'okay babe',"",input_string);


	output=[]
	for w in tweet.split():
		if w.lower() in englishWords:
			output.append(w) 
	cleanTweet = " ".join(output);
	file.write("%s"%cleanTweet)
	file.write("\n")

file.close()


