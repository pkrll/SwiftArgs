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
