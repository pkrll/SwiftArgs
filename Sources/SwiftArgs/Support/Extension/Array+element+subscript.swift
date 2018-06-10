extension Array where Element:Argument {

	subscript(name: String) -> Argument? {
		return self.element(withName: name)
	}

	func element(withName name: String) -> Argument? {
		return self.filter { $0 == name }.first
	}

}
