import React , {Component} from 'react';
import axios from 'axios';
import InfiniteScroll from 'react-infinite-scroller';
import TweetComponent from './TweetComponent';

function useTweets()
{
    return 
}

class ListView extends Component {

    constructor(props)
    {
        super(props);
        this.state = {};
    }

    componentDidMount(props)
    {
        this.loadTweets();
    }

    loadTweets = ()=>
    {
        axios.get('http://ec2-13-232-219-139.ap-south-1.compute.amazonaws.com:4000/api/corono/0/9999').then((object)=>{
              
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

    loadMore = ()=>
    {
        const searchMeta = this.state.searchMeta ;
        axios.get(`http://ec2-13-232-219-139.ap-south-1.compute.amazonaws.com:4000/api/corono/1/${searchMeta.max_id}`).then((object)=>{
            const response = object.data.response ;
            console.log('response => ',response.length);
            if( response.length > 0 )
            {
                this.setState({ 
                    tweets : [
                        ...this.state.tweets ,
                        ...response.tweets
                    ],
                    
                    searchMeta : response.search_metadata });
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
            <div style={ { height : '700px' , overflow: 'auto'}}>
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