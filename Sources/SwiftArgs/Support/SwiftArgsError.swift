//
// SwiftArgsError.swift
// Created by Ardalan Samimi on 2018-06-10
//
public enum SwiftArgsError: Error, CustomStringConvertible {

	case missingValue(String)
	case invalidValue(String, for: String)
	case invalidCommand(String, for: String)
	case invalidArgument(String)

	public var description: String {
		switch self {
		case let .missingValue(option):
			return "\(option) requires a value"
		case let .invalidValue(value, option):
			return "Invalid value '\(value)' for \(option)"
		case let .invalidCommand(value, option):
			return "Invalid value '\(value)' for \(option)"
		case let .invalidArgument(value):
			return "Invalid argument -- \(value)"
		}
	}

}
