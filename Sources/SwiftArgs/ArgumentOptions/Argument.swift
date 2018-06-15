//
// Argument.swift
// Created by Ardalan Samimi on 2018-06-10
//
import Foundation

public class Argument: CustomStringConvertible {
  /**
   *  If set true, an error will be thrown if argument is not set.
   */
	public let isRequired: Bool
  /**
   *  The name of the argument.
   */
	public let name: String
  /**
   *  The help description of the argument.
   */
	public let help: String?
  /**
   *  The type of the argument.
   */
	var type: ArgumentType = .argument
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
	}

	internal func equals(_ compare: String) -> Bool {
		return self.name == compare
	}

	internal func validate() throws { /* Intentionally unimplemented... */ }

	internal func setValue(_ argument: Any) throws { /* Intentionally unimplemented... */ }

}
