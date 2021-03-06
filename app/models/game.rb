class Game < ActiveRecord::Base
  serialize :board
  
  include GamesHelper

  # This line tells Rails which attributes of the model are accessible, i.e., 
  # which attributes can be modified automatically by outside users 
  # (such as users submitting requests with web browsers).
  attr_accessible :board, :current_player, :status, :player_o, :player_x, 

	def initialize
    super
		self.board = Array.new(3).map{[nil, nil, nil]} 
    
    # to increment player turn in #play
    @turn = 0
	end

	def update_board(player, row, column)
    if board[row][column]
      raise ArgumentError, "This spot is full."
    else
		  board[row][column] = player
      self.save
    end
	end

  def current_player(turn)
    if turn.even?
      'x'
    else
      'o'
    end
  end

  def play(row, column)
    if winner?
      @turn -= 1
      "Player #{current_player(@turn)} is the winner!"
    else
      update_board(current_player(@turn), row, column)
      @turn += 1
    end
  end

  def check_rows_for_winner
    board.each do |a|
      if a[0]
        return a[0] == a[1] && a[0] == a[2]
      end
    end
    return false
  end

  def check_columns_for_winner
    (0..2).each do |e|
      if board[0][e]
        return board[0][e] == board[1][e] && board[0][e] == board[2][e]
      end
    end
    false
  end

  def check_diagnols_for_winner
    if board[1][1]
      if board[0][0] == board[1][1] && board[0][0] == board[2][2]
        true
      elsif board[0][2] == board[1][1] && board[0][2] == board[2][0]
        true
      end
    else
      false
    end
  end

  def winner?
    if check_rows_for_winner
      true
    elsif check_columns_for_winner
      true
    elsif check_diagnols_for_winner
      true
    else
      false
    end
  end
end

# TODO
# Only create default values for the board in the db OR initialize it in the model, not both!
