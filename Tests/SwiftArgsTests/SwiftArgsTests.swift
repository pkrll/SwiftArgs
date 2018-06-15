import XCTest
import SwiftArgs

private enum TestEnumType: String {
	case type1
	case type2
	case type3
}

private enum TestPrivacyType: String {
	case privateType = "private"
	case publicType = "public"
}

private enum TestLanguage: String {
	case cLang = "c"
	case python
}

private enum TestBuildType: String {
	case debug
	case release
}

final class SwiftArgsTests: XCTestCase {

	static var allTests = [
		("testNestedArguments", testNestedArguments),
		("testFlagOptions", testFlagOptions),
		("testErrorOutput", testErrorOutput),
		("testPrintUsage", testPrintUsage),
		("testRequiredArguments", testRequiredArguments),
		("testChainCommands", testChainCommands),
		("testAfterCommands", testAfterCommands),
	]

	func testNestedArguments() {
		let type 		= EnumOption<TestEnumType>(name: "type", shortFlag: "t", longFlag: "type", description: "Sets the type")
		let privacy = EnumOption<TestPrivacyType>(name: "Privacy", longFlag: "privacy")
		let library	= CommandOption("library", withArguments: [type, privacy])
		let initOpt = CommandOption("init", withArguments: [library])
		let verbose = BoolOption(name: "verbosity", shortFlag: "v", longFlag: "verbose")

		let args = SwiftArgs(arguments: [initOpt, verbose])

		do {

			try args.parse(["init", "library", "-t", "type1"])

			if let lib = initOpt.argument as? CommandOption, let type = lib.argument as? EnumOption<TestEnumType> {
				XCTAssertEqual(type.value, TestEnumType.type1, "Failed: init library -t type1")
			} else {
				XCTAssertTrue(false, "Failed: init library -t type1")
			}

			XCTAssertEqual(privacy.value, nil)

			try args.parse(["init", "library", "--privacy", "public"])

			XCTAssertEqual(privacy.value, TestPrivacyType.publicType)

			if let lib = initOpt.argument as? CommandOption, let privacy = lib.arguments[1] as? EnumOption<TestPrivacyType> {
				XCTAssertEqual(privacy.value, TestPrivacyType.publicType, "Failed: init library --privacy public")
			} else {
				XCTAssertTrue(false, "Failed: init executable --privacy public")
			}

		} catch {
			XCTAssertTrue(false, "Failed: \(error)")
		}
	}

	func testFlagOptions() {
		let languages = EnumOption<TestLanguage>(name: "Language", shortFlag: "l", longFlag: "lang")
		let type 			= EnumOption<TestEnumType>(name: "type", shortFlag: "t", longFlag: "type")
		let privacy 	= EnumOption<TestPrivacyType>(name: "Privacy", longFlag: "privacy")
		let stringOpt = StringOption(name: "string", shortFlag: "s")

		let someBool = BoolOption(name: "bool", longFlag: "bool")
		let command1 = CommandOption("command1", withArguments: [languages, privacy])
		let command2 = CommandOption("command2", withArguments: [type, privacy, stringOpt])

		let args = SwiftArgs(arguments: [someBool, command1, command2])

		do {
			try args.parse(["command1", "--lang", "python"])

			if let flags = command1.argument as? EnumOption<TestLanguage> {
				XCTAssertEqual(flags.value, TestLanguage.python, "Failed: command1 --lang python")
			} else {
				XCTAssertTrue(false, "Failed: command1 --lang python")
			}

			XCTAssertEqual(type.value, nil)

			try args.parse(["command2", "--privacy", "private", "-t", "type3"])
			XCTAssertEqual(type.value, TestEnumType.type3, "Failed: command2 --privacy private -t type3")
			XCTAssertEqual(privacy.value, TestPrivacyType.privateType, "Failed: command2 --privacy private -t type3")

			try args.parse(["command2", "--privacy", "public"])
			XCTAssertEqual(privacy.value, TestPrivacyType.publicType, "Failed: command2 --privacy public")

			XCTAssertFalse(someBool.value!)
			try args.parse(["--bool", "command2"])
			XCTAssertTrue(someBool.value!, "Failed: -bool command2")

			try args.parse(["command2", "-s", "foobar"])
			XCTAssertEqual(stringOpt.value, "foobar", "Failed: command2 -s foobar")

			try args.parse(["command1"])
			XCTAssertTrue(command1.value)
		} catch {
			XCTAssertTrue(false, "\(error)")
		}
	}

	func testErrorOutput() {
		let type		= EnumOption<TestBuildType>(name: "type", longFlag: "type", isRequired: true)
		let privacy = EnumOption<TestPrivacyType>(name: "Privacy", longFlag: "privacy")
		let version	= BoolOption(name: "version", longFlag: "version", isRequired: true)
		let quiet		= BoolOption(name: "quiet", longFlag: "quiet")
		let string 	= StringOption(name: "name", longFlag: "name")
		let compose = CommandOption("compose", withArguments: [string, type])
		let args = SwiftArgs(arguments: [compose, privacy, string])

		func testInvalidArgument() throws { try args.parse(["--help"]) }
		func testInvalidValue() throws { try args.parse(["--privacy", "foo"]) }
		func testMissingValueEnum() throws { try args.parse(["--privacy"]) }
		func testMissingValueString() throws { try args.parse(["--name"]) }
		func testMissingRequiredArgument1() throws { try args.parse(["compose"]) }
		func testMissingRequiredArgument2() throws {
			try SwiftArgs(arguments: [version, quiet]).parse(["--quiet"])
		}

		XCTAssertThrowsError(try testInvalidArgument()) { error in
			if let error = error as? SwiftArgsError, case .invalidArgument = error {
				XCTAssertEqual(error.description, "Invalid argument -- --help", "Failed: testInvalidArgument()")
			} else {
				XCTAssertTrue(false, "Failed: testInvalidArgument()")
			}
		}

		XCTAssertThrowsError(try testInvalidValue()) { error in
			if let error = error as? SwiftArgsError, case .invalidValue = error {
				XCTAssertEqual(error.description, "Invalid value 'foo' for --privacy", "Failed: testInvalidValue()")
			} else {
				XCTAssertTrue(false, "Failed: testInvalidValue()")
			}
		}

		XCTAssertThrowsError(try testMissingValueEnum()) { error in
			if let error = error as? SwiftArgsError, case .missingValue = error {
				XCTAssertEqual(error.description, "--privacy requires a value", "Failed: testMissingValueEnum()")
			} else {
				XCTAssertTrue(false, "Failed: testMissingValueEnum()")
			}
		}

		XCTAssertThrowsError(try testMissingValueString()) { error in
			if let error = error as? SwiftArgsError, case .missingValue = error {
				XCTAssertEqual(error.description, "--name requires a value", "Failed: testMissingValueString()")
			} else {
				XCTAssertTrue(false, "Failed: testMissingValueString()")
			}
		}

		XCTAssertThrowsError(try testMissingRequiredArgument1()) { error in
			if let error = error as? SwiftArgsError, case .missingRequiredArgument = error {
				XCTAssertEqual(error.description, "Missing required arguments: --type", "Failed: testMissingRequiredArgument()")
			} else {
				XCTAssertTrue(false, "Failed: testMissingRequiredArgument1()")
			}
		}

		XCTAssertThrowsError(try testMissingRequiredArgument2()) { error in
			if let error = error as? SwiftArgsError, case .missingRequiredArgument = error {
				XCTAssertEqual(error.description, "Missing required arguments: --version", "Failed: testMissingRequiredArgument2()")
			} else {
				XCTAssertTrue(false, "Failed: testMissingRequiredArgument2()")
			}
		}
	}

	func testPrintUsage() {
		let help = BoolOption(name: "help", shortFlag: "h", longFlag: "help", description: "Outputs usage information")
		let type = EnumOption<TestPrivacyType>(name: "type", longFlag: "type", description: "Sets the privacy level")

		let clone = CommandOption("clone", description: "Clone a repository into a new directory")
		let inits = CommandOption("init", withArguments: [type], description: "Create an empty Git repository or reinitialize an existing one")
		let add		= CommandOption("add", description: "Add file contents to the index")
		let move	= CommandOption("mv", description: "Move or rename a file, a directory, or a symlink")
		let reset = CommandOption("mv", description: "Reset current HEAD to the specified state")
		let remove = CommandOption("rm", description: "Remove files from the working tree and from the index")

		let args = SwiftArgs(arguments: [help, type, clone, inits, add, move, reset, remove])

		args.printUsage(debugMode: true)

		XCTAssertTrue(args.outputStream.contains("Usage:"))
		XCTAssertTrue(args.outputStream.contains("Commands:"))
		XCTAssertTrue(args.outputStream.contains("clone"))
		XCTAssertTrue(args.outputStream.contains("init"))
		XCTAssertTrue(args.outputStream.contains("add"))
		XCTAssertTrue(args.outputStream.contains("mv"))
		XCTAssertTrue(args.outputStream.contains("mv"))
		XCTAssertTrue(args.outputStream.contains("rm"))
		XCTAssertTrue(args.outputStream.contains("Clone a repository into a new directory"))
		XCTAssertTrue(args.outputStream.contains("Create an empty Git repository or reinitialize an existing one"))
		XCTAssertTrue(args.outputStream.contains("Add file contents to the index"))
		XCTAssertTrue(args.outputStream.contains("Move or rename a file, a directory, or a symlink"))
		XCTAssertTrue(args.outputStream.contains("Reset current HEAD to the specified state"))
		XCTAssertTrue(args.outputStream.contains("Remove files from the working tree and from the index"))

		args.printUsage(inits, debugMode: true)

		XCTAssertTrue(args.outputStream.contains("Usage:"))
		XCTAssertFalse(args.outputStream.contains("Commands:"))
		XCTAssertTrue(args.outputStream.contains("Options:"))
		XCTAssertTrue(args.outputStream.contains("--type"))
		XCTAssertTrue(args.outputStream.contains("Sets the privacy level"))
	}

	func testRequiredArguments() {
		let help = BoolOption(
			name: "help",
			shortFlag: "h",
			longFlag: "help",
			description: "Outputs usage information")

		let type = EnumOption<TestPrivacyType>(
			name: "type",
			longFlag: "type",
			description: "Sets the privacy level",
			isRequired: true)

		let inits = CommandOption("init", withArguments: [help, type], isRequired: true)
		let add		= CommandOption("add")

		let args = SwiftArgs(arguments: [inits, add])

		do {
			try args.parse([])
			XCTAssertTrue(false, "Failed: Missing required argument not missing")
		} catch let actualError as SwiftArgsError {
			let expectedError = SwiftArgsError.missingRequiredArgument("init").description
			XCTAssertEqual(actualError.description, expectedError)
		} catch {
			XCTAssertTrue(false, "Failed: \(error)")
		}

		do {
			try args.parse(["init"])
			XCTAssertTrue(false, "Failed: Missing required argument not missing")
		} catch let actualError as SwiftArgsError {
			let expectedError = SwiftArgsError.missingRequiredArgument("--type").description
			XCTAssertEqual(actualError.description, expectedError)
		} catch {
			XCTAssertTrue(false, "Failed: \(error)")
		}

		do {
			try args.parse(["init", "--type", "public"])
			XCTAssertTrue(true)
		} catch {
			XCTAssertTrue(false, "Failed: \(error)")
		}

		do {
			try args.parse(["add"])
			XCTAssertTrue(true)
		} catch {
			XCTAssertTrue(false, "Failed: \(error)")
		}
	}

	func testChainCommands() {
		let lang = EnumOption<TestLanguage>(name: "language", longFlag: "lang", isRequired: true)
		let build = CommandOption("build")
		let run		= CommandOption("run", withArguments: [lang])
		let clean = CommandOption("clean")

		let args = SwiftArgs(arguments: [clean, build, run])

		do {
			try args.parse(["clean", "build"])
			XCTAssertTrue(true)
		} catch {
			XCTAssertTrue(false)
		}

		do {
			try args.parse(["run", "build"])
			XCTAssertTrue(false)
		} catch {
			XCTAssertTrue(true)
		}
	}

	func testAfterCommands() {
		let lang = EnumOption<TestLanguage>(name: "language", longFlag: "lang")
		let type = EnumOption<TestBuildType>(name: "type", longFlag: "type")
		let build = CommandOption("build", withArguments: [type])

		let args = SwiftArgs(arguments: [build, lang])

		do {
			try args.parse(["build", "--lang", "c"])
			XCTAssertTrue(true)
		} catch {
			print(error)
			XCTAssertTrue(false)
		}

	}

}
