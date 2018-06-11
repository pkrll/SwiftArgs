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

		let commands = self.validArguments.filter { $0.type == .CommandOption }
		let flags = self.validArguments.filter { $0.type != .CommandOption }

		var swiftConsole = SwiftConsole()

		if commands.count > 0 {
			swiftConsole.addHeader("Commands:")
			commands.forEach { swiftConsole.addRow(leftColumn: $0.name, rightColumn: $0.help) }
		}

		if flags.count > 0 {
			swiftConsole.addHeader("Optional arguments:")
			flags.forEach { swiftConsole.addRow(leftColumn: $0.description, rightColumn: $0.help) }
		}

		description += swiftConsole.prettyFormat()

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
		if argument.type == .StringOption {
			try self.parse(stringOption: argument)
		} else if argument.type == .BoolOption {
			self.parse(boolOption: argument)
		} else if argument.type == .EnumOption {
			try self.parse(enumOption: argument)
		} else if argument.type == .CommandOption {
			try self.parse(commandOption: argument as! CommandOption)
		}
	}

	private func parse(boolOption: Argument) {
		try! boolOption.setValue(true)
	}

	private func parse(stringOption: Argument) throws {
		guard let argument = self.nextArgument else {
			self.currentIndex -= 1
			let flag = self.nextArgument ?? stringOption.name
			throw SwiftArgsError.missingValue(flag)
		}

		try stringOption.setValue(argument)
	}

	private func parse(enumOption: Argument) throws {
		guard let argument = self.nextArgument else {
			self.currentIndex -= 1
			let flag = self.nextArgument ?? enumOption.name
			throw SwiftArgsError.missingValue(flag)
		}

		try enumOption.setValue(argument)
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
