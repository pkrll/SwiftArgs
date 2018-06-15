//
// CommandOption.swift
// Created by Ardalan Samimi on 2018-06-10
//
public class CommandOption: Argument {

	internal let validArguments: [Argument]
	private(set) public var arguments: [Argument] = []
	private(set) public var value: Bool = false

	public var argument: Argument? {
		return self.arguments.first
	}
  /**
   *  CommandOption represents a command (i.e. `init`).
   *
   *  - Parameter name: Name of the option.
   *  - Parameter withArguments: List of sub arguments.
   *  - Parameter description: The description of the argument.
   *  - Parameter isRequired: If true, the argument must be set.
   */
	public init(_ name: String, withArguments: [Argument] = [], description: String? = nil, isRequired: Bool = false) {
		self.validArguments = withArguments
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
		return self.validArguments.contains(argument)
	}

	internal subscript(argument: String) -> Argument? {
		return self.validArguments[argument]
	}

	override internal func validate() throws {
		if self.isRequired && !self.value {
			throw SwiftArgsError.missingRequiredArgument(self.description)
		}

		if self.value {
			try self.validArguments.forEach { try $0.validate() }
		}

		super.validate()
	}

	internal override func setValue(_ value: Any) throws {
		guard let value = value as? Bool else { return }
		self.value = value
	}

	internal func setArgument(_ argument: Argument) {
	guard self.arguments.contains(argument.name) == false else {
			return
		}

		self.arguments.append(argument)
	}

}
