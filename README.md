[![Build Status](https://travis-ci.org/pkrll/SwiftArgs.svg?branch=master)](https://travis-ci.org/pkrll/SwiftArgs)
[![codecov](https://codecov.io/gh/pkrll/SwiftArgs/branch/master/graph/badge.svg)](https://codecov.io/gh/pkrll/SwiftArgs)
<img src="https://sonarcloud.io/api/project_badges/measure?project=SwiftArgs&metric=alert_status" alt="sonar" data-canonical-src="https://sonarcloud.io/api/project_badges/measure?project=SwiftArgs&metric=alert_status">
[![cocoapod](https://img.shields.io/cocoapods/v/Swiftargs.svg)](https://cocoapods.org/pods/SwiftArgs)
![release](https://img.shields.io/github/tag/pkrll/Swiftargs.svg)
![commits since latest release](https://img.shields.io/github/commits-since/pkrll/Swiftargs/0.3.2.svg)

<img src=".assets/SwiftArgs.png" data-canonical-src=".assets/SwiftArgs.png" align="right" width="250px"/>

**SwiftArgs** is a small Swift framework for creating simple command line interfaces.

* [Installation](#installation)
	* [Swift Package Manager](#swift-package-manager)
* [Usage](#usage)
	* [CommandOption](#commandoption)
	* [BoolOption](#booloption)
	* [StringOption](#stringoption)
	* [EnumOption](#enumoption)
	* [Example](#example)
* [Acknowledgements](#acknowledgements)

## Installation

**SwiftArgs** is currently only available using Swift Package Manager.

##### Swift Package Manager

Add SwiftArgs as a dependency in ``Package.swift``:

```swift
// Package.swift

dependencies: [
    .package(url: "https://github.com/pkrll/SwiftArgs", from: "0.1.0")
]

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
import SwiftArgs

enum BuildType: String {
	case Debug = "debug"
	case Release = "release"
}

let help = BoolOption(name: "help", shortFlag: "h", longFlag: "help", usageMessage: "Display available options")
let version = BoolOption(name: "version", shortFlag: "v", longFlag: "version", usageMessage: "Display version information")

let buildType = EnumOption<BuildType>(name: "BuildType", shortFlag: "t", longFlag: "type", usageMessage: "Specify the build configuration: debug|release")

let clean = CommandOption("clean", usageMessage: "Clean up any build artifacts")
let build = CommandOption("build", withArguments: [buildType], usageMessage: "Build the project")
let test = CommandOption("test", withArguments: [buildType], usageMessage: "Test the project")
let run = CommandOption("run", withArguments: [buildType], usageMessage: "Execute the project")

let args = SwiftArgs(arguments: [help, version, clean, build, test, run])

do {
	try args.parse()
} catch {
	args.printError(error)
	args.printUsage()
}

/**
 * 	Check if the BoolOption help (-h, --help) or version
 * 	(-v --version) was specified with the value property.
 */
if help.value! {
	args.printUsage()
} else if version.value! {
	print("SwiftArgsDemo v1.0")
} else {
	/**
	 * 	You can directly access the EnumOption's value property
	 * 	to check its value (nil if not used)...
	 */
	if buildType.value == BuildType.Debug {
		print("Build type: Debug!")
	} else if buildType.value == BuildType.Release {
		print("Build type: Release!")
	}
	/**
	 * 	... or to check which command it's associated with, use
	 * 	optional chaining to unwrap the nested arguments.
	 */
	if let bType = build.value as? EnumOption<BuildType>, let value = bType.value {
		switch value {
			case BuildType.Debug:
				print("Build type: Debug!")
			case BuildType.Release:
				print("Build type: Release!")
		}
	}
}
```

## Acknowledgements

This framework is, in its API, heavily inspired by the [CommandLineKit](https://github.com/jatoben/CommandLine) framework.

## Author

SwiftArgs was created by *Ardalan Samimi*.
