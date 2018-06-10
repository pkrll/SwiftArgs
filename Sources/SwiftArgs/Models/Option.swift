
public class Option {

  let shortFlag: String
  let longFlag: String

  init(shortFlag: String, longFlag: String = "") {
    self.shortFlag = shortFlag
    self.longFlag = longFlag
  }

  convenience init(longFlag: String) {
    super.init(shortFlag: "", longFlag: longFlag)
  }

}
