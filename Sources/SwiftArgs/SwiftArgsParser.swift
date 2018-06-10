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

	func start(_ arguments: [String]? = CommandLine.arguments) {
		self.givenArguments = arguments!
		while let argument = self.nextArgument {
			self.parse(argument)
		}

	}

	private func parse(_ argument: String) {
		guard let argument = self.validArguments[argument] else { return } // TODO: Throw error

		if argument.type == .FlagOption {
			self.parse(flagOption: argument)
		} else if argument.type == .SwitchOption {
			self.parse(switchOption: argument)
		} else if argument.type == .CommandOption {
			self.parse(commandOption: argument as! CommandOption<Any>)
		}
	}

	private func parse(switchOption: Argument) {
		switchOption.setValue(true)
	}

	private func parse(commandOption: CommandOption<Any>) {
		while let argument = self.nextArgument {
			guard commandOption.takesArgument(argument) else {
				self.currentIndex -= 1
				return
			}

			self.parse(argument)

			commandOption.value = commandOption[argument]
		}

	}

	private func parse(flagOption: Argument) {
		guard let argument = self.nextArgument else {
			// TODO: Throw error
			return
		}

		flagOption.setValue(argument)
	}

}
