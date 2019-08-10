//
// String+Color.swift
// Created by Ardalan Samimi on 2018-06-12
//
internal extension String {

	mutating func setColor(_ color: ANSIColor, style: ANSIAttribute = .normal, toWords words: String...) {
		var string = self

		for word in words {
			string = string.replacingOccurrences(of: word, with: word.colorize(color, withStyle: style))
		}

		self = string
	}

	func colorize(_ color: ANSIColor, withStyle style: ANSIAttribute = .normal) -> String {
		let color = color.rawValue
		let style = style.rawValue

		let startCode = "\u{001B}[\(style);\(color)m"
		let endCode =  "\u{001B}[\(ANSIAttribute.normal.rawValue);\(ANSIColor.normal.rawValue)m"

		return "\(startCode)\(self)\(endCode)"
	}

	var black: String {
		return self.colorize(.black)
	}

	var blackBold: String {
		return self.colorize(.black, withStyle: .bold)
	}

	var blue: String {
		return self.colorize(.blue)
	}

	var blueBold: String {
		return self.colorize(.blue, withStyle: .bold)
	}

	var cyan: String {
		return self.colorize(.cyan)
	}

	var cyanBold: String {
		return self.colorize(.cyan, withStyle: .bold)
	}

	var green: String {
		return self.colorize(.green)
	}

	var greenBold: String {
		return self.colorize(.green, withStyle: .bold)
	}

	var magenta: String {
		return self.colorize(.magenta)
	}

	var magentaBold: String {
		return self.colorize(.magenta, withStyle: .bold)
	}

	var red: String {
		return self.colorize(.red)
	}

	var redBold: String {
		return self.colorize(.red, withStyle: .bold)
	}

	var white: String {
		return self.colorize(.white)
	}

	var whiteBold: String {
		return self.colorize(.white, withStyle: .bold)
	}

	var yellow: String {
		return self.colorize(.yellow)
	}

	var yellowBold: String {
		return self.colorize(.yellow, withStyle: .bold)
	}

	var normal: String {
		return self.colorize(.normal)
	}

	var normalBold: String {
		return self.colorize(.normal, withStyle: .bold)
	}

}
