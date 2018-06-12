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

final class SwiftArgsTests: XCTestCase {

	static var allTests = [
		("testNestedArguments", testNestedArguments),
		("testFlagOptions", testFlagOptions),
		("testErrorOutput", testErrorOutput),
		("testPrintUsage", testPrintUsage)
	]

	func testNestedArguments() {
		let type 		= EnumOption<TestEnumType>(name: "type", shortFlag: "t", longFlag: "type", usageMessage: "Sets the type")
		let privacy = EnumOption<TestPrivacyType>(name: "Privacy", longFlag: "privacy")
		let library	= CommandOption("library", withArguments: [type])
		let exec		= CommandOption("executable", withArguments: [type, privacy])

		let initOpt = CommandOption("init", withArguments: [library, exec])
		let verbose = BoolOption(name: "verbosity", shortFlag: "v", longFlag: "verbose")

		let args = SwiftArgs(arguments: [initOpt, verbose])

		do {
			try args.parse(["init", "library", "-t", "type1"])

			if let lib = initOpt.value as? CommandOption, let type = lib.value as? EnumOption<TestEnumType> {
				XCTAssertEqual(type.value, TestEnumType.type1, "Failed: init library -t type1")
			} else {
				XCTAssertTrue(false, "Failed: init library -t type1")
			}

			XCTAssertEqual(privacy.value, nil)

			try args.parse(["init", "executable", "--privacy", "public"])
			XCTAssertEqual(privacy.value, TestPrivacyType.publicType)

			if let executable = initOpt.value as? CommandOption, let privacy = executable.value as? EnumOption<TestPrivacyType> {
				XCTAssertEqual(privacy.value, TestPrivacyType.publicType, "Failed: init executable --privacy public")
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

			if let flags = command1.value as? EnumOption<TestLanguage> {
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
		} catch {
			XCTAssertTrue(false, "\(error)")
		}
	}

	func testErrorOutput() {
		let compose = CommandOption("compose")
		let privacy = EnumOption<TestPrivacyType>(name: "Privacy", longFlag: "privacy")
		let string 	= StringOption(name: "name", longFlag: "name")

		let args = SwiftArgs(arguments: [compose, privacy, string])

		func testInvalidArgument() throws { try args.parse(["--help"]) }
		func testInvalidCommand() throws { try args.parse(["compose", "foo"]) }
		func testInvalidValue() throws { try args.parse(["--privacy", "foo"]) }
		func testMissingValueEnum() throws { try args.parse(["--privacy"]) }
		func testMissingValueString() throws { try args.parse(["--name"]) }

		XCTAssertThrowsError(try testInvalidArgument()) { error in
			if let error = error as? SwiftArgsError, case .invalidArgument = error {
				XCTAssertEqual(error.description, "Invalid argument -- --help", "Failed: testInvalidArgument()")
			} else {
				XCTAssertTrue(false, "Failed: testInvalidArgument()")
			}
		}

		XCTAssertThrowsError(try testInvalidCommand()) { error in
			if let error = error as? SwiftArgsError, case .invalidCommand = error {
				XCTAssertEqual(error.description, "Invalid value 'foo' for compose", "Failed: testInvalidCommand()")
			} else {
				XCTAssertTrue(false, "Failed: testInvalidCommand()")
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
	}

	func testPrintUsage() {
		let help = BoolOption(name: "help", longFlag: "help", usageMessage: "Outputs usage information")
		let type = EnumOption<TestPrivacyType>(name: "type", longFlag: "type", usageMessage: "Sets the privacy level")

		let clone = CommandOption("clone", usageMessage: "Clone a repository into a new directory")
		let inits = CommandOption("init", usageMessage: "Create an empty Git repository or reinitialize an existing one")
		let add		= CommandOption("add", usageMessage: "Add file contents to the index")
		let move	= CommandOption("mv", usageMessage: "Move or rename a file, a directory, or a symlink")
		let reset = CommandOption("mv", usageMessage: "Reset current HEAD to the specified state")
		let remove = CommandOption("rm", usageMessage: "Remove files from the working tree and from the index")

		let args = SwiftArgs(arguments: [help, type, clone, inits, add, move, reset, remove])

		args.printUsage(debugMode: true)

		XCTAssertTrue(args.outputStream.contains("Usage:"))
		XCTAssertTrue(args.outputStream.contains("Commands:\n"))
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
	}

}
