//
// CommandOption.swift
// Created by Ardalan Samimi on 2018-06-10
//
public class CommandOption: Argument {

	private let arguments: [Argument]
	private(set) public var value: Argument?
	/**
	 *  CommandOption represents a command (i.e. init).
	 *
	 *  - Parameter name: Name of the option
	 *  - Parameter withArguments: List of sub arguments.
	 */
	public init(_ name: String, withArguments arguments: [Argument] = [], usageMessage: String? = nil) {
		self.arguments = arguments
		super.init(name: name, usageMessage: usageMessage)
		self.type = .CommandOption
	}

	public convenience init(_ name: String, usageMessage: String? = nil) {
		self.init(name, withArguments: [], usageMessage: usageMessage)
	}

	internal func takesArgument(_ argument: String) -> Bool {
		return self.arguments.contains(argument)
	}

	internal subscript(argument: String) -> Argument? {
		return self.arguments[argument]
	}

	internal override func setValue(_ value: Any?) throws {
		guard let value = value as? Argument else { return }
		self.value = value
	}

}
