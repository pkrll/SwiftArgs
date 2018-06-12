//
// String+Color.swift
// Created by Ardalan Samimi on 2018-06-12
//
internal extension String {

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

	internal var black: String {
		return self.colorize(.black)
	}

	internal var blue: String {
		return self.colorize(.blue)
	}

	internal var cyan: String {
		return self.colorize(.cyan)
	}

	internal var green: String {
		return self.colorize(.green)
	}

	internal var magenta: String {
		return self.colorize(.magenta)
	}

	internal var red: String {
		return self.colorize(.red)
	}

	internal var white: String {
		return self.colorize(.white)
	}

	internal var yellow: String {
		return self.colorize(.yellow)
	}

	internal var `default`: String {
		return self.colorize(.`default`)
	}

}
