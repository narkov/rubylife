# simple 2D array implementation based on hashes
class SparseArray
  attr_reader :hash

  def initialize
    @hash = {}
  end

  def [](key)
    hash[key] ||= {}
  end

  def rows
    hash.length   
  end

  alias_method :length, :rows
end


# class holds grid and cells status information
class Environment
  # actual grid size (width=height)
  attr_accessor :size      
  # currect grid with cells status
  attr_reader :grid        
  # next grid with cells status
  attr_reader :next_grid   
  # number of generation
  attr_reader :generation 
  # amount of alive cells
  attr_reader :live

  def initialize(size)
    @size = size
    @grid = SparseArray.new
    @next_grid = SparseArray.new
    for i in 1..@size
      for j in 1..@size
          @grid[i][j] = "0"
          @next_grid[i][j] = "0"
      end
    end

    # init grid with some cells
    @grid[5][5] = Cell.new(5,5)
    @grid[4][5] = Cell.new(5,5)
    @grid[5][4] = Cell.new(5,5)
    @grid[6][5] = Cell.new(5,5)
end

  # goes through every single cell in generation
  def tick
    @live = 0
    for i in 1..@size
      for j in 1..@size
        count = evolve(i, j)

        if (count < 2 or count > 3) and @grid[i][j].to_s == "1"
          @next_grid[i][j] = 0
        end

        if (count == 2 or count == 3) and @grid[i][j].to_s == "1"
          @next_grid[i][j] = 1
          @live = @live + 1
        end

        if count == 3 and @grid[i][j].to_s == "0"
          @next_grid[i][j] = 1
          @live = @live + 1
        end

      end
    end

    for i in 1..@size
      for j in 1..@size
          @grid[i][j] = @next_grid[i][j]
          @next_grid[i][j] = "0"
      end
    end
  end

  # process specific grid element 
  def evolve(i, j)
    neightbours_count = 0
    
    if @grid[i-1][j].to_s == "1"
      neightbours_count = neightbours_count + 1 
    end
    if @grid[i+1][j].to_s == "1"
      neightbours_count = neightbours_count + 1 
    end
    if @grid[i][j-1].to_s == "1"
       neightbours_count = neightbours_count + 1
    end
    if @grid[i][j+1].to_s == "1"
       neightbours_count = neightbours_count + 1
    end
    if @grid[i-1][j+1].to_s == "1"
       neightbours_count = neightbours_count + 1
    end
    if @grid[i+1][j+1].to_s == "1"
       neightbours_count = neightbours_count + 1
    end
    if @grid[i-1][j-1].to_s == "1"
       neightbours_count = neightbours_count + 1
    end
    if @grid[i+1][j-1].to_s == "1"
       neightbours_count = neightbours_count + 1
    end

    return neightbours_count
  end

  # print current population on grid
  def printgrid
    for i in 1..@size
      for j in 1..@size
          print @grid[i][j]
      end
      puts
    end
  end

end

class Cell
  attr_accessor :x
  attr_accessor :y

  def initialize(x,y)
    @x = x
    @y = y
  end

  def to_s
    return "1"
  end

end

# create grid with size 10x10
e = Environment.new 10

i = 0
# run 10 generations
10.times do |t| 
  puts "generation " << i.to_s
  e.printgrid
  e.tick
  puts "Live Cells: " << e.live.to_s
  puts
  i = i + 1
end
