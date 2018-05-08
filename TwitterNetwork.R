# Script for graphing Twitter Networks

# NEEDED GLOBAL STATEMENTS

# INSTALL
library("twitteR")
library("igraph")

# CHANGE
setup_twitter_oauth("consumer_key", "consumer_secret", "access_token", "access_secret") # https://apps.twitter.com/

# FUNCTIONS

# Returns atomic vector of following/follower users 
# for a given Twitter User object
getFriends <- function(user) {
    followers.object<-lookupUsers(user$getFollowerIDs())
    following.object<-lookupUsers(user$getFriendIDs())
    # Similar to a Map function in JS
    followers <- sapply(followers.object,screenName)
    following <- sapply(following.object,screenName)
    # combining then returning duplicate values (who you follow that follows you back)
    friends <- c(followers, following)
    return(friends[duplicated(friends)])
}

# returns a whole network for given friends (from and to a certain index)
getFriendsFriends <- function(friends, start, limit) {
    network <- data.frame(User=friends[start], Follower=getFriends(getUser(friends[start])))
    for (i in (start+1):(start+limit)) {
        network <- addFriendFrame(friends[i], network)
    }
    return(network)
}

# returns a whole network for given users array
getUsers <- function(custom) {
    network <- data.frame(User=custom[1], Follower=getFriends(getUser(custom[1])))
    for (i in 2:length(custom)) {
        str(custom[i])
        network <- addFriendFrame(custom[i], network)
    }
    return(network)
}

# add friend (given screenUser String) data frame retrived from Twitter to given network
addFriendFrame <- function(friend, network) {
    tempFriend <- getUser(friend)
    protected <- tempFriend$protected
    if (!protected) {
        network <- merge(network, 
        data.frame(User=tempFriend$screenName, Follower=getFriends(tempFriend)), 
        all=T)
    }
    return(network)
}

# returns a network with singlar nodes removed (only those with a connection to one user in the network)
# will be ran for n squared, meaning if users mapped in the network are connected with a total of 5000 people, this will itterate 25,000,000 times
filterNetwork <- function(network) {
    friendsVector <- unique(network[1])
    init <- FALSE
    View(network) 
    str(nrow(network))
    for (x in 1:nrow(network)) {
        for (y in 1:nrow(network)) {
            # If one user is being followed by another in main users network, or mutual (and not at the same index)
            # or the user being followed is one being mapped in the network
            if (y != x) {
                if (as.character(network[x,2]) == as.character(network[y,2]) |
                as.character(network[y,2]) %in% friendsVector) {
                    if (!init) { # if the filtered network has not been initiated
                        filteredNetwork <- data.frame(User=network[x,1], Follower=network[x,2])
                        init <- TRUE
                    } else {
                        filteredNetwork <- merge(filteredNetwork, 
                        data.frame(User=network[x,1], Follower=network[x,2]), 
                        all=T)
                    }
                }
            }
        }
    }
    return(filteredNetwork)
}

# START

#user <- getUser("Sean12697") # Turns string to User object
#friends <- getFriends(user) # custom function
#View(friends)
#network <- getFriendsFriends(friends, 1, 13)

# Replace with any users screen name, from 2 upto 13 (due to API call limits)
customList <- c("Sean12697","SteveHiltonCEO","ruby_gem","RebeccaWho","ThatGirlVim","Moses_Walsh","eskins")
View(customList)
network <- getUsers(customList)
View(network)

# filtering
filteredNetwork <- filterNetwork(network)
View(filteredNetwork)

# draw graph
g <- graph.data.frame(filteredNetwork, directed = T)
V(g)$label <- V(g)$name
tkplot(g)

# saves as a csv in the root folder where ran, which can be imported into Neo4J or other applications
write.csv(filteredNetwork, file = paste("fileName", ".csv", sep =""), row.names=FALSE)