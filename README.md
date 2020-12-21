#  ReadMe!

todo: Add null value check on note
# Requirements

## Explicit Requirements
## Implicit Requirements
    - Login
    - Logout
    - Error handling and retry on failure
    
## Further improvements
    - Offline Support
    - Session Management
    - Annotation Clustering
    
# Which Architecture?

When choosing architecture for your application there is no silver bullet. The choice of architecture depends on team expertise and time at hand.

## Model-View-Controller 
MVC is the default out of the box architecture which Apple gives us. MVC is great when you are building small applications but it has its issues too

### Pros
- Fast delivery
### Cons
- Not scalable, creates "Massive View Controller" problem

## Model-View-ViewModel
MVVM adds more encapsulation on top of MVC

### Pros
- Mediocre complexity
- Scalable 
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

            
