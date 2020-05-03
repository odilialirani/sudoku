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
  end

  def fill(i, j, arr, idx)
    return false if arr[idx].nil?
    return true if @board[i][j].nil?

    @board[i][j] = arr[idx]

    # find next i, j
    next_i = i
    next_j = j+1

    if j + 1 > @board[i].count
      next_i += 1
      next_j = 0
    end

    return true if next_i == @board.count
    next_pos = possible_numbers(next_i, next_j)

    while !fill(next_i, next_j, next_pos, 0)
      fill(i, j, arr, idx+1)
    end

    # get possible number
    # return true && fill(next)
  end

  def solve
    # solve the puzzle
    arr = possible_numbers(i, j)
    is_solved? = fill(0, 0, arr, 0)
    # @board.each_with_index do |row, i|
    #   row.each_with_index do |a, j|
    #     arr = possible_number_from_box(i, j)


    #   end
    # end
  end

  # return x, y
  # the upper left most coord of the "box"
  # that i,j belongs to
  def upper_left_box(i, j)
    x = Math.floor(i / @box_height) * @box_height
    y = Math.floor(j / @box_width) * @box_width

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

sudoku = Sudoku.new(4, 4)
sudoku.print_board
