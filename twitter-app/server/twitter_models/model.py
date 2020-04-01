# settings.py
from dotenv import load_dotenv
import os
from pathlib import Path  # python3 only

env_path = Path('.') / '.env'
load_dotenv(dotenv_path=env_path)

consumer_key = os.getenv("consumer_key")
consumer_secret = os.getenv("consumer_secret")
access_token = os.getenv("access_token")
access_token_secret = os.getenv("access_token_secret")

from twitter import Api

class twitter_api():

    def __init__(self):
        self.api = Api(consumer_key=consumer_key,
          consumer_secret=consumer_secret,
          access_token_key=access_token,
          access_token_secret=access_token_secret)
    
    def search_tweets(self,  q='corona' , max_id=None , count=10, result_type="recent" ):

        results = self.api.GetSearch( 
                        raw_query="q=%s&count=%d&include_entities=1&result_type=%s"%(q , count , result_type) ,
                        max_id = max_id ,
                        return_json=True 
                        )

        length = len(results['statuses'] )

        statuses = results['statuses']

        return {
            'tweets' : statuses ,
            'length' : length,
            'search_metadata' : results['search_metadata']
        }

