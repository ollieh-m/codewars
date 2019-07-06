def solve(puzzle)
  SudokuSolver.new(puzzle).solution
end

class SudokuSolver
  attr_reader :original_puzzle, :solved_puzzle, :progress_tracker, :position, :x, :y

  def initialize(puzzle)
    @original_puzzle = puzzle
    @solved_puzzle = puzzle.map(&:clone)
    @progress_tracker = []
    @position = 0
  end

  def solution
    until position == 81
      set_coordinates
      try_to_fill_slot
    end

    solved_puzzle
  end

  private

    def try_to_fill_slot
      return if slot_filled_in_original_puzzle? && increment_position

      if new_number = find_new_valid_number
        success(new_number)
      else
        failure
      end
    end

    def set_coordinates
      @x, @y = position.divmod(9)
    end

    def slot_filled_in_original_puzzle?
      original_puzzle_zero_lookup[position]
    end

    def original_puzzle_zero_lookup
      @_original_puzzle_zero_lookup ||= Hash.new do |hash, key|
        hash[key] = !original_puzzle[x][y].zero?
      end
    end

    def increment_position
      @position += 1
    end

    def find_new_valid_number
      (current_number + 1 ..9).each do |try_number|
        return try_number if valid?(try_number)
      end
      nil
    end

    def current_number
      solved_puzzle[x][y]
    end

    def valid?(try_number)
      return if row.include?(try_number)
      return if column.include?(try_number)
      return if box.include?(try_number)
      true
    end

    def row
      solved_puzzle[x]
    end

    def column
      solved_puzzle.map do |row|
        row[y]
      end
    end

    def box
      box_start_row = (x / 3) * 3
      box_start_column = (y / 3) * 3
      # solved_puzzle.slice(box_start_row, 3).flat_map do |row|
      #   row.slice(box_start_column, 3)
      # end
      solved_puzzle.values_at(box_start_row..box_start_row + 2).flat_map do |row|
        row.values_at(box_start_column..box_start_column + 2)
      end
    end

    def success(new_number)
      solved_puzzle[x][y] = new_number
      track_progress
      increment_position
    end

    def track_progress
      progress_tracker.unshift(position)
    end

    def failure
      solved_puzzle[x][y] = 0
      revert_position
    end

    def revert_position
      @position = progress_tracker.shift
    end
end
