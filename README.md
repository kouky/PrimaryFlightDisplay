# PrimaryFlightDisplay

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/PrimaryFlightDisplay.svg?style=flat-square)](https://cocoapods.org/pods/PrimaryFlightDisplay)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/PrimaryFlightDisplay.svg?style=flat-square)](http://cocoadocs.org/docsets/PrimaryFlightDisplay)
[![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/kouky/MavlinkPrimaryFlightDisplay/blob/master/LICENSE)


PrimaryFlightDisplay is a Mac + iOS framework for use in ground control station and telemetry systems for [micro UAVs](https://en.wikipedia.org/wiki/Miniature_UAV) (unmanned aerial vehicles).

The framework enables convenient embedding and animation of a primary flight display. Styles and colors are easily tuned whilst maintaining crisp graphics for any screen resolution.

![Screenshot](http://kouky.org/assets/primary-flight-display/default-screenshot.png)

## Features

- [x] Artificial horizon
- [x] Pitch ladder
- [x] Bank indicator
- [x] Heading tape indicator
- [x] Airspeed / Groundspeed tape indicator
- [x] Altitude tape indicator
- [x] Crisp procedurally generated graphics
- [x] Highly configurable colors, sizes, and tape indicator scales
- [x] No library dependenices other than Apple's SpriteKit
- [x] Flight stack and protocol agnostic
- [x] Compatible with MAVLink

## Requirements

- iOS 9.0+ / Mac OS X 10.10+
- Xcode 9.3+

## Installation

Build and install the framework using Cocoapods or Carthage.

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build PrimaryFlightDisplay

To integrate PrimaryFlightDisplay into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'PrimaryFlightDisplay'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate PrimaryFlightDisplay into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "kouky/PrimaryFlightDisplay"
```

Run `carthage update` to build the framework and drag the built `PrimaryFlightDisplay.framework` into your Xcode project.

## Usage

Construct a new `PrimaryFlightDisplayView` with default styles, and add it to your view hierarchy.


```swift
let flightView = PrimaryFlightDisplayView(frame: frame)
flightView.autoresizingMask = [.ViewHeightSizable, .ViewWidthSizable]
addSubview(flightView)
```

Send flight data to the primary flight display using the following API methods. The new flight data values will be animated immediately.

```swift
    flightView.setAttitude(rollRadians: Double(1), pitchRadians: Double(1.5))
    flightView.setHeadingDegree(Double(300))
    flightView.setAirSpeed(Double(20))
    flightView.setAltitude(Double(165))
```

### Custom Styles

The styles for the default primary flight display are easily tuned, see [Settings.swift](https://github.com/kouky/PrimaryFlightDisplay/blob/master/Sources/Settings.swift) for all tuneable styles.

[See the blog post](http://kouky.org/blog/2016/03/20/primary-flight-display-mavlink-ios-mac.html) and example project [MavlinkPrimaryFlightDisplay](https://github.com/kouky/MavlinkPrimaryFlightDisplay) which demonstrate how to create the primary flight display in the screenshot below.

![Screenshot](http://kouky.org/assets/primary-flight-display/alternative-screenshot.png)

## Example Project

[MavlinkPrimaryFlightDisplay](https://github.com/kouky/MavlinkPrimaryFlightDisplay) is a Mac app which demonstrates how to integrate the PrimaryFlightDisplay framework for a [MAVLink](http://qgroundcontrol.org/mavlink/start) speaking autopilot. Clone the repo and follow the `README` to get the app running and connect to your autopilot.

## Contributing

Pull requests are welcome on the `master` branch.
