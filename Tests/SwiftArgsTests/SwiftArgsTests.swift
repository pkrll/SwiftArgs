import XCTest
@testable import SwiftArgs

final class SwiftArgsTests: XCTestCase {

	static var allTests = [
		("testSwiftArgs", testSwiftArgs),
	]

	func testSwiftArgs() {
		enum Flags: String {
			case Flag1 = "flag1"
			case Flag2 = "flag2"
			case Flag3 = "flag3"
		}

		let switchOption = SwitchOption(name: "nope")
		let flag = FlagOption<Flags>(name: "Flags", shortFlag: "f", longFlag: "flag")

		let args = SwiftArgs(arguments: [switchOption, flag])
		args.parse(["nope", "-f", "flag3"])

		XCTAssertTrue(switchOption.value)

	}

}
