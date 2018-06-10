internal extension Argument {

	static func ==(lhs: Argument, rhs: String) -> Bool {
		return lhs.name == rhs
	}

	static func ==(lhs: String, rhs: Argument) -> Bool {
		return lhs == rhs.name
	}

	static func ==(lhs: Argument, rhs: Argument) -> Bool {
		return lhs.name == rhs.name
	}

}
