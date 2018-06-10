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
				case .invalidArgument: XCTAssertTrue(true)
				default: XCTAssertTrue(false)
			}
		}

		XCTAssertThrowsError(try testInvalidCommand()) { error in
			let error = error as! SwiftArgsError

			switch error {
				case .invalidCommand: XCTAssertTrue(true)
				default: XCTAssertTrue(false)
			}
		}

		XCTAssertThrowsError(try testInvalidValue()) { error in
			let error = error as! SwiftArgsError

			switch error {
				case .invalidValue: XCTAssertTrue(true)
				default: XCTAssertTrue(false)
			}
		}

		XCTAssertThrowsError(try testMissingValue()) { error in
			let error = error as! SwiftArgsError

			switch error {
				case .missingValue: XCTAssertTrue(true)
				default: XCTAssertTrue(false)
			}
		}

	}

}
