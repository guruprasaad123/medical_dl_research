from flask import Flask, render_template, send_from_directory, request, redirect, jsonify, url_for, flash
import json
from flask_cors import CORS
from twitter_models.model import twitter_api

twitterApi = twitter_api()
# initializing a flask app
app = Flask(__name__)
# app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0
CORS(app)


@app.route('/api/<string:search>/<int:next_pg>/<int:max_id>',methods=['GET'])
def api( search , next_pg  , max_id ):
    """Returns the tweets based on user's search

        If the argument `sound` isn't passed in, the default Animal
        sound is used.

        Parameters
        ----------
        search : str
            String that you want to twitter_api searches

        next_pg : int
            1 , 0

        max_id : int
            For navigating to next_pg page , tweets

        Raises
        ------
        NotImplementedError
            If no sound is set for the animal or passed in as a
            parameter.
        """
    print(search , next_pg , max_id )
    if request.method == 'GET' :
        
        if next_pg == 0 :
            obj = twitterApi.search_tweets(search)
            print('query => ',obj['length'])

            return json.dumps({'response' : obj }) , 200

        elif next_pg == 1 and max_id :
            obj = twitterApi.search_tweets(search , max_id )
            print('query => ',obj['length'])
            
            return json.dumps({ 'response' : obj}) , 200
        
        else:
            return json.dumps({'error':True}) , 401

if __name__ == '__main__':
  app.secret_key = 'super_secret_key'
  app.debug = True
  app.use_reloader=False
  app.run(host='0.0.0.0', port=4000)
  app.run()