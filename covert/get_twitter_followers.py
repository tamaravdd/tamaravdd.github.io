import importlib
import time, json, math, os
#from tqdm import tqdm
from twython import Twython, TwythonError, TwythonRateLimitError

# -*- coding: UTF-8 -*-

''' ### Code to scrape followers of a set of users
# Required input: .txt file of user ids (number) named 'follower#_ids.txt' where # is the desired starting degree
                  However, if inputting seeds, seed file name needs to be specified.

                my_keys.py -- A file with variables for Twitter API authorization.
                   key = 'blahblahblah123123123123'
                   secret = 'blahblahblah456456456456'
                   owner = 'your_username'
                   owner_id = 'your_userid'
                   access_token = 'blahblahblah123123123123thisoneissuperlonglikereallylonglikedamn'
                   access_token_secret = 'blahblahblah123123123123thisoneisshorter'

# Output: A file named "follower#_ids.json" where # is the target degree (1 greater than starting)
          Contains json objects with one key (account id) that returns a list of user ids that follow them.

# Notes:
        Output json is not valid input for this file.
        Degree variable is only pertinent for degree == 1 which assumes input file contains screen names and not ids.
'''


def get_followers_cursor(account_id,use_id=True,cursor=-1):
    if use_id:
        cursor = api.get_followers_ids(user_id = account_id,count=5000,cursor=next_cursor)
    else:
        cursor = api.get_followers_ids(screen_name = account_id,count=5000,cursor=next_cursor)
    return cursor

def get_followings_cursor(account_id,use_id=True,cursor=-1):
    if use_id:
        cursor = api.get_friends_ids(user_id = account_id,count=5000,cursor=next_cursor)
    else:
        cursor = api.get_friends_ids(screen_name = account_id,count=5000,cursor=next_cursor)
    return cursor

def get_followers(account_id,use_id=True):
    if use_id:
        followers = api.get_followers_ids(user_id = account_id,return_pages=True,)
    else:
        followers = api.get_followers_ids(screen_name = account_id,return_pages=True,)
    return followers

def get_followings(account_id,use_id=True):
    if use_id:
        followings = api.get_friends_ids(user_id = account_id)
    else:
        followings = api.get_friends_ids(screen_name = account_id)
    return followings


def get_user(account_id,use_id=True):
    if use_id:
        user = api.lookup_user(user_id=account)
    else:
        user = api.lookup_user(screen_name=account)
    return user

if __name__ == "__main__":
    import sys
    import argparse

    # echo command line immediately...
    sys.stderr.write("%s\n" % " ".join(sys.argv))
    sys.stderr.flush()

    # parse command line...
    parser = argparse.ArgumentParser(description='Command line for manual_twitter_scrape.py.')
    # main function arguments...
    parser.add_argument('-keys_fname', type=str, required=True)
    parser.add_argument('-seeds_fname', type=str, required=False)
    parser.add_argument('-seeds_are_ids', type=bool, default=True)
    parser.add_argument('-max_followers', type=float, default=float('inf'))
    parser.add_argument('-degree', type=int,default=1)

    opts = parser.parse_args()

    if opts.keys_fname[-3:] == '.py':
        opts.keys_fname = opts.keys_fname[0:-3]


    keys = __import__(opts.keys_fname)

    log_file = open(opts.seeds_fname+'.log','wb')
    
    #Twython init
    api = Twython(keys.key, keys.secret, keys.access_token, keys.access_token_secret)


    with open(opts.seeds_fname,'r') as start_ids_f:
        start_ids = list(set([x.replace('\n','') for x in start_ids_f.readlines()]))
    print("%i unique accounts to search"%len(start_ids))

    count = 0
    for account in tqdm(start_ids):
        account_followers = []
        next_cursor = -1
        while next_cursor:
            try:
                search = get_followers_cursor(account,opts.seeds_are_ids,cursor=next_cursor)
                account_followers.extend(search['ids'])
                #print(account_followers)
                next_cursor = search['next_cursor']
                #time.sleep(68)
                header = api.get_lastfunction_header("x-rate-limit-reset")
                waittime = float(header) - time.time()
                #print("Wait Time:", waittime/60, "minutes") #Readout of minutes remaining
                #print("Sleeping a bit")
                if waittime > 0:
                    time.sleep(waittime)
                #print("awake")
                #continue
            # too many requests
            except TwythonRateLimitError:
                print('Followers rate limit error')
                #log_file.write('%s\n' % account)
                header = api.get_lastfunction_header("x-rate-limit-reset")
                waittime = float(header) - time.time()
                time.sleep(waittime + 10) #+1 added to account for any rounding issues, as time.sleep() crashes if presented with a negative value

            except TwythonError as e:
                # no internet connection
                if e.error_code == 8:
                    # wait a minute
                    time.sleep(60*1)
                else:
                    print(e)
                    break
            except StopIteration:
                break

    user_json = json.dump(account_followers,open('%s_followers.json' % account,'w'))



    sys.stdout.write('Completed follower grab for all ids in %s' % opts.seeds_fname)