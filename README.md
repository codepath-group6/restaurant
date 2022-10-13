Group Milestone - README
===

# Fud
 
## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Suggests restaurants one after another to an individual. User can swipe to save restaurant into a list. (can include more prob) 

### App Evaluation
- **Category:** Lifestyle 
- **Mobile:** Like Yelp, it will have the user's location and take in real time data about surrounding restaurants. (if we want it to work like Yelp and have information like closing / opening data displayed). For now, it'll only run from a mobile device. 
- **Story:** The fascinating thing about Fud is that it is a hybrid mobile app, bringing the best features of both Yelp and Tinder, allowing users to quickly scan, add and swipe suggested restaurants. This app is perfect for our friends and peers who have short attention spans and dislike scrolling through dozens of restaurants at once. 
- **Market:** Dining out and spending outdoor time (which none of us CS gals do..jk pls remove me) will always be part of the world. Fud provides quick, targeted suggestions for people who don't want to spend hours deciding on what to eat. 
- **Habit:** Fud's tinder-like swipe feature in addition to the personalized list of liked restaurants ensures that users will not only satisfy user's needs, but it will also aim to let users enjoy being given one choice at a time. Users will consume Fud to make quick choices for them but also give users the opportunity to explore restaurants in an addicting fashion.
- **Scope:** The complete app that includes displaying restaurant suggestions, enabling the swipe feature, and including the restaurant into a personalized list might be a challenge to finish all by the end of the program. However, the stripped down version that includes displaying personalized individual restaurants to the user using geolocation will be the goal. If done, it will undoubtedly give us a broader view of what types of mobile apps we are capable of creating. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User location accessed to get nearby restaurant information from Yelp api
* Suggested restaurants displayed to the user one-by-one, with name, image, yelp stars, relative cost, cuisine-type, and distance from location
* User swipes left to dismiss a restaurant and right to like/favorite a restaurant
* Detailed view for each restaurant
* Settings

**Optional Nice-to-have Stories**

* Page of liked/favorited restaurants
* User picks preferences (cuisine-type, cost range, maximum distance, etc...)
* Log of previously visited restaurants
* Display directions from user location to restaurant (step-by-step and/or map)

### 2. Screen Archetypes

* Home Screen
   * One click button to initiate restaurant discovery
   * If returning to the app, the view below it displays past restaurants that a user swiped right on
   * Restaurants can be removed and the whole list cleared 
   * Clicking a restaurant enters detailed view
* Restaurant Explorer
   * User location is obtained and a randomized restaurant is presented for users to swipe left or right
   * Button to return to the main screen once finished 
* Restaurant Detail View
   * Expands on restaurant details with images and contact information
   * View with map that can be clicked to redirect to user's preferred map app to get directions
* Settings 
   * Filters to further refine types of restaurants shown in Explorer
   

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* [fill out your first tab]
* [fill out your second tab]
* [fill out your third tab]

**Flow Navigation** (Screen to Screen)

* [list first screen here]
   * [list screen navigation here]
   * ...
* [list second screen here]
   * [list screen navigation here]
   * ...

## Wireframes
<img src="images/wireframe.png" width=500px>

### Digital Wireframes & Mockups
<img src="images/digitalwireframe.png" width=600px>

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
