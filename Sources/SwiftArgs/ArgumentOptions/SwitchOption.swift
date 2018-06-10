//
// SwitchOption.swift
// Created by Ardalan Samimi on 2018-06-10
//
public class SwitchOption: Argument {

	private(set) public var value: Bool = false
	/**
	 *  SwitchOption represents a boolean argument (i.e. --no-install).
	 *
	 *  - Parameter name: Name of the option.
	 */
	public override init(name: String) {
		super.init(name: name)

		self.type = .SwitchOption
	}

	internal override func setValue(_ value: Any) throws {
		guard let value = value as? Bool else { return }
		self.value = value
	}

}
