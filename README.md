# Index

## References and notes : MVP Clean

* References
* [A dumb UI is a good UI: Using MVP in iOS with swift](http://iyadagha.com/using-mvp-ios-swift/)

* Project Rules
* The _View_ part of the MVP consists of both _UIViews_ and _UIViewController_
* The _View_ delegates user interactions to the _Presenter_
* The _Presenter_ contains the logic to handle user interactions
* The _Presenter_ communicates with model layer, converts the data to UI friendly format, and updates the _View_
* The _Presenter_ has no dependencies to UIKit
* The _View_ is passive (dumb)

* _Repository_ are called from _UseCases_

## References/articles

* [Introduction to Protocol-Oriented MVVM](https://realm.io/news/doios-natasha-murashev-protocol-oriented-mvvm/)
* [Blending Cultures: The Best of Functional, Protocol-Oriented, and Object-Oriented Programming](https://realm.io/news/tryswift-daniel-steinberg-blending-cultures/)
* [iOS Architecture Patterns : Demystifying MVC, MVP, MVVM and VIPER](https://medium.com/ios-os-x-development/ios-architecture-patterns-ecba4c38de52)


* AppDomain
- CONTAINS PROTOCOLS ONLY

* Core
- Implementations
- Mapers : Convert one Entetie into another

* Repositories
- ALLWAYS NEED A CLIENT TO DO STUFF (get things)
- It's the way (a container) to fetch data somewhere (networking, storage, bluetooth)
- Are called from UseCases
- Are not implemented in Core. They stay in Repository folder
