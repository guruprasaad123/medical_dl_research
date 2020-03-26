# Step 1 - Authenticate
consumer_key= 'dNPO3EUKQLJSpofg5vm8oE1Mu'
consumer_secret= 'C24oe6690gN8SqZiZ5XlsdNnltR5EV0M0HDffhXZh2o3xUPTju'

access_token='962657191-V1xd2y575O7uuTfDCZrKqg3GP1grdvsfIRRanHVt'
access_token_secret='NFwbNchfMB3cWgxVRV5b8a5IKtkJFcqTxKUZR8DS8XisX'


from twitter import Api

api = Api(consumer_key=consumer_key,
                  consumer_secret=consumer_secret,
                  access_token_key=access_token,
                  access_token_secret=access_token_secret)

results = api.GetSearch( raw_query="q=twitter%20&result_type=recent&since=2014-07-19&count=100" )

print(type(results))
print(type(results[0]))
for key , value in results[0].items() :
    print(key , value )