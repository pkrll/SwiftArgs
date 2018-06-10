extension Array where Element:Command {

	func element(withName name: String) -> Command? {
		return self.filter { $0.name == name }.first
	}

}
