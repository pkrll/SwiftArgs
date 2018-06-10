
class Argument: ArgumentProtocol, Equatable {

	let name: String
	var type: ArgumentType

	init(name: String) {
		self.name = name
		self.type = .Argument
	}

	func equals(_ compare: String) -> Bool {
		return self.name == compare
	}

	func setValue(_ argument: Any) { }

	static func Command<T>(_ name: String, withArguments arguments: [Argument]) -> CommandOption<T> {
		return CommandOption<T>(name, withArguments: arguments)
	}

	static func Switch(_ name: String) -> SwitchOption {
		return SwitchOption(name: name)
	}

	static func Flag<T>(_ name: String, shortFlag: String, longFlag: String = "") -> FlagOption<T> {
		return FlagOption<T>(name: name, shortFlag: shortFlag, longFlag: longFlag)
	}

	static func Flag<T>(_ name: String, longFlag: String) -> FlagOption<T> {
		return FlagOption<T>(name: name, shortFlag: "", longFlag: longFlag)
	}

}
