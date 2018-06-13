//
// SwiftArgs.swift
// Created by Ardalan Samimi on 2018-06-09
//
public class SwiftArgs {

	private let parser: SwiftArgsParser
	private var executableName: String = ""

	private(set) public var outputStream: String = ""

	public init(arguments: [Argument] = []) {
		self.parser = SwiftArgsParser(arguments: arguments)
		self.executableName = CommandLine.arguments[0]
	}

	public func parse(_ arguments: [String]? = nil) throws {
		let arguments = (arguments == nil) ? Array(CommandLine.arguments[1...]) : arguments!
		try self.parser.start(arguments)
	}

	public func printError(_ error: Error) {
		if let error = error as? SwiftArgsError {
			print(error.description.red)
		}
	}

	public func printUsage(_ argument: Argument? = nil, debugMode: Bool = false) {
		var commandName = "[\("command".yellow)]"

		if let command = argument as? CommandOption {
			commandName = command.name.yellow
		}

		var description = "Usage: \(self.executableName.magentaBold) \(commandName) [\("argument".yellow)]\n"

		description += "\(self.parser.printUsage(argument))"

		if debugMode {
			print(description, to: &self.outputStream)
		} else {
			print(description, to: &StdoutOutputStream.stream)
		}
	}

}
