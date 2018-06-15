//
// SwiftConsole.swift
// Created by Ardalan Samimi on 2018-06-11
//
import Foundation

private protocol SwiftConsoleOutputType {

}

private struct SwiftConsoleHeader: SwiftConsoleOutputType {

	let title: String

}

private struct SwiftConsoleRow: SwiftConsoleOutputType {

	let left: String
	let right: String

}

struct SwiftConsole {

	private var rows: [SwiftConsoleOutputType] = []
	private var size: Int = 0

	mutating func addRow(leftColumn: String, rightColumn: String?) {
		let row = SwiftConsoleRow(left: leftColumn, right: rightColumn ?? "")

		self.size = max(self.size, leftColumn.count)
		self.rows.append(row)
	}

	mutating func addHeader(_ title: String) {
		let header = SwiftConsoleHeader(title: title)
		self.rows.append(header)
	}

	func prettyFormat() -> String {
		var arguments = [CVarArg]()
		var strFormat = ""
		let padding = self.size + 2

		for output in self.rows {
			if output is SwiftConsoleRow, let output = output as? SwiftConsoleRow {
				arguments.append(NSString(string: output.left).utf8String!)
				arguments.append(NSString(string: output.right).utf8String!)

				strFormat += "  %-\(padding)s%s\n"
			} else if output is SwiftConsoleHeader, let output = output as? SwiftConsoleHeader {
				arguments.append(NSString(string: output.title).utf8String!)

				strFormat += "\n%s\n"
			}
		}

		return String(format: strFormat, arguments: arguments)
	}

}
