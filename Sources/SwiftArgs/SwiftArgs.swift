//
// SwiftArgs.swift
// Created by Ardalan Samimi on 2018-06-09
//
public struct SwiftArgs {

	let parser: SwiftArgsParser

  init(arguments: [Argument] = []) {
		self.parser = SwiftArgsParser(arguments: arguments)
  }

	func parse(_ arguments: [String]? = nil) {
		self.parser.start(arguments)
	}

}
