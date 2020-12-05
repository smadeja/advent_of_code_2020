class InputParser
  def initialize(
    @input : IO::FileDescriptor
  ); end

  def parsed_input
    parsed_input = [] of Array(Char)

    @input.each_line do |line|
      parsed_input << line.chars
    end

    parsed_input
  end
end

class Map
  private getter data

  def initialize(
    @data : Array(Array(Char))
  ); end

  def at(location)
    data[data_column(location)][data_row(location)]
  end

  def in_bounds?(location)
    location.last < row_count
  end

  private def column_count
    data.first.size
  end

  private def row_count
    data.size
  end

  private def data_column(location)
    location.last
  end

  private def data_row(location)
    location.first % column_count
  end
end

class Toboggan
  getter location

  private getter map
  private getter pattern

  def initialize(
    @map : Map,
    @pattern : {Int32, Int32},
    @location : {Int32, Int32} = {0, 0}
  ); end

  def step
    @location = {location.first + pattern.first, location.last + pattern.last}
  end

  def over_tree?
    map.at(location) == '#'
  end

  def within_map?
    map.in_bounds?(location)
  end
end

parsed_input = InputParser.new(STDIN).parsed_input
map = Map.new(parsed_input)

tree_counts = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}].map do |pattern|
  toboggan = Toboggan.new(map, pattern)
  tree_count = 0

  while toboggan.within_map?
    if toboggan.over_tree?
      tree_count += 1
    end

    toboggan.step
  end

  tree_count
end

puts tree_counts.product(1_i64)
