
class SwitchOption: Argument {

	var value: Bool = false

	override init(name: String) {
		super.init(name: name)

		self.type = .SwitchOption
	}

	override func setValue(_ value: Any) throws {
		guard let value = value as? Bool else { return }
		self.value = value
	}

}
