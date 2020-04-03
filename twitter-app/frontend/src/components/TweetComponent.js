import React , { Component } from "react"
import styled from 'styled-components';

import CssBaseline from '@material-ui/core/CssBaseline';
import Typography from '@material-ui/core/Typography';
import Container from '@material-ui/core/Container';

import PropTypes from 'prop-types';
import { makeStyles } from '@material-ui/core/styles';
import Card from '@material-ui/core/Card';
import CardHeader from '@material-ui/core/CardHeader';
import CardContent from '@material-ui/core/CardContent';
import CardMedia from '@material-ui/core/CardMedia';
import Avatar from '@material-ui/core/Avatar';
import IconButton from '@material-ui/core/IconButton';
import MoreVertIcon from '@material-ui/icons/MoreVert';
import Skeleton from '@material-ui/lab/Skeleton';

const useStyles = makeStyles((theme) => ({
    card: {
      maxWidth: 345,
      margin: theme.spacing(2),
    },
    media: {
      height: 190,
    },
  }));

class TweetComponent extends Component
{
    constructor(props)
    {
        super(props);
        this.state={};
    }

    render()
    {

        const { 
            loading = false ,
            value = {} ,
            tweetText="No Twitter Text Available",
            user={},
            creation 
        } = this.props;
        const time = new Date() - new Date(creation);
        console.log('date : ',new Date(creation))
        console.log('Time : ',time);
        // const classes = useStyles();

       return (

        <React.Fragment>
        <Card >
            <CardHeader
                avatar={
                loading ? (
                    <Skeleton animation="wave" variant="circle" width={40} height={40} />
                ) : (
                    <Avatar
                    alt="Avatar"
                    src={user.profile_image_url_https}
                    />
                )
                }
                action={
                loading ? null : (
                    <IconButton aria-label="settings">
                    <MoreVertIcon />
                    </IconButton>
                )
                }
                title={
                loading ? (
                    <Skeleton animation="wave" height={10} width="80%" style={{ marginBottom: 6 }} />
                ) : (
                    user.name
                )
                }
                subheader={loading ? <Skeleton animation="wave" height={10} width="40%" /> : '5 hours ago'}
            />
            {/* {loading ? (
                <Skeleton animation="wave" variant="rect" className={classes.media} />
            ) : (
                <CardMedia
                className={classes.media}
                image="https://pi.tedcdn.com/r/talkstar-photos.s3.amazonaws.com/uploads/72bda89f-9bbf-4685-910a-2f151c4f3a8a/NicolaSturgeon_2019T-embed.jpg?w=512"
                title="Ted talk"
                />
            )} */}

            <CardContent>
                {loading ? (
                <React.Fragment>
                    <Skeleton animation="wave" height={10} style={{ marginBottom: 6 }} />
                    <Skeleton animation="wave" height={10} width="80%" />
                </React.Fragment>
                ) : (
                <Typography variant="body2" color="textSecondary" component="p">
                    {
               tweetText
                    }
                </Typography>
                )}
            </CardContent>
    </Card>
      </React.Fragment>

       )
    }
}

export default TweetComponent;