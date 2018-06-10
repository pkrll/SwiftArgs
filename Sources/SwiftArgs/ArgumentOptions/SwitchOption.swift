
class SwitchOption: Argument {

	var value: Bool = false

	override init(name: String) {
		super.init(name: name)

		self.type = .SwitchOption
	}

}
