//
// SwiftArgs.swift
// Created by Ardalan Samimi on 2018-06-09
//
public struct SwiftArgs {

	private let parser: SwiftArgsParser

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

}
