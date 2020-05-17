# iOS Architecture design patterns : MVP/VIP + Clean + Rx

- [x] 📱  iOS 11.0+
- [x] 🔨  XCode 11.1, Swift 5.1

The intent of this project is to show a simple implementation of the __MVP Clean (Rx)__ pattern. This is my vision about it, and if you dont agree with someting, just email me, I love to hear opinions and learn from that.


# Install

Just download source code and run  `./_script_installPackages.sh`

# Features

- [x] Localisable ressources
- [x] [RJPSLib](https://github.com/ricardopsantos/RJPSLib) to manage logs, caching, network client, generic extensions...
- [x] Sample App - GitUser (search users on GitHub)
- [x] RxSwift & RxCocoa sample examples
- [x] [.xcconfig](https://nshipster.com/xcconfig/) usage
- [x] Cache (on Network API) usage
- [x] Code style analyser with [Swiftlint](https://github.com/realm/SwiftLint)
- [x] Dependency injection with [Swinject](https://github.com/Swinject/Swinject)
- [x] Command line [script](https://github.com/ricardopsantos/RJPS_MVPCleanRx/blob/master/_iOSGenericCompile.sh) for app build 
 
 More info about the project and MVP architecture [here](https://github.com/ricardopsantos/RJPS_MVPCleanRx/tree/master/Docs)
 

# Code Guidelines/Conventions

* All is private (variable, functions, etc), unless really need to be public
* If a variable is private, __ALLWAYS__ start by _underscore_ 
* The function where where set RxSuff will always be named  `rxSetup`
* The function where we setup the View layout will allways be named `prepareLayout´
* UIKit names
    * All UIButtons start by _btn_, example : _btnLogin_, _btnRegister_
    * All UILabel start by _lbl_. Example _llbName_, _lblPassword_
    * All UITableViews start by _table_ or _tbl_. Example : _tableUsers_, _tblFriends_
    * All UITextViews and UITextFields starts by _txt_. Example : _txtPassword_, _txtUserName_
    * Thumb rule : The name of the var, should be clear about the type associated. 
    
# WIKI

[https://github.com/ricardopsantos/RJPS_Docs](https://github.com/ricardopsantos/RJPS_Docs)

# Test deeplinks 

** Test deeplinks **

xcrun simctl openurl booted "myappdeeplink://questions?question_filter=FILTER"
xcrun simctl openurl booted "myappdeeplink://questions?question_id=QUESTION_ID"
xcrun simctl openurl booted "myappdeeplink://questions?question_id=1"


#  Xcode tips

* [⌥] -> Options 
* [⌘] -> Command
* [⇧] -> Shift
* [alt] -> Alt

----

* Indent code
    * Control + I
    
* Open quicky
    * ⌘ + ⇧ + O
    
* Clean Project
    * ⌘ + ⇧ + K
    * ⌘ + K

* Xcode Code Sniptes
    * ⌘ + ⇧ + L


# License

[Unlicense](http://unlicense.org)

What is the Unlicensed?
The Unlicense is a template for disclaiming copyright monopoly interest in software you've written; in other words, it is a template for dedicating your software to the public domain. It combines a copyright waiver patterned after the very successful public domain SQLite project with the no-warranty statement from the widely-used MIT/X11 license.
