
public class Command {

  let commands: [Command]
  let options: [Option]

  init(commands: [Command] = [], options: [Option] = []) {
    self.commands = commands
    self.options = options
  }

  convenience init(options: [Option]) {
    super.init(commands: [], options: options)
  }

}
