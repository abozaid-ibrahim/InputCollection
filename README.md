# DynamicCollection
</p>
 <p align="center">
<a href="https://developer.apple.com/swift/"><img src="https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat" alt="Swift"/></a>
<img src="https://img.shields.io/badge/Platform-iOS%2011.0+-lightgrey.svg" alt="Platform: iOS">
<img src="https://img.shields.io/badge/XCode-12.2%2B-lightgrey">
<img src="https://img.shields.io/badge/Code%20Coverage-89%25-brightgreen">
</p>

Collection view acts like xcel sheet to take any text input
 
 <p align="center">
 <img src="https://github.com/abuzeid-ibrahim/DynamicCollection/blob/master/demo.gif" width="50%">
 </p>

## Getting Started
- If this is your first time encountering swift/ios development, please follow [the instructions](https://developer.apple.com/support/xcode/) to set up Xcode and Swift on your Mac.

## Setup Configs
- Checkout master branch to run the latest version
- Open the project by double-clicking the `DynamicCollection.xcproject` file
- Select the build scheme which can be found right after the stop button on the top left of the IDE
- [Command(cmd)] + R - Run app
```
// App Settings
APP_NAME = DynamicCollection
PRODUCT_BUNDLE_IDENTIFIER = abozaid.DynamicCollection

#targets:
* DynamicCollection
* DynamicCollectionTests
* DynamicCollectionUITests

```

## Build
* Select the build scheme which can be found right after the stop button on the top left of the IDE
* [Command(cmd)] + B - Build app
* [Command(cmd)] + R - Run app

## Architecture
This application uses the Model-View-ViewModel (referred to as MVVM) UI architecture,

## Folders Structure
* SupportingFiles: Group app shared files, like app delegate, assets, info.plist, ...etc
* Components: Include separate component, could be used outside the project.
* Scene: input view.
* Extensions: Group of app extensions.
