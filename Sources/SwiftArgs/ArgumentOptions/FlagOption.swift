//
// FlagOption.swift
// Created by Ardalan Samimi on 2018-06-10
//

public class FlagOption<T>: Argument {

	let shortFlag: String?
	let longFlag: String?

	private(set) public var value: T?

	override public var description: String {
		var description = ""

		if let flag = self.shortFlag {
			description += "-\(flag)"
			if self.longFlag != nil { description += ", " }
		}

		description += (self.longFlag != nil) ? "--\(self.longFlag!)" : ""

		return description
	}

	/**
	 *  FlagOption represents a flag argument (i.e. --flag).
	 *
	 *  - Parameter name: Name of the option
	 *  - Parameter shortFlag: The short flag to be used.
	 *  - Parameter longFlag: The long flag to be used.
	 */
	public init(name: String, shortFlag: String?, longFlag: String? = nil, usageMessage: String? = nil) {
		self.shortFlag = shortFlag
		self.longFlag = longFlag
		super.init(name: name, usageMessage: usageMessage)
	}
	/**
	 *  FlagOption represents a flag argument (i.e. --flag).
	 *
	 *  - Parameter name: Name of the option
	 *  - Parameter longFlag: The long flag to be used.
	 */
	public convenience init(name: String, longFlag: String, usageMessage: String? = nil) {
		self.init(name: name, shortFlag: nil, longFlag: longFlag, usageMessage: usageMessage)
	}

	internal override func equals(_ compare: String) -> Bool {
		let sFlag = (self.shortFlag != nil) ? "-\(self.shortFlag!)" : ""
		let lFlag = (self.longFlag != nil) ? "--\(self.longFlag!)" : ""

		return sFlag == compare || lFlag == compare
	}

	internal override func setValue(_ value: Any) throws {
		guard let value = value as? T else { return }
		self.value = value
	}

}
