class InputParser
  def initialize(
    @input : IO::FileDescriptor
  ); end

  def parsed_input
    parsed_input = [] of String

    while chunk = @input.gets("\n\n")
      parsed_input << chunk
    end

    parsed_input
  end
end

class Passport
  ATTR_REGEX = /(?<name>.+):(?<value>.+)/

  def self.parse(input)
    attrs = {} of String => String

    input.split.each do |attr|
      parsed_attr = ATTR_REGEX.match(attr).not_nil!
      attrs[parsed_attr["name"]] = parsed_attr["value"]
    end

    new(attrs)
  end

  def initialize(
    @attrs : Hash(String, String)
  ); end

  def valid?
    ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"].all? do |attr|
      @attrs.has_key?(attr)
    end
  end
end

parsed_input = InputParser.new(STDIN).parsed_input
puts parsed_input.count { |chunk| Passport.parse(chunk).valid? }
