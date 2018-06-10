
class CommandOption: Argument {

	let arguments: [Argument]
	var value: ArgumentProtocol?

	init(_ name: String, withArguments arguments: [Argument]) {
		self.arguments = arguments
		super.init(name: name)
		self.type = .CommandOption
	}

	func takesArgument(_ argument: String) -> Bool {
		return false
	}

	subscript(argument: String) -> ArgumentProtocol? {
		return nil
	}

	override func setValue(_ value: Any) {
		guard let value = value as? ArgumentProtocol else { return }
		self.value = value
	}

}
