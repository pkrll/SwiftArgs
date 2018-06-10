internal extension ArgumentType {

	static func ==(lhs: Self, rhs: String) -> Bool {
		return lhs.name == rhs
	}

	static func ==(lhs: String, rhs: Self) -> Bool {
		return lhs == rhs.name
	}

	static func ==(lhs: Self, rhs: Self) -> Bool {
		return lhs.name == rhs.name
	}

}
