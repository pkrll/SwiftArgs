//
// String+Color.swift
// Created by Ardalan Samimi on 2018-06-12
//
public extension String {

	internal func setColor(_ color: SwiftArgsColor) -> String {
		return "\(color.rawValue)\(self)"
	}

	public var black: String {
		return self.setColor(.black)
	}

	public var blue: String {
		return self.setColor(.blue)
	}

	public var cyan: String {
		return self.setColor(.cyan)
	}

	public var green: String {
		return self.setColor(.green)
	}

	public var magenta: String {
		return self.setColor(.magenta)
	}

	public var red: String {
		return self.setColor(.red)
	}

	public var white: String {
		return self.setColor(.white)
	}

	public var yellow: String {
		return self.setColor(.yellow)
	}

	public var `default`: String {
		return self.setColor(.`default`)
	}

}
