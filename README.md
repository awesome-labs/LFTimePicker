# LFTimePicker
> Custom Time Picker ViewController with Selection of start and end times in Swift :large_orange_diamond:. Based on Adey Salyard's [design @ Dribbble](https://dribbble.com/shots/1780596-Time-Picker)

[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/LFTimePicker.svg)](https://img.shields.io/cocoapods/v/LFTimePicker.svg)  
[![Platform](https://img.shields.io/cocoapods/p/LFTimePicker.svg?style=flat)](http://cocoapods.org/pods/LFTimePicker)

One to two paragraph statement about your product and what it does.

![ezgif com-resize](https://cloud.githubusercontent.com/assets/6511079/15739765/6f8cd774-2866-11e6-9913-2bdd9f9176c4.gif)

## Features

- [x] 12h and 24h formats

## Requirements

- iOS 8.0+
- Xcode 7.3

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `YourLibrary` by adding it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!
pod 'LFTimePicker'
```

To get the full benefits import `LFTimePicker` wherever you import UIKit

``` swift
import UIKit
import LFTimePicker
```

#### Carthage
Create a `Cartfile` that lists the framework and run `carthage bootstrap`. Follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios) to add `$(SRCROOT)/Carthage/Build/iOS/YourLibrary.framework` to an iOS project.

```
github "awesome-labs/LFTimePicker"
```

#### Swift Package Manager
Add this project on your `Package.swift`

```swift
import PackageDescription

let package = Package(
  name: "LFTimePicker"
)
```

#### Manually
1. Download and drop ```LFTimePickerController.swift``` in your project.  
2. Congratulations!  

## Usage example

```swift

//1. Create a LFTimePickerController
let timePicker = LFTimePickerController()

//2. Present the timePicker
self.navigationController?.pushViewController(timePicker, animated: true)

//3. Implement the LFTimePickerControllerDelegate
extension ExampleViewController: LFTimePickerControllerDelegate {

	func didPickTime(start: String, end: String) {

		print(start)
		print(end)
	}
}
```

## Contribute

We would love for you to contribute to **LFTimePicker**, check the ``LICENSE`` file for more info.

## Meta

Lucas Farah – [@7farah7](https://twitter.com/7farah7) – contact@lucasfarah.me

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/awesome-labs](https://github.com/awesome-labs/)

[swift-image]:https://img.shields.io/badge/swift-3.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
