//
// SwiftArgsParser.swift
// Created by Ardalan Samimi on 2018-06-10
//
import Foundation

internal class SwiftArgsParser {

	private let validArguments: [Argument]
	private var givenArguments: [String] = []

	private var currentIndex: Int = 0

	private var nextArgument: String? {
		guard self.givenArguments.count > self.currentIndex else { return nil }
		let currentArgument = self.givenArguments[currentIndex]
		self.currentIndex += 1

		return currentArgument
	}
	/**
	 *  Initializes the argument parser.
	 *
	 *  - Parameter arguments: List of valid arguments.
	 */
	init(arguments: [Argument]) {
		self.validArguments = arguments
	}

	func printUsage() -> String {
		var description = ""

		var count: [ArgumentType: Int] = [.CommandOption: 0, .FlagOption: 0, .SwitchOption: 0]
		var table: [ArgumentType: [(name: String, help: String)]] = [.CommandOption: [], .FlagOption: [], .SwitchOption: []]

		for argument in self.validArguments {
			count[argument.type] = max(count[argument.type]!, argument.name.count)
			table[argument.type]!.append((name: argument.description, help: argument.help ?? ""))
		}

		if table[.CommandOption]!.count > 0 {
			description += "\nCommands: \n"
			let count = count[.CommandOption]! + 5

			for (name, usage) in table[.CommandOption]! {
				let name  = String(format: "  %-\(count)s", (name as NSString).utf8String!)
				let usage	= String(format: "%-\(count)s", (usage as NSString).utf8String!)

				description += "\(name)\(usage)\n"
			}
		}

		if table[.FlagOption]!.count > 0 || table[.SwitchOption]!.count > 0 {
			description += "\nOptional arguments: \n"

			let count = max(count[.FlagOption]!, count[.SwitchOption]!) + 5

			for (name, usage) in table[.FlagOption]! {
				let name  = String(format: "  %-\(count)s", (name as NSString).utf8String!)
				let usage = String(format: "%-\(count)s", (usage as NSString).utf8String!)

				description += "\(name)\(usage)\n"
			}

			for (name, usage) in table[.SwitchOption]! {
				let name  = String(format: "  %-\(count)s", (name as NSString).utf8String!)
				let usage = String(format: "%-\(count)s", (usage as NSString).utf8String!)

				description += "\(name)\(usage)\n"
			}
		}

		return description
	}
	/**
	 * 	Starts parsing the given arguments.
	 *
	 * 	- Parameter arguments: A list of arguments to parse (optional).
	 *
	 * 	- Throws: `SwiftArgsError.invalidArgument` if the `arguments` parameter
	 * 		contains arguments that does not match those in `validArguments`.
	 */
	func start(_ arguments: [String]? = nil) throws {
		self.givenArguments = (arguments == nil) ? Array(CommandLine.arguments[1...]) : arguments!
		self.currentIndex = 0

		while let nextArgument = self.nextArgument {
			guard let argument = self.validArguments[nextArgument] else {
				throw SwiftArgsError.invalidArgument(nextArgument)
			}

			try self.parse(argument)
		}

	}

	private func parse(_ argument: Argument) throws {
		if argument.type == .FlagOption {
			try self.parse(flagOption: argument)
		} else if argument.type == .SwitchOption {
			self.parse(switchOption: argument)
		} else if argument.type == .CommandOption {
			try self.parse(commandOption: argument as! CommandOption)
		}
	}

	private func parse(switchOption: Argument) {
		try! switchOption.setValue(true)
	}

	private func parse(commandOption: CommandOption) throws {
		while let argument = self.nextArgument {
			guard commandOption.takesArgument(argument), let subArgument = commandOption[argument] else {
				self.currentIndex -= 1
				throw SwiftArgsError.invalidCommand(argument, for: commandOption.name)
			}

			try self.parse(subArgument)

			try! commandOption.setValue(commandOption[argument])
		}

	}

	private func parse(flagOption: Argument) throws {
		guard let argument = self.nextArgument else {
			self.currentIndex -= 1
			let flag = self.nextArgument ?? flagOption.name
			throw SwiftArgsError.missingValue(flag)
		}

		try flagOption.setValue(argument)
	}

}
