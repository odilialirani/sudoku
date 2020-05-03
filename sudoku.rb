require 'pry'

class Sudoku

  def initialize(row, column)
    puts "Creating #{row}x#{column} board"
    
    @box_height = Math.sqrt(row)
    @box_width = Math.sqrt(column)
    @max_value = @box_height * @box_width

    @board = Array.new(row){Array.new(column, 0)}
  end

  def randomize
    # fill in random spots
    # get random number n -- number of given soln
    # for each iteration, get random i and j, call possible number
    # (0..2).each do |i|

    # end
    # Want to keep track of the element that's "fixed"
  end

  def is_fixed(i, j)
    return false
  end

  def fill(i, j, arr, idx)
    return false if arr[idx].nil?
    return true if @board[i][j].nil?
    # return true  is_fixed(i, j)

    @board[i][j] = arr[idx]

    # find next i, j
    next_i = i
    next_j = j+1

    if next_j >= @board[i].count
      next_i += 1
      next_j = 0
    end

    return true if next_i == @board.count

    next_pos = possible_numbers(next_i, next_j)

    return true if fill(next_i, next_j, next_pos, 0)

    return true && fill(i, j, arr, idx + 1)
  end

  def solve
    arr = possible_numbers(0, 0)
    fill(0, 0, arr, 0)
  end

  # return x, y
  # the upper left most coord of the "box"
  # that i,j belongs to
  def upper_left_box(i, j)
    x = (i / @box_height).floor * @box_height
    y = (j / @box_width).floor * @box_width

    return x, y
  end

  def xy_in_ij_box?(i,j,x,y)
    start_i, start_j = upper_left_box(i, j)
    end_i = start_i + @box_height
    end_j = start_j + @box_height

    x >= start_i && x < end_i && y >= start_j && y < end_j
  end

  def possible_numbers(i, j)
    possible = (1..@max_value).to_a

    @board.each_with_index do |row, x|
      row.each_with_index do |value, y|
        next if value == 0

        possible.delete(value) if x == i || y == j || xy_in_ij_box?(i,j,x,y)
      end
    end
    possible
  end

  def print_board
    @board.each_with_index do |row, i|
      r = ""
      row.each_with_index do |a, j|
        r << "#{a} |"
      end
      puts r
    end
  end
end

sudoku = Sudoku.new(9, 9)
sudoku.solve
sudoku.print_board

