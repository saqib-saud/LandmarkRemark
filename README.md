# Requirements

## Explicit Requirements
- [x] As a user (of the application) I can see my current location on a map
- [x] As a user I can save a short note at my current location
- [x] As a user I can see notes that I have saved at the location they were saved on the map
- [x] As a user I can see the location, text, and user-name of notes other users have saved
- [x] As a user I have the ability to search for a note based on contained text or user-name

## Implicit Requirements
Based on requirements listed above following requirements were deduced.
- [x] A user must be logged in to add remarks
- [x] A logged in user must be able to logout
- [x] Show error when something goes wrong
    - [ ] There should be an option to retry failed network requests.
- [ ] User session in the app should expire after certain time. 
- [ ] A user can view remarks while they are offline
- [ ] When there are many remarks on the same point, the app should create a cluster and show them appropriately. 
    
# Which Architecture?

When choosing architecture for your application there is no silver bullet. The choice of architecture depends on team expertise and time at hand. We will discuss the pros/cons of some popular architectures and I will further explain which architecture I prefer.

## Model-View-Controller 
MVC is the default out of the box architecture which Apple gives us. MVC is great when you are building small applications but it has its issues too

### Pros
- Fast delivery
- Adds basic level of abstraction, best suited for small apps.
### Cons
- Not scalable, creates "Massive View Controller" problem.
- Impossible to write unit tests.

## Model-View-ViewModel
MVVM adds more encapsulation on top of MVC

### Pros
- Mediocre complexity.
- Scalable.
- Easier to write unit tests. 
### Cons
- If not careful you can still end up creating Massive View Model.

### Clean Architecture/ VIPER
Clean Architecture idea was presented by Uncle Bob. It strictly follows single responsibility and uses boundary objects to pass data between different layers. While this idea is great for enterprise app it does not work well with small mobile teams because of extra layers.

### Pros
- Well defined boundaries, plug-n-play architecture
- Scalable

### Cons
- Small teams might see significant delays in delivery 

## My Choice
I prefer using MVVM for its mediocre complexity and quick delivery times. I like the ideas presented by Uncle Bob and like to use them along with MVVM

- Screaming Architecture. Without looking into the code, the folder structure should give you an idea about the app architecture.
- SOLID design principals.
- Using boundary objects to pass data between Data layer and Domain layer. Which keeps both layers decoupled and easily replaceable. For instance If we want to move away from Firebase to any new BaaS it should not impact our Domain or View Layer. This change should be isolated to Data layer.


## Error handling
Not expose data layer errors to  Presentation layer

## Bonus
- Use Header https://help.apple.com/xcode/mac/9.0/index.html?localePath=en.lproj#/dev91a7a31fc

add app flow diagram that shows flow in case of 
 - network error
 - location error


## Testing

Our view controllers are dumb, thus we can skip testing them. ViewControllers pass every action to the ViewModel and ViewModel decides what action it should take.

 - Why single storyboard used.
 - functional programming (using maps and other functions)
 - Wrapper around libraries 
 - Linting and Swift Formatting 
 - Annotation Clustering 
- The ViewController should also inherit from Protocol
- POP - Showing Activity Indicator
            - alerts (retry)
            
Unit Testing External Library
 - explain why skipping call was necessary
  - testing firebase is difficult because of private initialisers 

            
