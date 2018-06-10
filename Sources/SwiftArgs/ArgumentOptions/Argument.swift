//
// Argument.swift
// Created by Ardalan Samimi on 2018-06-10
//
public class Argument {

	let name: String
	var type: ArgumentType

	public init(name: String) {
		self.name = name
		self.type = .Argument
	}

	internal func equals(_ compare: String) -> Bool {
		return self.name == compare
	}

	internal func setValue(_ argument: Any) throws { }

	public static func Command(_ name: String, withArguments arguments: [Argument]) -> CommandOption {
		return CommandOption(name, withArguments: arguments)
	}

	public static func Switch(_ name: String) -> SwitchOption {
		return SwitchOption(name: name)
	}

	public static func Flag<T>(_ name: String, shortFlag: String, longFlag: String = "") -> FlagOption<T> {
		return FlagOption<T>(name: name, shortFlag: shortFlag, longFlag: longFlag)
	}

	public static func Flag<T>(_ name: String, longFlag: String) -> FlagOption<T> {
		return FlagOption<T>(name: name, shortFlag: "", longFlag: longFlag)
	}

}
