//
// Argument.swift
// Created by Ardalan Samimi on 2018-06-10
//
import Foundation

public class Argument: CustomStringConvertible {
  /**
   *  If set true, an error will be thrown if argument is not set.
   */
	let isRequired: Bool
  /**
   *  The name of the argument.
   */
	let name: String
  /**
   *  The help description of the argument.
   */
	let help: String?
  /**
   *  The type of the argument.
   */
	var type: ArgumentType
  /**
   *  Name of the argument.
   */
	public var description: String {
		return self.name
	}
  /**
   *   Initializes a new argument with the specified name,
   *   help message and whether or not it is required.
   *
   *   - Parameter name: The name of the argument.
   *   - Parameter usageMessage: The help message displayed.
   *   - Parameter isRequired: If true, the argument must be set.
   */
	public init(name: String, description: String?, isRequired: Bool = false) {
		self.name = name
		self.help = description
		self.isRequired = isRequired
		self.type = .argument
	}

	internal func equals(_ compare: String) -> Bool {
		return self.name == compare
	}

	internal func validate() throws { /* Intentionally unimplemented... */ }

	internal func setValue(_ argument: Any) throws { /* Intentionally unimplemented... */ }

}
