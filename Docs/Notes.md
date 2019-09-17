Notes
-----


------
## Code Guidlines/Convencions

* All is private (variable, funtions, etc), unless really need to be public
* If a varibale is private, ALLWAYS start by _underscore_ 
* The function where where set RxSuff will allways be named  ```rxSetup```
* The funtion where we setup the View layout will allways be namre ```prepareLayout```
* UIKit names
    * All UIButtons start by _btn_, example : _btnLogin_, _btnRegister_
    * All UILabel start by _lbl_. Example _llbName_, _lblPassword_
    * All UITableViews start by _table_ or _tbl_. Example : _tableUsers_, _tblFriends_
    * All UITextViews and UITextFields starts by _txt_. Example : _txtPassword_, _txtUserName_
    * Thumb rule : The name of the var, should be clear about the type associated. 
    
------
## Code Samples


------
## RxNotes

```
sdasda
```

## Misc Notes


### Swift

####  Check Versions 

```
xcrun swift -version
xcode-select --print-path
```


####  Check Versions : Change Compiler version (for xcodebuild)

```
sudo xcode-select --switch "/Applications/Xcode_10.1.app/Contents/Developer"
sudo xcode-select --switch "/Applications/Xcode.app/Contents/Developer"
```

### Git

####  Check commits

```
git log --oneline --decorate
```

### Tags

```
git tag -a ProductName_VersionX.X.X_BuildX_01Jan2030 -m "ProductName-VersionX.X.X-BuildX-01Jan2030"
git push --tags

```
