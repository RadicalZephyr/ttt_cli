require 'spec_helper'
require 'io/console'

describe TttCli::ConsoleShell do
  let(:console) { mock_console }
  let(:board) { TicTacToe::Core::Board.empty_board }
  let(:game) { mock_game }
  let(:console_shell) { TicTacToe::Console::ConsoleShell.new(console, game) }

  def mock_console
    instance_double('IO').tap do |console|
      allow(console).to receive(:puts)
      allow(console).to receive(:print)
      allow(console).to receive(:flush)
      allow(console).to receive(:gets).and_return("1\n")
    end
  end

  def mock_game
    TicTacToe::Core::Game.new_game.tap do |game|
      allow(game).to receive(:board).and_return(board)
      allow(game).to receive(:current_mark).and_call_original
      allow(game).to receive(:current_mark=).and_call_original
    end
  end

  describe 'running the console shell' do

    it 'it only plays one game if the user says no' do
      allow(game).to receive(:finished?).and_return(true)
      allow(console).to receive(:gets).and_return("h", "h", "n")
      expect(console_shell).to receive(:game_loop).once
      console_shell.main_loop
    end

    it 'keeps playing games until the user says no' do
      allow(game).to receive(:finished?).and_return(true)
      allow(console).to receive(:gets).and_return("h", "h", "y",
                                                  "h", "h", "y",
                                                  "h", "h", "n")
      expect(console_shell).to receive(:game_loop).exactly(3).times
      console_shell.main_loop
    end
  end

  describe 'getting user input' do

    def with(input:, expecting:)
      allow(console_shell).to receive(:prompt_move).and_return("#{input}\n")
      expect(console_shell.get_move(nil)).to eq(expecting)
    end

    def ignores(input:)
      allow(console_shell).to receive(:prompt_move).and_return("#{input}\n", "1\n")
      expect(console_shell.get_move(nil)).to eq(1)
    end

    it 'keeps reading until it gets a number' do
      allow(console_shell).to receive(:prompt_move).and_return("abcd\n", "def\n", "{1a\n", "1\n")
      expect(console_shell.get_move(nil)).to eq(1)
    end

    it 'should only return a number between 0 and 8' do
      ignores(input: "-10")
      ignores(input: "-1")
      ignores(input: "9")
      ignores(input: "15")
      with(input: "0", expecting: 0)
      with(input: "4", expecting: 4)
      with(input: "8", expecting: 8)
    end

  end
end
