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

	func printUsage(_ argument: Argument? = nil) -> String {
		guard let command = argument as? CommandOption else {
			return self.printUsage(self.validArguments)
		}

		return self.printUsage(command.validArguments)
	}

	private func printUsage(_ arguments: [Argument]) -> String {
		var description = ""

		let commands = arguments.filter { $0.type == .commandOption }
		let flags = arguments.filter { $0.type != .commandOption }

		var swiftConsole = SwiftConsole()

		if commands.count > 0 {
			swiftConsole.addHeader("Commands:".magentaBold)
			commands.forEach { swiftConsole.addRow(leftColumn: $0.name.blue, rightColumn: $0.help?.green) }
		}

		if flags.count > 0 {
			swiftConsole.addHeader("Options:".magentaBold)
			flags.forEach { swiftConsole.addRow(leftColumn: $0.description.blue, rightColumn: $0.help?.green) }
		}

		description += swiftConsole.prettyFormat()

		return description
	}
  /**
   *   Starts parsing the given arguments.
   *
   *   - Parameter arguments: A list of arguments to parse (optional).
   *
   *   - Throws: `SwiftArgsError.invalidArgument` if the `arguments` parameter
   *     contains arguments that does not match those in `validArguments`.
   */
	func start(_ arguments: [String]) throws {
		self.givenArguments = arguments
		self.currentIndex = 0

		while let nextArgument = self.nextArgument {
			guard let argument = self.validArguments[nextArgument] else {
				throw SwiftArgsError.invalidArgument(nextArgument)
			}

			try self.parse(argument)
		}

		for argument in self.validArguments {
			try argument.validate()
		}
	}

	private func parse(_ argument: Argument) throws {
		if argument.type == .stringOption {
			try self.parse(stringOption: argument)
		} else if argument.type == .boolOption {
			try self.parse(boolOption: argument)
		} else if argument.type == .enumOption {
			try self.parse(enumOption: argument)
		} else if argument.type == .commandOption, let argument = argument as? CommandOption {
			try self.parse(commandOption: argument)
		}
	}

	private func parse(boolOption: Argument) throws {
		try boolOption.setValue(true)
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
		try commandOption.setValue(true)

		while let argument = self.nextArgument {
			guard commandOption.takesArgument(argument), let subArgument = commandOption[argument] else {
				self.currentIndex -= 1
				return
			}

			try self.parse(subArgument)

			commandOption.setArgument(subArgument)
		}

	}

}
