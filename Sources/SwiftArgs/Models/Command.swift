
internal class Command: ArgumentType {

  var subCommands: [Command]
  var flagOptions: [Option]

	let name: String

  init(name: String, withSubCommands subCommands: [Command] = [], flagOptions: [Option] = []) {
		self.name = name
    self.subCommands = subCommands
    self.flagOptions = flagOptions
  }

  convenience init(name: String, withOptions options: [Option]) {
    self.init(name: name, withSubCommands: [], flagOptions: options)
  }

	func addSubCommands(_ subCommands: [Command]) {
		self.subCommands.append(contentsOf: subCommands)
	}

	func addOptions(_ flagOptions: [Option]) {
		self.flagOptions.append(contentsOf: flagOptions)
	}

}
