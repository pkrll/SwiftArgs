//
// FlagOption.swift
// Created by Ardalan Samimi on 2018-06-10
//
public class FlagOption<T: RawRepresentable>: Argument where T.RawValue == String {

	let shortFlag: String
	let longFlag: String
	private(set) var value: T?
	/**
	 *  FlagOption represents a flag argument (i.e. --flag).
	 *
	 *  - Parameter name: Name of the option
	 *  - Parameter shortFlag: The short flag to be used.
	 *  - Parameter longFlag: The long flag to be used.
	 */
	init(name: String, shortFlag: String, longFlag: String = "") {
		self.shortFlag = shortFlag
		self.longFlag = longFlag
		super.init(name: name)

		self.type = .FlagOption
	}
	/**
	 *  FlagOption represents a flag argument (i.e. --flag).
	 *
	 *  - Parameter name: Name of the option
	 *  - Parameter longFlag: The long flag to be used.
	 */
	convenience init(name: String, longFlag: String) {
		self.init(name: name, shortFlag: "", longFlag: longFlag)
	}

	internal override func equals(_ compare: String) -> Bool {
		return "-\(self.shortFlag)" == compare || "-\(self.longFlag)" == compare
	}

	internal override func setValue(_ value: Any) throws {
		guard let value = value as? String else { return }

		if let value = T(rawValue: value) {
			self.value = value
		} else {
			throw SwiftArgsError.invalidValue(value, for: "-\(self.shortFlag) (--\(self.longFlag))")
		}
	}

}
