# Step 1 - Authenticate
consumer_key= 'dNPO3EUKQLJSpofg5vm8oE1Mu'
consumer_secret= 'C24oe6690gN8SqZiZ5XlsdNnltR5EV0M0HDffhXZh2o3xUPTju'

access_token='962657191-V1xd2y575O7uuTfDCZrKqg3GP1grdvsfIRRanHVt'
access_token_secret='NFwbNchfMB3cWgxVRV5b8a5IKtkJFcqTxKUZR8DS8XisX'



import tweepy


auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

print('authenticated - Twitter')

public_tweets = api.search('corona')

print( len(public_tweets) )

print( public_tweets[0].to_list() )

# for key , value in public_tweets[0].items():
#     print(key,value,'\n')