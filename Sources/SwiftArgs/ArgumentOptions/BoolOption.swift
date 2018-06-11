
public class BoolOption: FlagOption<Bool> {

	override public init(name: String, shortFlag: String?, longFlag: String? = nil, usageMessage: String? = nil) {
		super.init(name: name, shortFlag: shortFlag, longFlag: longFlag, usageMessage: usageMessage)
		self.type = .BoolOption
		try? self.setValue(false)
	}

	internal override func setValue(_ value: Any) throws {
		guard let value = value as? Bool else { return }
		try super.setValue(value)
	}

}
