# settings.py
from dotenv import load_dotenv
import os
from pathlib import Path  # python3 only

env_path = Path('.') / '.env'
load_dotenv(dotenv_path=env_path)

import json

consumer_key = os.getenv("consumer_key")
consumer_secret = os.getenv("consumer_secret")
access_token = os.getenv("access_token")
access_token_secret = os.getenv("access_token_secret")

from twitter import Api

from googletrans import Translator
from textblob import TextBlob

class twitter_api():

    def __init__(self):
        self.api = Api(consumer_key=consumer_key,
          consumer_secret=consumer_secret,
          access_token_key=access_token,
          access_token_secret=access_token_secret)
        self.translator = Translator()

    def translate(self , statuses ):

        tweets = []

        for status in statuses:
            
            if status['lang'] =='en':
                                    
                blob = TextBlob( status['text'] )
                    
                status['sentiment'] = {
                    'polarity' : blob.sentiment.polarity,
                    'subjectivity' : blob.sentiment.subjectivity
                    }
                
                print('sentiment => ',blob.sentiment)

                tweets.append(status)
            else:

                print('status => language ', status['lang']  )
                try :

                    # An attempt to translate using 'googletrans'

                    # success = self.translator.translate( status['text'] , src=status['lang'] , dest='en')
                    # print('success => ',success)
                    # status['text'] = success.text
                    
                    blob = TextBlob( status['text'] )
                    
                    status['sentiment'] = {
                        'polarity' : blob.sentiment.polarity,
                        'subjectivity' : blob.sentiment.subjectivity
                    }
                    
                    print('sentiment => ',blob.sentiment)
                    
                    text = blob.translate(to='en')
                    print('text =>' ,text , type(text))
                    status['text'] = str(text)

                    tweets.append(status)

                except Exception as Error :
                    print('error : ',Error)

            
            # tweets.append(status)

        return tweets 

    
    def search_tweets(self,  q='corona' , geocode=(), max_id=None , count=10, result_type="recent" ):

        results = self.api.GetSearch( 
                        raw_query="q=%s&count=%d&include_entities=1&result_type=%s"%(q , count , result_type) ,
                        max_id = max_id ,
                        geocode= geocode ,
                        return_json=True 
                        )

        length = len(results['statuses'] )

        statuses = results['statuses']

        statuses = self.translate(statuses)

        return {
            'tweets' : statuses ,
            'length' : length,
            'search_metadata' : results['search_metadata']
        }

