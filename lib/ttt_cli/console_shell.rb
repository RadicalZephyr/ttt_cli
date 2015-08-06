require 'tic_tac_toe_gs'

module TttCli

  class ConsoleShell < TicTacToeGS::Core::Player
    attr_reader :game

    def self.new_shell(console)
      game = TicTacToeGS::Core::Game.new_game
      shell = self.new(console, game)
      return shell
    end

    def initialize(console, game)
      @console, @game = console, game

      @game.illegal_move_handler= Proc.new { || self.show_illegal_move_message }

      @will_block = true
      @can_retry  = true
    end

    def main_loop
      show_welcome_message
      loop do
        play_game
        break unless play_again?
        game.reset
      end
    end

    def play_game
      game.set_players(*choose_players)
      game_loop
    end

    # The shell has to implement the Player ducktype

    def get_move(_)
      got_input = false
      until got_input
        str = prompt_move
        begin
          input = Integer(str)
          if input.between?(0,8)
            got_input = true
          else
            show_invalid_move_message
          end
        rescue ArgumentError
          show_move_error_message
        end
      end

      input
    end

    def set_marks(_, _)
    end

    def show_move_error_message
      @console.puts "Sorry, I didn't understand your move."
      try_again
    end

    def show_invalid_move_message
      @console.puts "That is not a valid move choice."
      try_again
    end

    def show_illegal_move_message
      @console.puts "That move has already been played."
      try_again
    end


    private

    def game_loop
      until game.finished?
        show_move_message
        show_board(game.board)
        game.next_turn
      end
      display_winner(game.who_won?)
    end

    def get_player(mark)
      loop do
        case prompt_player(mark)
        when "h", "human"
          return self
        when "r", "random"
          return TicTacToeGS::Core::Players::Random.new(Random.new)
        when "a", "ai"
          return TicTacToeGS::Core::Players::Minimax.new
        end
      end
    end

    def choose_players
      [get_player("X"), get_player("O")]
    end


    ########################################
    ## I/O Methods
    ########################################

    def prompt_move
      @console.print "Enter your move [0-8]: "
      @console.flush
      @console.gets.chomp
    end

    def prompt_player(mark)
      @console.print "Who should play #{mark}'s ([h]uman, [r]andom or [a]i)? "
      @console.flush
      @console.gets.chomp
    end

    def yn_to_bool(input)
      case input.downcase
      when "y", "yes"
        true
      when "n", "no"
        false
      end
    end

    def play_again?
      @console.print "Would you like to play again? "
      @console.flush
      yn_to_bool(@console.gets.chomp)
    end

    def try_again
      @console.puts "Please try again."
    end

    def show_move_message
      @console.puts "\nIt is the #{game.current_mark}'s move."
    end

    def show_board(board)
      @console.puts board
      @console.puts
    end

    def show_welcome_message
      @console.puts "Welcome to Tic Tac Toe!"
    end

    def display_winner(winner_mark)
      show_board(game.board)
      if winner_mark
        @console.puts "The #{winner_mark}'s win!"
      else
        @console.puts "It was a draw."
      end
    end

  end

end
