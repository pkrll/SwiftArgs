//
// CommandOption.swift
// Created by Ardalan Samimi on 2018-06-10
//
public class CommandOption: Argument {

	internal let arguments: [Argument]
	private(set) public var argument: Argument?
	private(set) public var value: Bool = false
  /**
   *  CommandOption represents a command (i.e. `init`).
   *
   *  - Parameter name: Name of the option.
   *  - Parameter withArguments: List of sub arguments.
   *  - Parameter description: The description of the argument.
   *  - Parameter isRequired: If true, the argument must be set.
   */
	public init(_ name: String, withArguments: [Argument] = [], description: String? = nil, isRequired: Bool = false) {
		self.arguments = withArguments
		super.init(name: name, description: description, isRequired: isRequired)
		self.type = .commandOption
	}
  /**
   *  CommandOption represents a command (i.e. `init`).
   *
   *  - Parameter name: Name of the option.
   *  - Parameter description: The description of the argument.
   *  - Parameter isRequired: If true, the argument must be set.
   */
	public convenience init(_ name: String, description: String? = nil, isRequired: Bool = false) {
		self.init(name, withArguments: [], description: description, isRequired: isRequired)
	}

	internal func takesArgument(_ argument: String) -> Bool {
		return self.arguments.contains(argument)
	}

	internal subscript(argument: String) -> Argument? {
		return self.arguments[argument]
	}

	override internal func validate() throws {
		if self.isRequired && self.value == false {
			throw SwiftArgsError.missingRequiredArgument(self.description)
		}

		try self.arguments.forEach { try $0.validate() }
	}

	internal override func setValue(_ value: Any) throws {
		guard let value = value as? Bool else { return }
		self.value = value
	}

	internal func setArgument(_ argument: Argument) {
		self.argument = argument
	}

}
