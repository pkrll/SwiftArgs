//
// EnumOption.swift
// Created by Ardalan Samimi on 2018-06-11
//
public class EnumOption<T: RawRepresentable>: FlagOption<T>  where T.RawValue == String {
	/**
	 *  EnumOption represents a flag argument with a predefined value (i.e. --flag someValue),
	 *  where someValue matches a value associated with the EnumOption's enum type.
	 *
	 *  - Parameter name: Name of the option
	 *  - Parameter shortFlag: The short flag to be used.
	 *  - Parameter longFlag: The long flag to be used.
	 *  - Parameter usageMessage: The description for the option.
	 */
	override public init(name: String, shortFlag: String?, longFlag: String? = nil, usageMessage: String? = nil) {
		super.init(name: name, shortFlag: shortFlag, longFlag: longFlag, usageMessage: usageMessage)
		self.type = .enumOption
	}

	override internal func setValue(_ value: Any) throws {
		guard let value = value as? String else { return }

		if let value = T(rawValue: value) {
			try super.setValue(value)
		} else {
			var flags = (self.shortFlag != nil) ? "-\(self.shortFlag!), " : ""
			flags += (self.longFlag != nil) ? "--\(self.longFlag!)" : ""

			throw SwiftArgsError.invalidValue(value, for: flags)
		}

	}

}
