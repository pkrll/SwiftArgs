
internal class Option: ArgumentType {

  let shortFlag: String
  let longFlag: String
	let name: String

  init(name: String, shortFlag: String, longFlag: String = "") {
    self.shortFlag = shortFlag
    self.longFlag = longFlag
		self.name = name
  }

  convenience init(name: String, longFlag: String) {
    self.init(name: name, shortFlag: "", longFlag: longFlag)
  }

	public func hasFlag(_ flag: String) -> Bool {
		let sFlag = "-\(self.shortFlag)"
		let lFlag = "-\(self.longFlag)"

		return flag == sFlag || flag == lFlag
	}

}
