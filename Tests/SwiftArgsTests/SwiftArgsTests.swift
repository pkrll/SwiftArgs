import XCTest
@testable import SwiftArgs

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
			try args.parse(["SwiftArgs", "clean"])
			XCTAssertTrue(clean.value)

			try args.parse(["SwiftArgs", "init", "library"])
			XCTAssertTrue(library.value)

			try args.parse(["SwiftArgs", "init", "folder", "--privacy", "public"])

			if let privacy = folder.value as? FlagOption<PrivacyLevel> {
				XCTAssertEqual(privacy.value, PrivacyLevel.Public)
			} else {
				XCTAssertTrue(false)
			}

		} catch {
			XCTAssertTrue(false, "\(error)")
		}

	}

}
