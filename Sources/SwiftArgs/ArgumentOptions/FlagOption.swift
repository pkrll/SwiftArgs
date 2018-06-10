
class FlagOption<T>: Argument {

	let shortFlag: String
	let longFlag: String
	var value: String?

	init(name: String, shortFlag: String, longFlag: String = "") {
		self.shortFlag = shortFlag
		self.longFlag = longFlag
		super.init(name: name)

		self.type = .FlagOption
	}

	convenience init(name: String, longFlag: String) {
		self.init(name: name, shortFlag: "", longFlag: longFlag)
	}

}
