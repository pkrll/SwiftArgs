
class CommandOption: Argument {

	let arguments: [Argument]
	var value: Argument?

	init(_ name: String, withArguments arguments: [Argument]) {
		self.arguments = arguments
		super.init(name: name)
		self.type = .CommandOption
	}

	func takesArgument(_ argument: String) -> Bool {
		return self.arguments.contains(argument)
	}

	subscript(argument: String) -> Argument? {
		return self.arguments[argument]
	}

	override func setValue(_ value: Any) {
		guard let value = value as? Argument else { return }
		self.value = value
	}

}
