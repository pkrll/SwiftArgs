
class FlagOption<T: RawRepresentable>: Argument where T.RawValue == String {

	let shortFlag: String
	let longFlag: String
	var value: T?

	init(name: String, shortFlag: String, longFlag: String = "") {
		self.shortFlag = shortFlag
		self.longFlag = longFlag
		super.init(name: name)

		self.type = .FlagOption
	}

	convenience init(name: String, longFlag: String) {
		self.init(name: name, shortFlag: "", longFlag: longFlag)
	}

	override func equals(_ compare: String) -> Bool {
		return "-\(self.shortFlag)" == compare || "-\(self.longFlag)" == compare
	}

	override func setValue(_ value: Any) {
		guard let value = value as? String else { return }
		self.value = T(rawValue: value)
	}

}
