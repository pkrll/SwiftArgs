//
// SwiftArgsParser.swift
// Created by Ardalan Samimi on 2018-06-09
//

internal class SwiftArgsParser {

	let validArguments: [Argument]
	var givenArguments: [String] = []

	private var currentIndex: Int = 0

	private var nextArgument: String? {
		guard self.givenArguments.count > self.currentIndex else { return nil }
		let currentArgument = self.givenArguments[currentIndex]
		self.currentIndex += 1

		return currentArgument
	}

	init(arguments: [Argument]) {
		self.validArguments = arguments
	}

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

			commandOption.value = commandOption[argument]
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
