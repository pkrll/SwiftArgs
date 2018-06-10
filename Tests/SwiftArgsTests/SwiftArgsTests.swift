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

		let command = CommandOption("init", withArguments: [flag])

		let args = SwiftArgs(arguments: [switchOption, command])

		do {
			try args.parse(["nope", "init", "-f", "f"])
		} catch SwiftArgsError.invalidValue(let message) {
			print(message)
		} catch SwiftArgsError.invalidCommand(let message) {
			print(message)
		} catch SwiftArgsError.invalidArgument(let message) {
			print(message)
		} catch {
			print(error)
		}

		if let flags = command.value as? FlagOption<Flags> {
			print(flags.value)
		}

		XCTAssertTrue(switchOption.value)

	}

}
