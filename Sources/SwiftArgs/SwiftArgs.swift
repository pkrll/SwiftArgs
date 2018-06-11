//
// SwiftArgs.swift
// Created by Ardalan Samimi on 2018-06-09
//
public class SwiftArgs {

	private let parser: SwiftArgsParser

	private(set) public var outputStream: String = ""

	public init(arguments: [Argument] = []) {
		self.parser = SwiftArgsParser(arguments: arguments)
	}

	public func parse(_ arguments: [String]? = nil) throws {
		try self.parser.start(arguments)
	}

	public func printError(_ error: Error) {
		let error = error as? SwiftArgsError ?? error
		print(error)
	}

	public func printUsage(debugMode: Bool = false) {
		var description = "Usage: APP_NAME <command> <argument>\n"

		description += "\(self.parser.printUsage())"

		if debugMode {
			print(description, to: &self.outputStream)
		} else {
			print(description, to: &StdoutOutputStream.stream)
		}
	}

}
