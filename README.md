# *Stop Tweeting! for iOS*

**Stop Tweeting!** is a basic twitter app to read and compose tweets using the [Twitter API](https://apps.twitter.com/).

By: Pedro Sandoval Segura

## Video Walkthrough

Here's a quick video of the app:
https://www.youtube.com/watch?v=Iy48EgaS_x0

## User Stories - Upgrades being worked on
- Links in tweets should be clickable
- Pulling down the profile page should blur and resize the header image.

## User Stories - Current Functionality
- User can sign in using OAuth login flow
- The current signed in user will be persisted across restarts
- User can view last 20 tweets from their home timeline
- In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- User can pull to refresh.
- User should display the relative timestamp for each tweet "8m", "7h"
- Retweeting and favoriting should increment the retweet and favorite count.
- User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- User can compose a new tweet by tapping on a compose button.
- User can tap the profile image in any tweet to see another user's profile
   - Contains the user header view: picture and tagline
   - Contains a section with the users basic stats: # tweets, # following, # followers
   - Profile view should include that user's timeline
- User can navigate to view their own profile
   - Contains the user header view: picture and tagline
   - Contains a section with the users basic stats: # tweets, # following, # followers
- User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- When composing, you should have a countdown in the upper right for the tweet limit.
- After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- User can reply to any tweet, and replies should be prefixed with the username and the reply_id should be set when posting the tweet
- User can switch between timeline, mentions (messages instead), or profile view through a tab bar
- Tweet cells reflect whether a tweet has already been favorited or retweeted in Twitter
- Refresh control has a timestamp of the last time that a tweet was loaded
- Replies to tweets are displayed in the home feed immediately, without an API call

## Credits

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

    Copyright 2017 Pedro Sandoval Segura

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
