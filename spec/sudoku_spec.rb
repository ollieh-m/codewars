require_relative '../sudoku.rb'
require "byebug"

RSpec.describe 'Sudoku solver' do
  it 'returns the correct solution' do
    puzzle = [
      [9, 0, 0, 0, 8, 0, 0, 0, 1],
      [0, 0, 0, 4, 0, 6, 0, 0, 0],
      [0, 0, 5, 0, 7, 0, 3, 0, 0],
      [0, 6, 0, 0, 0, 0, 0, 4, 0],
      [4, 0, 1, 0, 6, 0, 5, 0, 8],
      [0, 9, 0, 0, 0, 0, 0, 2, 0],
      [0, 0, 7, 0, 3, 0, 2, 0, 0],
      [0, 0, 0, 7, 0, 5, 0, 0, 0],
      [1, 0, 0, 0, 4, 0, 0, 0, 7]
    ]

    # working out how to get box coordinates from regular coordinates
    # coordinates; how far from the corresponding box's starting x, y; where does y end up
    # 0, 1 is 0, 1 - y ends up 3
    # 3, 1 is 0, 1 - y ends up 3
    # 4, 1 is 1, 1 - y ends up 4
    # 0, 4 is 0, 1 - y ends up 3
    # 0, 3 is 0, 0 - y ends up 0
    # 1, 3 is 1, 0 - y ends up 1
    # 2, 3 is 2, 0 - y ends up 2
    # 0, 5 is 0, 2 - y ends up 6
    # 1, 5 is 1, 2 - y ends up 7
    # row = ((x / 3)*3) + (y / 3)
    # column = (x - ((x / 3)*3)) + (y - ((y/3)*3))*3

    solution = [
      [9, 2, 6, 5, 8, 3, 4, 7, 1],
      [7, 1, 3, 4, 2, 6, 9, 8, 5],
      [8, 4, 5, 9, 7, 1, 3, 6, 2],
      [3, 6, 2, 8, 5, 7, 1, 4, 9],
      [4, 7, 1, 2, 6, 9, 5, 3, 8],
      [5, 9, 8, 3, 1, 4, 7, 2, 6],
      [6, 5, 7, 1, 3, 8, 2, 9, 4],
      [2, 8, 4, 7, 9, 5, 6, 1, 3],
      [1, 3, 9, 6, 4, 2, 8, 5, 7]
    ]

    result = solve(puzzle)
    expect(result).to eq solution
  end
end
