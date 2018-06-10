//
// SwiftArgsParser.swift
// Created by Ardalan Samimi on 2018-06-10
//
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
	/**
	 * 	Starts parsing the given arguments.
	 *
	 * 	- Parameter arguments: A list of arguments to parse (optional).
	 *
	 * 	- Throws: `SwiftArgsError.invalidArgument` if the `arguments` parameter
	 * 		contains arguments that does not match those in `validArguments`.
	 */
	func start(_ arguments: [String]? = CommandLine.arguments) throws {
		self.givenArguments = arguments!
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
