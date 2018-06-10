//
// Argument+Equatable.swift
// Created by Ardalan Samimi on 2018-06-10
//
extension Argument: Equatable {

	public static func ==(lhs: Argument, rhs: String) -> Bool {
		return lhs.name == rhs
	}

	public static func ==(lhs: String, rhs: Argument) -> Bool {
		return lhs == rhs.name
	}

	public static func ==(lhs: Argument, rhs: Argument) -> Bool {
		return lhs.name == rhs.name
	}

}
