
public class EnumOption<T: RawRepresentable>: FlagOption<T>  where T.RawValue == String {

	override public init(name: String, shortFlag: String?, longFlag: String? = nil, usageMessage: String? = nil) {
		super.init(name: name, shortFlag: shortFlag, longFlag: longFlag, usageMessage: usageMessage)
		self.type = .EnumOption
	}

	internal override func setValue(_ value: Any) throws {
		guard let value = value as? String else { return }

		if let value = T(rawValue: value) {
			try super.setValue(value)
		} else {
			var flags = (self.shortFlag != nil) ? "-\(self.shortFlag!), " : ""
			flags += (self.longFlag != nil) ? "--\(self.longFlag!)" : ""

			throw SwiftArgsError.invalidValue(value, for: flags)
		}

	}

}
