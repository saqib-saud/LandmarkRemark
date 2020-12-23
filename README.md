# Requirements

## Explicit Requirements
- [x] As a user (of the application) I can see my current location on a map
- [x] As a user I can save a short note at my current location
- [x] As a user I can see notes that I have saved at the location they were saved on the map
- [x] As a user I can see the location, text, and user-name of notes other users have saved
- [x] As a user I have the ability to search for a note based on contained text or user-name

## Implicit Requirements
Based on requirements listed above following requirements were deduced.
- [x] Prompt user to share location
- [x] A user must be logged in to add remarks
- [x] Username and Password validation 
- [x] A logged in user must be able to logout
- [x] Case insensitive search
- [x] Custom Loading indicator when making asynchronous requests. 
- [x] Show error when something goes wrong
    - [x] Errors should be descriptive 
    - [ ] There should be an option to retry failed network requests.
- [ ] Handle scenario if location access is not granted by user. Disable `Add` Remark button if location sharing is disabled
- [ ] User session in the app should expire after certain time. 
- [ ] A user can view remarks while they are offline
- [ ] When there are many remarks on the same point, the app should create a cluster and show them appropriately. 
- [x] When Location sharing is disabled show appropriate prompt to user. 
- [x] Linting and Swift Formatting 
    
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
MVVM adds more encapsulation on top of MVC. Each View has a dedicated ViewModel that handles all the updates to View. View and View Model can be binded using reactive frameworks such as RxSwift but I choose to use protocols. The View does not contain any logic, thus we avoid testing it.

### Pros
- Mediocre complexity.
- Scalable.
- Easier to write unit tests. 
### Cons
- If not careful you can still end up creating Massive View Model.

### Clean Architecture/ VIPER
Clean Architecture idea was presented by Uncle Bob. It strictly follows single responsibility and uses boundary objects to pass data between different layers. While this idea is great for enterprise app it does not work well with small mobile teams because of extra layers. In my experience mobile apps should be thin clients and major processing should be done on server side.

you can read more about it [here](https://www.objc.io/issues/13-architecture/viper/)

### Pros
- Well defined boundaries, plug-n-play architecture
- Scalable
- Easier to write tests.

### Cons
- Small teams might see significant delays in delivery because of overhead of extra layers.

## My Choice
I prefer to apply Clean Architecture ideas to MVVM. I've used SOLID design principals to make app testable [further reading](https://blog.cleancoder.com/uncle-bob/2020/10/18/Solid-Relevance.html)

Utmost care has been taken that each layer follows Law of Demeter. Without this law we might end up accidentally coupling layers.

### Screaming Architecture
<img width="277" alt="folder structure" src="https://user-images.githubusercontent.com/400207/102848193-5186ac00-4468-11eb-8d64-f07631752b2c.png">

You don't have dive deep into the code to understand the architecture of the app. The folder structure gives you enough hints to understand the architecture. [further reading](https://blog.cleancoder.com/uncle-bob/2011/09/30/Screaming-Architecture.html)

![layer diagram](https://user-images.githubusercontent.com/400207/102849601-97913f00-446b-11eb-823b-3c1ce535a861.png)

#### Presentation Layer
Presentation layer contain UIKit, MapKit and Location manager references. It is tightly coupled with UIKit. All the iOS native frameworks are present in this later

#### Domain Layer
The domain layer is meant to be Abstract, General purpose and platform independent. It does not contain any reference to firebase or UIKit. If we decide to replace presentation layer (i.e. Replace UIKit with SwiftUI) it wont have any impact of Domain later. 

We use boundary objects to pass data between layers. Which keeps them decoupled and easily replaceable. For instance If we want to move away from Firebase to any new BaaS it should not impact our Domain or View Layer. This change should be isolated to Data layer.

#### Data Layer
The data layer contain Firebase and FireStore references. It is tightly coupled with 3rd party libraries.

## Features
### Protocol Oriented Programming
Alerts and Loading screen in app are being displayed using POP. We can use protocol to test BDD for 3rd party libraries. 

### Functional Programming 
Used `map` function where appropriate to transform data. Avoided RxSwift to keep app simple. 

### Generics 
Using Generics to instantiate UIViewControllers from storyboards.

```
func instantiateViewController<T: UIViewController>() -> T
```
### Custom UI

Created UI using Interface Builder and programmatically (e.g. `LoadingView`). `LoadingView` Can be further improved using IBDesignable to customise in Interface Builder.

### Error handling
Each layer encapsulates its errors and only exposes subset of errors to consumer layer. For the end user there are only 2 types of errors:
- Failed Errors (i.e. No internet error)
- Retry-able Errors (i.e. Bad internet connection) 

### Behaviour Driven Unit Testing 
BDD techniques are used for unit testing. Had limited success covering 3rd party libraries such and Firebase and FireStore. Some Firebase classes have private constructors, which becomes problematic while mocking it.

**Unit test coverage: 39.6%** (It also includes view controllers)

The ViewControllers are dumb and thus not being Unit Tested. 

#### BDD 3rd Party Libraries
To complete end-to-end unit testing, we need to mock 3rd party libraries. Often its not an easy task because It not necessary that 3rd party library might implement a protocol. We tested Firebase Authentication by declaring a protocol and then implementing it using an extension.  However this approach did not work very well for FireStore testing because of some API restrictions. Some of the constructors in Firebase were private for public, thus we could not create instances of them.

```
protocol FIRAuthProvider {
    func signIn(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?)
}

extension Auth: FIRAuthProvider {}
```

## Bonus
- Using single line file header [further reading](https://help.apple.com/xcode/mac/9.0/index.html?localePath=en.lproj#/dev91a7a31fc)
