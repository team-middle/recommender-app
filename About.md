The Kickammmender Project
The Kickammmender Project is an intelligent recommendation engine that suggests Kickstarter projects that a user might be interested in backing.

We forsee the number of crowdfunded projects and the community backing them to dramatically increase in the next couple of years. What we see now is only the baby steps of a shift to a world that is a more connected community, where if you have an interesting and innovative idea and the skills to make it happen, then you can find the resources to build it. 

The problem with this explosive growth in the field is that it will become increasingly difficult to find the projects that interest you. Say there are a million projects that are currently active. How do you find the one you find the most intrigueing to you? The one that matches your interests?

We thought about how to tackle this problem. Would you want to give recommendations based on what your friends backed? This is a pretty easy thing to implement but I dont think it works very well. Just because I may have a bunch of friends on facebook that liked fifty shades of grey does not mean that I am interested in that kind of thing. I definitely dont want to get book recommendations based on my friends liking that book. 

Our approach was more complicated but gives much better and more personalized recommendations. Imagine a dining hall with 100 prolific kickstarter backers. We look at the interests of each of the backers and arrange people with similar interests to sit at the same table. When a new user logs in to the site we look at his interests and give him a seat at a table where the people have interests similar to him. At the table the user gets assigned to, the user learns about the new projects people with similar interests have backed.

The first question you may ask is how we classify a persons interests. We look at the categories of all of the projects the person has backed and give them scores based on that. For example if Alex backed 6 Art projects, another 3 projects that had to do with Theater, 2 Comics, 2 Design and 1 Film then we normalize these scores and give him a 100 in Art, 50 Theater, 33 in Comics and Design and 17 in Film. 


