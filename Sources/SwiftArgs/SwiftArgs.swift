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

	public func printUsage(debugMode: Bool = false) {
		var description = "Usage: \(self.executableName) <command> <argument>\n"

		description += "\(self.parser.printUsage())"

		if debugMode {
			print(description, to: &self.outputStream)
		} else {
			print(description, to: &StdoutOutputStream.stream)
		}
	}

}
