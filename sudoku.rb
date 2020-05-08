require 'pry'

class Sudoku

  def initialize(row, column)
    puts "Creating #{row}x#{column} board"
    
    @row = row
    @column = column

    @box_height = Math.sqrt(row)
    @box_width = Math.sqrt(column)
    @max_value = @box_height * @box_width

    @board = Array.new(row){Array.new(column, 0)}
    @pos_board = Array.new(row){Array.new(column, [])}
    @pos_count = {}
  end

  def randomize
    @fixed_board = @board = Array.new(@row){Array.new(@column, 0)}

    fill_count = (0.1 * @row * @column).floor
    
    x = 0
    while x < fill_count
      i = rand(0...@row)
      j = rand(0...@column)
      pos = possible_numbers(i,j)

      if @board[i][j] == 0
        @board[i][j] = pos[rand(0...pos.count)]
        @fixed_board[i][j] = @board[i][j]
        x += 1
      end
    end
  end

  def is_fixed(i, j)
    @fixed_board[i][j] > 0
  end

  def check_possibilities(i=nil, j=nil)
    @pos_count = {} if i.nil? && j.nil?

    @board.each_with_index do |row, x|
      row.each_with_index do |value, y|
        next if is_fixed(x, y)

        if i.nil? && j.nil?
          @pos_board[x][y] = possible_numbers(x, y)
        else
          # We only want to update the possibilities for the row, col, and box if ij
          # next if x == i && y == j # we don't want to update the
          @pos_board[x][y] = possible_numbers(x, y) if x == i || y == j || xy_in_ij_box?(i,j,x,y)
        end

        coord = OpenStruct.new
        coord.x = x
        coord.y = y
        if @pos_count[@pos_board[x][y].count].nil?
          @pos_count[@pos_board[x][y].count] = [coord]
        else
          @pos_count[@pos_board[x][y].count] << coord
        end
      end
    end
  end

  # This will return the next OpenStruct tuple
  def get_next_box
    (1..@max_value).to_a.each do |a|
      next if @pos_count[a].nil? || @pos_count[a].empty?
      coord = @pos_count[a][-1]
      return @pos_count[a].pop if @board[coord.x][coord.y] == 0
    end

    return nil
  end

  def is_solved?
    @board.each_with_index do |row, x|
      row.each_with_index do |value, y|
        return false if value == 0
      end
    end

    return true
  end

  def fill(i, j, arr, idx)
    return false if arr[idx].nil?
    return true if is_fixed(i, j)

    @board[i][j] = arr[idx]
    check_possibilities(i,j)
    next_coord = get_next_box

    if next_coord.nil?
      # No more possible boxes
      # Check if we've solved the puzzle
      if is_solved?
        return true
      else
        fill(i, j, arr, idx + 1)
        # next_coord = get_next_box
      end
    end

    next_pos = @pos_board[next_coord.x][next_coord.y]

    # mark this box as success if we can successfully fill the next box
    return true if fill(next_coord.x, next_coord.y, next_pos, 0) 
    
    # Try filling with next value in the array
    return fill(i, j, arr, idx + 1)
  end

  def solve
    check_possibilities
    coord = get_next_box
    return false if coord.nil?

    possible_values = possible_numbers(coord.x, coord.y)
    fill(coord.x, coord.y, possible_values, 0)
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

  def print_pos_board
    @pos_board.each_with_index do |row, i|
      r = ""
      row.each_with_index do |a, j|
        r << "#{a} |"
      end
      puts r
    end
  end

  def pos_count
    @pos_count
  end

  def play
    randomize
    # print_board
    solve
    print_board
  end
end

sudoku = Sudoku.new(9, 9)
sudoku.play
# sudoku.randomize
# sudoku.print_board
# sudoku.check_possibilities

