# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ttt_cli/version'

Gem::Specification.new do |spec|
  spec.name          = "ttt_cli"
  spec.version       = TttCli::VERSION
  spec.authors       = ["Zefira Shannon"]
  spec.email         = ["geoffpshannon@gmail.com"]

  spec.summary       = %q{A CLI interface for TicTacToe}
  spec.description   = %q{This depends on the core library tic_tac_toe, and provides a binary 'ttt_cli'.}
  spec.homepage      = "https://github.com/RadicalZephyr/ttt_cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   << 'ttt_cli'
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "tic_tac_toe_gs", "~> 0.1"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "3.2.0"
  spec.add_development_dependency "guard-rspec", "4.5.0"

end
