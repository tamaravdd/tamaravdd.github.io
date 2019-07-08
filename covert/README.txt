--------------------------------------
Code to get training sample of tweets
--------------------------------------

* Team: Tamara, Zack, Mirta and Paul 

* Files * 
get_twitter_followers.py #original code from Zack to get twitter followers 
my_keys.py # Mirta's API key 
seeds.txt # Seed twitter ids (numbers) 




* Steps * 
1. select news sites on twitter
2. select followers of these sites (let's call these people group A) 
3. look at who/which organization people from group A are following and determine their political identity using a megalist of left/right websites
4. look at the followers of people from group A
5. look at the tweets of these followers and look at which organizations they retweet or mention 
6a. determine the homogeneity of group A's network given the political identity of their followers determined by these organizations retweeted/mentioned (using megalist from step 3). 
6b. potentially also look at if people of group A and their followers know each other in real life (follow each other) to determine the "actual" network of people from group A. 

=> This point we have people from group A, their political identity, and their network composition 

7. Get a bunch of tweets from people from group A. 
8. Reduce the number of tweets for MTurkers by either: 
   a. screen for political tweets
   b. or, determine the uniqueness of people in the left and the right and only selecting tweets using those unique words 
9. Do MTurk exp 1 and 2 
10. NLP to determine for all tweets if covert, overt, or non political. 
11. Analysis: with real world data and on a new twitter data with network info to double check if people with heterogeneous are in fact more likely to use covert signals.