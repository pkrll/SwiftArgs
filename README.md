[![Build Status](https://travis-ci.org/pkrll/SwiftArgs.svg?branch=master)](https://travis-ci.org/pkrll/SwiftArgs)
[![codecov](https://codecov.io/gh/pkrll/SwiftArgs/branch/master/graph/badge.svg)](https://codecov.io/gh/pkrll/SwiftArgs)
[![sonar](https://sonarcloud.io/api/project_badges/measure?project=SwiftArgs&metric=alert_status)](https://sonarcloud.io/dashboard?id=SwiftArgs)
[![Pod version](https://badge.fury.io/co/SwiftArgs.svg)](https://cocoapods.org/pods/SwiftArgs)
![release](https://img.shields.io/github/release/pkrll/Swiftargs.svg)

<img src=".assets/SwiftArgs.png" data-canonical-src=".assets/SwiftArgs.png" align="right" width="250px"/>

**SwiftArgs** is a small Swift framework for creating simple command line interfaces.

* [Installation](#installation)
	* [Swift Package Manager](#swift-package-manager)
	* [CocoaPods](#cocoapods)
* [Usage](#usage)
	* [CommandOption](#commandoption)
	* [BoolOption](#booloption)
	* [StringOption](#stringoption)
	* [EnumOption](#enumoption)
	* [Example](#example)
* [Acknowledgements](#acknowledgements)

## Installation

You can install ``SwiftArgs`` with the Swift Package Manager or Cocoapods.

##### Swift Package Manager

Add ``SwiftArgs`` as a dependency in ``Package.swift``:

```swift
// Package.swift

dependencies: [
    .package(url: "https://github.com/pkrll/SwiftArgs", from: "0.5.0")
]

```

##### CocoaPods

Add ``SwiftArgs`` to your Podfile:

```ruby
pod 'SwiftArgs', '~> 0.5'
```

## Usage

SwiftArgs offers four different kinds of argument types: ``CommandOption``, ``BoolOption``, ``StringOption`` and ``EnumOption``.

Supply these to the ``SwiftArgs`` object, and run the ``parse()`` method to validate and parse the command line arguments (see below for an [example](#example)).

##### CommandOption
A ``CommandOption``represents a command, which can accept sub arguments on its own:

```bash
$ my_app init
$ my_app init --bare
$ my_app package init --type library
```

##### BoolOption
``BoolOption`` represents a boolean flag:

```bash
$ my_app --help
```

##### StringOption
A ``StringOption`` represents an option that can take an arbitrary value:

```bash
$ my_app --set-path /some/path
```

##### EnumOption
An ``EnumOption<T>`` represents an option that only accepts predefined values:

```bash
$ my_app --type library
```



#### Example

```swift
import Foundation
import SwiftArgs

enum BuildType: String {
	case debug
	case release
}

let help = BoolOption(
	name: "help",
	shortFlag: "h",
	longFlag: "help",
	description: "Display available options"
)

let version = BoolOption(
	name: "version",
	shortFlag: "v",
	longFlag: "version",
	description: "Display version information"
)

let buildType = EnumOption<BuildType>(
	name: "BuildType",
	shortFlag: "t",
	longFlag: "type",
	description: "Specify the build configuration: debug|release",
	isRequired: true
)

let clean = CommandOption("clean", description: "Clean up any build artifacts")
let build = CommandOption("build", withArguments: [help, buildType], description: "Build the project")
let test = CommandOption("test", withArguments: [help, buildType], description: "Test the project")
let run = CommandOption("run", withArguments: [help, buildType], description: "Execute the project")

let args = SwiftArgs(arguments: [help, version, clean, build, test, run])

do {
	try args.parse() // or try args.parse(["build", "--type", "debug"])
} catch {
	args.printError(error)
	args.printUsage()
	exit(1)
}

/**
* 	Check if the BoolOption help (-h, --help) or version
* 	(-v --version) was specified with the value property.
*/
if help.value! {
	var argument: Argument? = nil

	if build.value { argument = build }
	if test.value { argument = test }
	if run.value { argument = run }

	args.printUsage(argument)
} else if version.value! {
	print("SwiftArgsDemo v1.0")
} else {
	/**
	* 	You can directly access the EnumOption's value property
	* 	to check its value (nil if not used)...
	*/
	if buildType.value == BuildType.debug {
		print("Build type: Debug!")
	} else if buildType.value == BuildType.release {
		print("Build type: Release!")
	}
	/**
	* 	... or to check which command it's associated with, use
	* 	optional chaining to unwrap the nested arguments.
	*/
	if let bType = build.argument as? EnumOption<BuildType>, let value = bType.value {
		switch value {
		case BuildType.debug:
			print("Build type: Debug!")
		case BuildType.release:
			print("Build type: Release!")
		}
	}

	if build.value {
		print("Commence building...")
	}
}
```

## Acknowledgements

This framework is, in its API, heavily inspired by the [CommandLineKit](https://github.com/jatoben/CommandLine) framework.

## Author

SwiftArgs was created by *Ardalan Samimi*.
