
public class StringOption: FlagOption<String> {

	override public init(name: String, shortFlag: String?, longFlag: String? = nil, usageMessage: String? = nil) {
		super.init(name: name, shortFlag: shortFlag, longFlag: longFlag, usageMessage: usageMessage)
		self.type = .StringOption
	}

	internal override func setValue(_ value: Any) throws {
		guard let value = value as? String else { return }
		try super.setValue(value)
	}

}
