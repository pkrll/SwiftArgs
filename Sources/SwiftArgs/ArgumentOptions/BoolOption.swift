//
// BoolOption.swift
// Created by Ardalan Samimi on 2018-06-11
//
public class BoolOption: FlagOption<Bool> {
	/**
	 *  BoolOption represents a boolean flag argument (i.e. --flag).
	 *
	 *  - Parameter name: Name of the option
	 *  - Parameter shortFlag: The short flag to be used.
	 *  - Parameter longFlag: The long flag to be used.
	 *  - Parameter usageMessage: The description for the option.
	 */
	override public init(name: String, shortFlag: String?, longFlag: String? = nil, usageMessage: String? = nil) {
		super.init(name: name, shortFlag: shortFlag, longFlag: longFlag, usageMessage: usageMessage)
		self.type = .BoolOption
		try? self.setValue(false)
	}

	override internal func setValue(_ value: Any) throws {
		guard let value = value as? Bool else { return }
		try super.setValue(value)
	}

}
