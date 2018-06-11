//
// Argument.swift
// Created by Ardalan Samimi on 2018-06-10
//
import Foundation

public class Argument: CustomStringConvertible {

	let name: String
	let help: String?
	var type: ArgumentType

	public var description: String {
		return self.name
	}

	public init(name: String, usageMessage help: String?) {
		self.name = name
		self.help = help
		self.type = .Argument
	}

	internal func equals(_ compare: String) -> Bool {
		return self.name == compare
	}

	internal func setValue(_ argument: Any) throws { }

}
