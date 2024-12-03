# 3D file converter application
Swift Assessment Test 

## Building And Running The Project (Requirements)
* Swift 5.0+
* UIKit
* Xcode 16.1+
* iOS 17.4+
* MacOS Sequoia 15.0

# Getting Started
- If this is your first time encountering swift/ios development, please follow [the instructions](https://developer.apple.com/support/xcode/) to setup Xcode and Swift on your Mac.


## Setup Configs
- Checkout master branch to run latest version
- Open the project by double clicking the `Shapr3D.xcodeproj` file
- Select the build scheme which can be found right after the stop button on the top left of the IDE
- [Command(cmd)] + R - Run app
```
// App Settings
APP_NAME = Shapr3D
PRODUCT_BUNDLE_IDENTIFIER = asd.asd.Shapr3d

#targets:
* Shapr3D
 * ListModuleTest
 * DetailModuleTest
```


# Build and or run application by doing:
* Select the build scheme which can be found right after the stop button on the top left of the IDE
* [Command(cmd)] + B - Build app
* [Command(cmd)] + R - Run app


## Accomplished:
- Interface Modularization.
- Composite Root technique.
- SOLID principle.
- DI Container.
- MVVM Architecture.
- SwiftData.
- Unit Tests.

Without any implementation of third party libraries.

## Architecture
This application uses the MVVM UI architecture with modular approach using DI Container.

<p align="center"> <img src="https://miro.medium.com/v2/resize:fit:1400/1*saKX3Dssawi-Z4zT0mNRmQ.png" width="600" height="300">

<img src="https://miro.medium.com/v2/resize:fit:1400/1*lR0AqgxKy5H7bFFQbYQeeA.png" width="600" height="300">
</p>

## Structure

### Modules
- Include Common, DetailModule, ListModule.

### Domain
- Include Entities, Protocols, UseCasesProtocols, UseCases

### Data
- Include CoreDataRepository, DataSource

### Navigator Panel
<p align="center"> 
<img src="https://github.com/user-attachments/assets/df56c829-da49-465a-8f94-9de58cccb329" width="350" height="500">
</p>

### Graph View

<p align="center"> 
<img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmo0oI5yIKJkk4M8nlseHz1xltdcg7VS4Msg&s" width="250" height="250">
</p>

## Performance States
Memory usage:

<p align="center"> 
<img src="https://github.com/user-attachments/assets/10f647d1-24dd-4bc6-9f89-8023dcb33698" width="700" height="300">
</p>

## Multiple devices support => Screen shots:

### iPhone 16 Pro Max
<p align="center"> 
<img src="https://github.com/user-attachments/assets/c29a2807-f5a4-44c0-a8d3-d7fa4f26ed54" width="250" height="500">

<img src="https://github.com/user-attachments/assets/99e6d40c-7ee2-4cde-a7a4-612fae538304" width="250" height="500">

<img src="https://github.com/user-attachments/assets/0af4330d-7988-4cc5-8d0c-ddd529744c78" width="250" height="500">
</p>

### iPad Pro 13 inch (M4)
<p align="center"> 
<img src="https://github.com/user-attachments/assets/72ced661-1f9f-41e2-9571-040774677e57" width="350" height="560">

<img src="https://github.com/user-attachments/assets/d7cf9c44-d8ab-42fa-b633-76eabfecd93d" width="350" height="560">
</p>
