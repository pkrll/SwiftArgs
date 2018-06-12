//
// StringOption.swift
// Created by Ardalan Samimi on 2018-06-11
//
public class StringOption: FlagOption<String> {
  /**
   *  StringOption represents a flag argument with a arbitrary value (i.e. --flag someValue).
   *  - Parameter name: Name of the option
   *  - Parameter shortFlag: The short flag to be used.
   *  - Parameter longFlag: The long flag to be used.
   *  - Parameter description: The description for the option.
   *  - Parameter isRequired: If true, the argument must be set.
   */
  override public init(
    name: String,
    shortFlag: String?,
    longFlag: String? = nil,
    description: String? = nil,
    isRequired: Bool = false) {
		super.init(name: name, shortFlag: shortFlag, longFlag: longFlag, description: description, isRequired: isRequired)
		self.type = .stringOption
	}

	override internal func setValue(_ value: Any) throws {
		guard let value = value as? String else { return }
		try super.setValue(value)
	}

}
