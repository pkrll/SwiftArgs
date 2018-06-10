//
// SwiftArgsParser.swift
// Created by Ardalan Samimi on 2018-06-09
//
internal class SwiftArgsParser {

	let validArguments: [Argument]
	var givenArguments: [String] = []

	private var currentIndex: Int = 0

	private var nextArgument: String? {
		guard self.givenArguments.count < self.currentIndex else { return nil }
		let currentArgument = self.givenArguments[currentIndex]
		self.currentIndex += 1

		return currentArgument
	}

	init(arguments: [Argument]) {
		self.validArguments = arguments
	}

	func start() {

		while let argument = self.nextArgument {
			self.parse(argument)
		}

	}

	private func parse(_ argument: String) {
		guard let argument = self.validArguments[argument] else { return } // TODO: Throw error

		if argument.type == .FlagOption {
			self.parse(flagOption: argument as! FlagOption<Any>)
		} else if argument.type == .SwitchOption {
			self.parse(switchOption: argument as! SwitchOption)
		} else if argument.type == .CommandOption {
			self.parse(commandOption: argument as! CommandOption<Any>)
		}
	}

	private func parse(switchOption: SwitchOption) {
		switchOption.value = true
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

	private func parse(flagOption: FlagOption<Any>) {

	}

}

//
// extension SwiftArgsParser {
// 	func run(_ arguments: [String]? = nil) {
// 		self.givenArguments = (arguments == nil) ? Array(CommandLine.arguments[1...]) : arguments!
//
// 		while (self.givenArguments.count > 0) {
// 			guard let givenArgument = self.givenArguments.first else { return }
// 			guard let validArgument = self.validArguments[argument] else { return } // TODO: Throw error
//
// 			self.givenArguments = Array(self.givenArguments[1...])
//
// 			switch validArgument.type {
// 			case .Command:
// 				self.parseCommand(validArgument)
// 			case .Option:
// 				self.parseOption(validArgument)
// 				break
// 			default:
// 				break
// 			}
//
// 		}
//
// 	}
//
// 	private func parseCommand(_ command: Command) {
// 		guard let givenArgument = self.givenArguments.first else { return }
// 		guard let validArgument = command.subCommands[]
// 	}
//
// 	private func parseOption(_ name: String) {
//
// 	}
//
// }
