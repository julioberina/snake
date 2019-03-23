require "ruby2d"

GRID_SIZE = 20

set({ :width => 640, :height => 480, :title => "Snake", :background => "navy", :fps_cap => 10 })

class Snake
  attr_accessor :direction

  def initialize
    @positions = [[0, 0], [1, 0], [2, 0], [3, 0]]
    @direction = :right # default direction to right
    @growing = false
  end

  def move
    @growing ? @growing = !@growing : @positions.shift

    case @direction
    when :up
      @positions.push [head[0], (head[1] - 1) % 24]
    when :down
      @positions.push [head[0], (head[1] + 1) % 24]
    when :left
      @positions.push [(head[0] - 1) % 32, head[1]]
    when :right
      @positions.push [(head[0] + 1) % 32, head[1]]
    end
  end

  def draw
    @positions.each do |pos|
      Square.new(x: pos[0] * GRID_SIZE, y: pos[1] * GRID_SIZE, size: GRID_SIZE - 1, color: "green")
    end
  end

  def eats(apple)
    head[0] == apple.position[0] && head[1] == apple.position[1]
  end

  def grow
    @growing = true
  end

  def eats_itself?
    @positions.uniq.length != @positions.length
  end

  def rewind
    @positions = [[0, 0], [1, 0], [2, 0], [3, 0]]
    @direction = :right # default direction to right
    @growing = false
  end

  private

  def head
    @positions.last
  end
end

class Apple
  attr_reader :position

  def initialize
    @position = [rand(32), rand(24)]
  end

  def move_to_new_spot
    @position = [rand(32), rand(24)]
  end

  def draw
    Square.new(x: @position[0] * GRID_SIZE, y: @position[1] * GRID_SIZE, size: GRID_SIZE - 1, color: "red")
  end
end

snake = Snake.new
apple = Apple.new

update do
  clear

  if snake.eats(apple)
    snake.grow
    apple.move_to_new_spot
  end

  snake.rewind if snake.eats_itself?

  snake.move
  snake.draw
  apple.draw
end

on :key_up do |event|
  snake.direction = :up if event.key == "w" && snake.direction != :down
  snake.direction = :down if event.key == "s" && snake.direction != :up
  snake.direction = :left if event.key == "a" && snake.direction != :right
  snake.direction = :right if event.key == "d" && snake.direction != :left
end

show
