#The Kickammmender Project
The Kickammmender Project is an intelligent recommendation engine that suggests Kickstarter projects that a user might be interested in backing.

### Why a Recommendation Engine is needed
We forsee the number of crowdfunded projects and the community backing them to dramatically increase in the next couple of years. What we see now is only the baby steps of a shift to a world that is a more connected community, where if you have an interesting and innovative idea and the skills to make it happen, then you can find the resources to build it. 

The problem with this explosive growth in the field is that it will become increasingly difficult to find the projects that interest you. Say there are a million projects that are currently active. How do you find the one you find the most intrigueing to you? The one that matches your interests?

### Trivial Recommendation Engines
We thought about how to tackle this problem. Would you want to give recommendations based on what your friends backed? This is a pretty easy thing to implement but I dont think it works very well. Just because I may have a bunch of friends on facebook that liked fifty shades of grey does not mean that I am interested in that kind of thing. I definitely dont want to get book recommendations based on my friends liking that book. 

### Our Approach
Our approach was more complicated but gives much better and more personalized recommendations. Imagine a dining hall with 100 prolific kickstarter backers. We look at the interests of each of the backers and arrange people with similar interests to sit at the same table. When a new user logs in to the site we look at his interests and give him a seat at a table where the people have interests similar to him. At the table the user gets assigned to, the user learns about the new projects people with similar interests have backed.

### Giving a user a score
The first question you may ask is how we classify a persons interests. We look at the categories of all of the projects the person has backed and give them scores based on that. For example if Alex backed 6 Art projects, another 3 projects that had to do with Theater, 2 Comics, 2 Design and 1 Film then we normalize these scores and give him a 100 in Art, 50 Theater, 33 in Comics and Design and 17 in Film. What happens when we have a new user that hasnt backed any kickstarter projects? We look at his facebook likes and map the facebook likes categories to the kickstarter categories. Say Albert hasn't backed any kickstarter projects but he has liked 6 Artists pages on facebook, 3 theaters, 2 comic books, 2 design pages and 1 movie then he would be given the same score as Alex. 

### Grouping people with similar interests
The next step is to group people with similar interests into groups or clusters. We do this by using a Machine Learning algorithm called K Means Clustering. This takes in data points and the number of groups we want and it outputs centers of the groups and the member of each group. 
We specify the number of clusters we want and the algorithm will separate the points or in this case the users into different clusters. This visual shows how 2 dimensional datapoints are separated into 4 clusters. [http://shabal.in/visuals/kmeans/2.html](K Means Clustering gif). This shows how the algorithm works in 2 dimensions. You can imagine the axiis being how much a person likes art and the other being Technology. Kickstarter however has 13 categories. We wrote the algorithm to work in 13 dimensions. Harder to visualize but same kind of principle. 

### K-Means++
One of the things we notice from this gif is that the clusters that are created are different depending on what seed values we start with. We implemented some additional logic which is called K-Means++ which was proposed in 2007 as a way to choose seed points that will let the K-Means algorithm choose better clusters. 


We went onto kickstarter and scraped data from 5,000 users that had backed numerous projects. We saw which projects they had backed and the categories of these projects. With this information we had 5,000 data points. A rule of thumb in data science is that a good number of clusters, K = sqrt(n/2). This is from [http://en.wikipedia.org/wiki/Determining_the_number_of_clusters_in_a_data_set#cite_note-1](wikipedia). This evaluates to 50 clusters. To make an intelligent selection about the 50 seeds we need, we run the K-Means++ algorithm. The machine learning algorithm is then run and we obtain 50 groups that contain kickstarter users with similar interests. When we get a new user to our app, we look at their facebook likes and map these likes to the 13 broad kickstarter categories. We then calculate the distance of the users score to each of the cluster centers. We select the nearest cluster to the user and assign that user to that group. To give a user a recommendation, we look at the active projects that other people in the users cluster have backed. We rank these in order of how many people in the certain cluster have backed it and provide it to the user. 

### Getting User Feedback
We want to make these recommendations very personal to the user. As time goes by and the user uses the site more and more, we want our engine to adapt to the users needs. For each recommendation we give, we look at if the user liked it or not. When a user liked a project that is in the food category, we change his score to represent this. It would be the similar to if he liked a food on facebook. The next time he logs onto the site, he may be closer to another cluster that is more Food friendly. 

