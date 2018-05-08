# R Twitter Network

Running this script will allow you to produce graph such as the one below for any given Twitter Users, mapping their connections into a network.

![](https://pbs.twimg.com/media/DctdfMvXcAARp_v.jpg:large)

A connection in this context means when a follower of a given user, is also being followed back by that user, then they are only shown in the graphed network, if another given user is connected with that person.

## Usage

First step will be installing the required packages in R, which can be done via running the following two lines in your R console (selecting a download server for both and letting them download/install):

```
install.packages("twitteR")
install.packages("igraph")
```

Once this is done, you will want create an [Twitter App](http://apps.twitter.com/) signing in with any account to gain a pair of customer keys and access tokens, once done find this line of code and replace with your new keys (ensuring you paste all of the strings and do not leave spaces)

```
setup_twitter_oauth("consumer_key", "consumer_secret", "access_token", "access_secret")
```

Once changed you can then start graphing the network for any given Twitter users, although trying to use more than 13 users can result in an error message warning that you have reached the API call limit (for approximately half an hour to an hour), the 7 used in the initial graph have been left to be changed.

```
customList <- c("Sean12697","SteveHiltonCEO","ruby_gem","RebeccaWho","ThatGirlVim","Moses_Walsh","eskins")
```

Also at the end is a "write.csv" line, which is used to create a csv file produced of the filtered network (ensure you change the name from the default "fileName" to another, to prevent overwrites), which can be used to import into another application like Neo4J.

```
write.csv(filteredNetwork, file = paste("fileName", ".csv", sep =""), row.names=FALSE)
```

## Recommendation

The graph will load in a small window, to fix this change the size of it or make it full screen, then go into the layout option in the menu and select any graphing method, I find Kamada-Kawai is best 70% of the time, then 25% of the time Fruchterman-Reingold.

Also going into the select option in the menu, selecting all vertices, then right clicking on the graph, will allow you to change their colour from black to another (white is recommended).
