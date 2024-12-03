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

## Structure

### Modules
- Include Common, DetailModule, ListModule.

### Domain
- Include Entities, Protocols, UseCasesProtocols, UseCases

### Data
- Include CoreDataRepository, DataSource
