class Board
  attr_accessor :sq_hash

  def initialize
    @sq_hash = {}
    (1..9).each {|key|@sq_hash[key] = Square.new(' ')}
  end

  def draw_board
    system 'clear'
    puts "#{sq_hash[1].value} | #{sq_hash[2].value} | #{sq_hash[3].value}"
    puts "--+---+---"
    puts "#{sq_hash[4].value} | #{sq_hash[5].value} | #{sq_hash[6].value}"
    puts "--+---+---"
    puts "#{sq_hash[7].value} | #{sq_hash[8].value} | #{sq_hash[9].value}"
  end

  def empty_spaces
    sq_hash.select {|key, value| sq_hash[key].value == ' '}.keys
  end

  def winner?(marker)
  Game::WINNERS.each do |winner|
    return true if sq_hash[winner[0]].value == marker &&
                   sq_hash[winner[1]].value == marker &&
                   sq_hash[winner[2]].value == marker
                end
                false
              end
  end

class Player
  attr_accessor :name, :choice, :marker

  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end

class Square
  attr_accessor :value

  def initialize(value) # this is going to be ' ' 'X' or 'O'
    @value = value
  end
end

class Game # this is the game engine. procedural can go here  
  WINNERS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
  attr_accessor :board, :player, :computer, :current_player

  def initialize
    @player = Player.new("Patrick", "X")
    @computer =  Player.new("Robot", "O")
    @board = Board.new
    @current_player = @player
  end 

  def current_player_pick
    if @current_player == player
      begin
        puts "Please chose a square."
        position = gets.chomp.to_i
      end until board.empty_spaces.include?(position)
      board.sq_hash[position].value = player.marker
    else
      sleep(1)
      position = board.empty_spaces.sample
      board.sq_hash[position].value = computer.marker
    end
  end

  def alternate_player
    if @current_player == player
      @current_player = computer
    else
      @current_player = player
    end
  end

  def win_display
    puts "#{@current_player.name} wins!"
  end

  def play_again?
    puts "Press any key to play again or 'n' to quit."
    play_again = gets.chomp.downcase
    if play_again != 'n'
      Game.new.play
    end
  end
  
  def play
    board.draw_board
    loop do
      current_player_pick
      board.draw_board
      if board.winner?(@current_player.marker)
        win_display
        break
      elsif board.empty_spaces.empty?
        puts "It's a tie!"
        break
      else
        alternate_player
      end
    end
    play_again?
  end

end

Game.new.play
