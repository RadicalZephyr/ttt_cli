require "ttt_cli/version"
require "ttt_cli/console_shell"

module TttCli

  def self.run
    shell = TttCli::ConsoleShell.new_shell(IO::console)
    shell.main_loop
  end
end
