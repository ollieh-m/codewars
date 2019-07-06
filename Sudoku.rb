require "byebug"

def solve(puzzle)
  SudokuSolver.new(puzzle).solution
end

class SudokuSolver
  attr_reader :original_puzzle, :solved_puzzle, :solved_puzzle_in_columns, :solved_puzzle_in_boxes, :progress_tracker, :position, :x, :y

  def initialize(puzzle)
    @original_puzzle = puzzle
    @solved_puzzle = clone_original_puzzle
    @solved_puzzle_in_columns = transpose_solved_puzzle
    @solved_puzzle_in_boxes = turn_solved_puzzle_boxes_into_rows
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

    def clone_original_puzzle
      @original_puzzle.map(&:clone)
    end

    def transpose_solved_puzzle
      @solved_puzzle.transpose
    end

    def turn_solved_puzzle_boxes_into_rows
      @solved_puzzle.each_slice(3).map(&:transpose).flatten.each_slice(9).to_a
    end

    def set_coordinates
      @x, @y = position.divmod(9)
    end

    def try_to_fill_slot
      return if slot_filled_in_original_puzzle? && increment_position

      if new_number = find_new_valid_number
        success(new_number)
      else
        failure
      end
    end

    def slot_filled_in_original_puzzle?
      !original_puzzle[x][y].zero?
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
      solved_puzzle_in_columns[y]
    end

    def box
      solved_puzzle_in_boxes[x_converted_for_boxes_as_rows]
    end

    def x_converted_for_boxes_as_rows
      ((x / 3) * 3) + (y / 3)
    end

    def success(new_number)
      solved_puzzle[x][y] = new_number
      solved_puzzle_in_columns[y][x] = new_number
      solved_puzzle_in_boxes[x_converted_for_boxes_as_rows][y_converted_for_boxes_as_rows] = new_number

      track_progress
      increment_position
    end

    def y_converted_for_boxes_as_rows
      box_start_row = (x / 3) * 3
      box_start_column = (y / 3) * 3
      (x - box_start_row) + ((y - box_start_column) * 3)
    end

    def track_progress
      progress_tracker.unshift(position)
    end

    def failure
      solved_puzzle[x][y] = 0
      solved_puzzle_in_columns[y][x] = 0
      solved_puzzle_in_boxes[x_converted_for_boxes_as_rows][y_converted_for_boxes_as_rows] = 0

      revert_position
    end

    def revert_position
      @position = progress_tracker.shift
    end
end
