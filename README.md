[![Build Status](https://travis-ci.org/pkrll/SwiftArgs.svg?branch=master)](https://travis-ci.org/pkrll/SwiftArgs)
[![codecov](https://codecov.io/gh/pkrll/SwiftArgs/branch/master/graph/badge.svg)](https://codecov.io/gh/pkrll/SwiftArgs)
[![cocoapod](https://img.shields.io/cocoapods/v/Swiftargs.svg)](https://cocoapods.org/pods/SwiftArgs)
# SwiftArgs

**SwiftArgs** is a small command line argument parser for Swift.

## Installation

Add SwiftArgs as a dependency in ``Package.swift``:

#### Swift Package Manager

```swift
// Package.swift

dependencies: [
    .package(url: "https://github.com/pkrll/SwiftArgs", from: "0.1.0")
]

```

## Usage

```swift
import SwiftArgs

enum Language: String {
	case C = "c"
	case Python = "python"
}

let help = SwitchOption(name: "--help")

let languagesFlags = FlagOption<Language>(name: "Language", shortFlag: "l", longFlag: "language")
let libraryCommand = CommandOption("library", withArguments: [languagesFlags])
let executableCmnd = CommandOption("executable", withArguments: [languagesFlags])

let compose = CommandOption("compose", withArguments: [executableCmnd, libraryCommand])

let args = SwiftArgs(arguments: [compose, help])

do {
	try args.parse()
} catch {
	args.printError(error)
}

// Access the values of the arguments:

if let flags = libraryCommand.value as? FlagOption<Language> {
	print("Chosen language for library: \(flags.value!.rawValue)")
}

if help.value {
	// ... print help
}

```
