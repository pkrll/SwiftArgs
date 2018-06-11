import XCTest
import SwiftArgs

enum View: String {
	case All = "all"
	case Some = "some"
	case None = "none"
}

enum PrivacyLevel: String {
	case Private = "private"
	case Public = "public"
}

final class SwiftArgsTests: XCTestCase {

	static var allTests = [
		("testSwiftArgs", testSwiftArgs),
		("testSwiftArgs2", testSwiftArgs2),
		("testSwiftArgsError", testSwiftArgsError),
		("testSwiftArgsPrintUsage", testSwiftArgsPrintUsage),
	]

	func testSwiftArgs() {
		let clean 	= SwitchOption(name: "clean")
		let view 		= FlagOption<View>(name: "View", shortFlag: "v", longFlag: "view")
		let privacy = FlagOption<PrivacyLevel>(name: "Privacy", longFlag: "privacy")
		let library = SwitchOption(name: "library")
		let folder 	= CommandOption("folder", withArguments: [privacy])
		let initOpt	= CommandOption("init", withArguments: [folder, library])

		let args = SwiftArgs(arguments: [clean, view, initOpt])

		do {
			try args.parse(["clean"])
			XCTAssertTrue(clean.value)

			try args.parse(["init", "library"])
			XCTAssertTrue(library.value)

			try args.parse(["init", "folder", "--privacy", "public"])

			if let privacy = folder.value as? FlagOption<PrivacyLevel> {
				XCTAssertEqual(privacy.value, PrivacyLevel.Public)
			} else {
				XCTAssertTrue(false)
			}

		} catch {
			XCTAssertTrue(false, "\(error)")
		}
	}

	func testSwiftArgs2() {
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
			try args.parse(["compose", "library", "-l", "c"])
			if let flags = libraryCommand.value as? FlagOption<Language> {
				XCTAssertEqual(flags.value, Language.C)
			}
		} catch {
			print(error)
		}
	}

	func testSwiftArgsError() {
		enum Flags: String {
			case Bar = "bar"
		}

		let compose = CommandOption("compose", withArguments: [])
		let flags = FlagOption<Flags>(name: "flags", longFlag: "type")

		let args = SwiftArgs(arguments: [compose, flags])

		func testInvalidArgument() throws { try args.parse(["--help"]) }
		func testInvalidCommand() throws { try args.parse(["compose", "foo"]) }
		func testInvalidValue() throws { try args.parse(["--type", "foo"]) }
		func testMissingValue() throws { try args.parse(["--type"]) }

		XCTAssertThrowsError(try testInvalidArgument()) { error in
			let error = error as! SwiftArgsError

			switch error {
				case .invalidArgument:
					XCTAssertTrue(true)
					XCTAssertEqual(error.description, "Invalid argument -- --help")
				default: XCTAssertTrue(false)
			}
		}

		XCTAssertThrowsError(try testInvalidCommand()) { error in
			let error = error as! SwiftArgsError

			switch error {
				case .invalidCommand:
					XCTAssertTrue(true)
					XCTAssertEqual(error.description, "Invalid value 'foo' for compose")
				default: XCTAssertTrue(false)
			}
		}

		XCTAssertThrowsError(try testInvalidValue()) { error in
			let error = error as! SwiftArgsError

			switch error {
				case .invalidValue:
					XCTAssertTrue(true)
					XCTAssertEqual(error.description, "Invalid value 'foo' for --type")
				default:
					XCTAssertTrue(false)
			}
		}

		XCTAssertThrowsError(try testMissingValue()) { error in
			let error = error as! SwiftArgsError

			switch error {
				case .missingValue:
					XCTAssertTrue(true)
					XCTAssertEqual(error.description, "--type requires a value")
				default:
					XCTAssertTrue(false)
			}
		}

	}

	func testSwiftArgsPrintUsage() {
		let help = SwitchOption(name: "--help", usageMessage: "Outputs usage information")
		let type = FlagOption<PrivacyLevel>(name: "type", shortFlag: "t", longFlag: "type", usageMessage: "Sets the privacy level")

		let clone = CommandOption("clone", usageMessage: "Clone a repository into a new directory")
		let inits = CommandOption("init", usageMessage: "Create an empty Git repository or reinitialize an existing one")
		let add		= CommandOption("add", usageMessage: "Add file contents to the index")
		let mv		= CommandOption("mv", usageMessage: "Move or rename a file, a directory, or a symlink")
		let reset = CommandOption("mv", usageMessage: "Reset current HEAD to the specified state")
		let rm		= CommandOption("rm", usageMessage: "Remove files from the working tree and from the index")

		let args = SwiftArgs(arguments: [help, type, clone, inits, add, mv, reset, rm])

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
