require 'spec_helper'
require 'io/console'

describe "Playing a full game" do
  let(:console) { mock_console }
  let(:shell)   { TicTacToeGS::Console::ConsoleShell.new_shell(console) }

  def mock_console
    instance_double('IO').tap do |console|
      allow(console).to receive(:puts)
      allow(console).to receive(:print)
      allow(console).to receive(:flush)
    end
  end

  def make_moves(xs, ys)
    moves = xs.zip(ys).flatten.compact
    moves.map { |move| move.to_s + "\n" }
  end

  it "ends after a win" do
    x_moves = [0, 1, 2]
    y_moves = [3, 4]

    inputs = ["h\n", "h\n"] + make_moves(x_moves, y_moves)
    expect(console).to receive(:gets).and_return(*inputs)

    shell.play_game
  end

  it "ends after a draw" do
    x_moves = [0, 1, 3, 8, 4]
    y_moves = [2, 6, 7, 5]

    inputs = ["h\n", "h\n"] + make_moves(x_moves, y_moves)
    expect(console).to receive(:gets).and_return(*inputs)

    shell.play_game
  end

  it 'can play games with random and ai players' do
    inputs = ["r\n", "a\n"]
    expect(console).to receive(:gets).and_return(*inputs)
    shell.play_game
    inputs = ["a\n", "r\n"]
    expect(console).to receive(:gets).and_return(*inputs)
    shell.play_game
  end

  it 'can play games with two ai players' do
    inputs = ["a\n", "a\n"]
    expect(console).to receive(:gets).and_return(*inputs)
    shell.play_game
  end

  it 'plays multiple games from main loop' do
    x_moves = [0, 1, 3, 8, 4]
    y_moves = [2, 6, 7, 5]
    moves = [make_moves(x_moves, y_moves)] * 2
    inputs = [["h\n", "h\n"], ["y\n", "h\n", "h\n"], "n\n"].zip(moves).flatten.compact
    expect(console).to receive(:gets).and_return(*inputs)
    expect(shell).to receive(:game_loop).twice.and_call_original
    shell.main_loop
  end
end
