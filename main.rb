class Board
    def initialize
        @board = [[1,2,3],[4,5,6],[7,8,9]]
    end

    def draw
        @board.each_with_index {|row, i|
            row.each_with_index{|val, j|
                print(" "+@board[i][j].to_s+" ")
                if j != row.length-1
                    print("|")
                end
            }
            if i != row.length-1
                print("\n---+---+---")
            end
            print("\n")
        }
    end

    def change_symbol(i,j,symbol)
        @board[i][j] = symbol
    end

    def board
        @board
    end

    def in_play_area(i,j)
        return i >= 0 && i < 3 && j < 3 && j >= 0
    end
end


class Player
    attr_reader :score
    def initialize(name,symbol)
        @name = name
        @symbol = symbol
        @score = 0
    end

    def name
        @name
    end

    def symbol
        @symbol
    end

    def won
        @score+=1
    end

end

class Game 
    def initialize(p1, p2, game_board)
        @p1 = p1
        @p2 = p2
        @game_board = game_board
    end

    def is_win(i,j,symbol)
        win_col = true 
        board = @game_board.board()
        board.each{|x|
            win_col = win_col && x[j] === symbol
        }
        win_row = true
        board[i].each{|x|
            win_row = win_row && x === symbol
        }

        win_diag = true
        if i == j
            p = 0
            board.each{|x|
                win_diag = win_diag && x[p] === symbol
                p+=1
            }
        else
            win_diag = false
        end

        win_diag2 = true
        if board.length-1 - i == j
            p = 0
            board.each{|x|
                win_diag2 = win_diag2 && x[board.length-1 - p] === symbol
                p+=1
            }
        else
            win_diag2 = false
        end
        
    
        return win_col || win_diag || win_diag2 || win_row
    end

    def take_turn(p)
        puts "\nIt's #{p.name}'s turn, choose an available square and type it's number\n"
        number = gets.chomp.to_i
        while !(@game_board.board[0].include?(number) || @game_board.board[1].include?(number) || @game_board.board[2].include?(number)) do
            puts "Invalid number! Try again"
            number = gets.chomp.to_i
        end
        i = (number - 1) / 3
        j = (number - 1) % 3
        @game_board.change_symbol(i,j,p.symbol)
        return is_win(i,j,p.symbol)
    end
end




puts "What is the name of the first player?"
name = gets.chomp

puts "What symbol would you like to play with?"
symbol = gets.chomp

while symbol.length != 1 do
    puts "Invalid symbol! Try again"
    symbol = gets.chomp
end

player1 = Player.new(name,symbol)

puts "What is the name of the second player?"
name = gets.chomp

puts "What symbol would you like to play with?"
symbol = gets.chomp
while symbol.length != 1 do
    puts "Invalid symbol! Try again"
    symbol = gets.chomp
end
player2 = Player.new(name,symbol)

game = true

while game do 
    game_board = Board.new()
    game_board.draw
    game = Game.new(player1,player2,game_board)

    turn = 1
    over = false
    while !over do
        if turn == 1
            over = game.take_turn(player1)
            game_board.draw

            if over
                puts "The winner is #{player1.name}"
                player1.won
            else
                turn = 2
            end
        else
            over = game.take_turn(player2)
            game_board.draw

            if over
                puts "The winner is #{player2.name}"
                player2.won

            else
                turn = 1
            end
        end

    end
    puts "Would you like to play again? (y/n)"
    ans = gets.chomp
    if ans === "n" || ans === "N"
        game = false
        puts "Final score:\n#{player1.name}: #{player1.score}\n#{player2.name}: #{player2.score}"
    end
end