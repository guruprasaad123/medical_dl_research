import React , {Component} from 'react';
import axios from 'axios';
import InfiniteScroll from 'react-infinite-scroller';
import TweetComponent from './TweetComponent';
const { api_url =  'http://ec2-13-232-219-139.ap-south-1.compute.amazonaws.com' , port=4000 } = process.env;
function useTweets()
{
    return 
}

class ListView extends Component {

    constructor(props)
    {
        super(props);
        this.state = {};
        console.log('host : ', process.env )
    }

    componentDidMount(props)
    {
        this.loadTweets();
    }

    loadTweets = ()=>
    {
        axios.get(`${api_url}:${port}/api/corona/0/9999`).then((object)=>{
              
        const response = object.data.response ;
        console.log('response => ',  response.length ); 
            if( response.length > 0 )
            {
                this.setState({ tweets : response.tweets , searchMeta : response.search_metadata });
            }
            
        }).catch((error)=>{
            console.log('Error => ',error);
            console.log('Message => ',error.message);
        })
    }

    scrollTop = ()=>{
        const doc = document.getElementById('scrollBar');
        doc.scrollTop = 0;
      }

    loadMore = ()=>
    {
        const searchMeta = this.state.searchMeta ;
        axios.get(`${api_url}:${port}/api/corona/1/${searchMeta.max_id}`).then((object)=>{
            const response = object.data.response ;
            console.log('response => ',response.length);
            if( response.length > 0 )
            {
                this.setState({ 
                    tweets : 
                        [
                        ...response.tweets,
                        ...this.state.tweets 
                    ],
                    
                    searchMeta : response.search_metadata } , ()=>{
                        this.scrollTop();
                    });
            }
        }).catch((error)=>{
            console.log('Error => ',error);
            console.log('Message => ',error.message);
        })
    }

    render()
    {
        const tweets = this.state.tweets ;

        return (
            <div id="scrollBar" style={ { height : '700px' , overflow: 'auto'}}>
              {  (tweets && Array.isArray(tweets) )? 
             <InfiniteScroll
                    pageStart={0}
                    loadMore={this.loadMore}
                    hasMore={true || false}
                    loader={<div className="loader" key={0}>Loading ...</div>}
                    useWindow={false}
                >
                    {tweets.map( (object,index)=>{
                        return (
                            <TweetComponent 
                            key={index}
                            value={object}
                            tweetText={object.text}
                            user={object.user}
                            creation={object.created_at}
                            lang={object.lang}
                            sentiment={object.sentiment}
                            >        
                            </TweetComponent>
                        )
                    })}
                </InfiniteScroll>
            : <noscript/> 
            }
               
            </div>
        );
    }
}

export default ListView;