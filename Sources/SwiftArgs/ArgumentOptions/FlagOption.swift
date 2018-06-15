//
// FlagOption.swift
// Created by Ardalan Samimi on 2018-06-10
//

public class FlagOption<T>: Argument {

	let shortFlag: String?
	let longFlag: String?

	private(set) public var value: T?

	override public var description: String {
		var returnValue = ""

		if let flag = self.shortFlag {
			returnValue += "-\(flag)"
			if self.longFlag != nil {
				returnValue += ", "
			}
		}

		returnValue += (self.longFlag != nil) ? "--\(self.longFlag!)" : ""

		return returnValue
	}
  /**
   *  FlagOption represents a flag argument (i.e. --flag).
   *
   *  - Parameter name: Name of the option.
   *  - Parameter shortFlag: The short flag to be used.
   *  - Parameter longFlag: The long flag to be used.
   *  - Parameter description: The description for the option.
   *  - Parameter isRequired: If true, the argument must be set.
   */
	public init(
			name: String,
			shortFlag: String?,
			longFlag: String? = nil,
			description: String? = nil,
			isRequired: Bool = false) {
		self.shortFlag = shortFlag
		self.longFlag = longFlag
		super.init(name: name, description: description, isRequired: isRequired)
	}
  /**
   *  FlagOption represents a flag argument (i.e. --flag).
   *
   *  - Parameter name: Name of the option.
   *  - Parameter longFlag: The long flag to be used.
   *  - Parameter description: The description for the option.
   *  - Parameter isRequired: If true, the argument must be set.
   */
	public convenience init(name: String, longFlag: String, description: String? = nil, isRequired: Bool = false) {
		self.init(name: name, shortFlag: nil, longFlag: longFlag, description: description, isRequired: isRequired)
	}

	override internal func equals(_ compare: String) -> Bool {
		let sFlag = (self.shortFlag != nil) ? "-\(self.shortFlag!)" : ""
		let lFlag = (self.longFlag != nil) ? "--\(self.longFlag!)" : ""

		return sFlag == compare || lFlag == compare
	}

	override internal func validate() throws {
		if self.isRequired && self.value == nil {
			throw SwiftArgsError.missingRequiredArgument(self.description)
		}

		try super.validate()
	}

	override internal func setValue(_ value: Any) throws {
		guard let value = value as? T else { return }
		self.value = value
	}

}
