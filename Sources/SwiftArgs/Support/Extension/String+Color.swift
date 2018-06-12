//
// String+Color.swift
// Created by Ardalan Samimi on 2018-06-12
//
public extension String {

	internal mutating func setColor(_ color: ANSIColor, style: ANSIAttribute = .normal, toWords words: String...) {
		var string = self

		for word in words {
			string = string.replacingOccurrences(of: word, with: word.colorize(color, withStyle: style))
		}

		self = string
	}

	internal func colorize(_ color: ANSIColor, withStyle style: ANSIAttribute = .normal) -> String {
		let color = color.rawValue
		let style = style.rawValue

		let startCode = "\u{001B}[\(style);\(color)m"
		let endCode =  "\u{001B}[\(ANSIAttribute.normal.rawValue);\(ANSIColor.default.rawValue)m"

		return "\(startCode)\(self)\(endCode)"
	}

	public var black: String {
		return self.colorize(.black)
	}

	public var blue: String {
		return self.colorize(.blue)
	}

	public var cyan: String {
		return self.colorize(.cyan)
	}

	public var green: String {
		return self.colorize(.green)
	}

	public var magenta: String {
		return self.colorize(.magenta)
	}

	public var red: String {
		return self.colorize(.red)
	}

	public var white: String {
		return self.colorize(.white)
	}

	public var yellow: String {
		return self.colorize(.yellow)
	}

	public var `default`: String {
		return self.colorize(.`default`)
	}

}
