class InputParser
  LINE_REGEX =
    /\A(?<min_count>\d+)-(?<max_count>\d+) (?<letter>\w): (?<password>\w+)\z/

  def initialize(
    @input : IO::FileDescriptor
  ); end

  def parsed_input
    parsed_input = [] of Regex::MatchData

    @input.each_line do |line|
      parsed_input << parsed_line(line)
    end

    parsed_input
  end

  private def parsed_line(line)
    LINE_REGEX.match(line).not_nil!
  end
end

class PasswordChecka
  private getter letter
  private getter password
  private getter range

  def initialize(
    @password : String,
    @letter : Char,
    @range : Range(Int32, Int32)
  ); end

  def valid?
    letter_count.in?(range)
  end

  private def letter_count
    password.count(&.==(letter))
  end
end

parsed_input = InputParser.new(STDIN).parsed_input

password_checkas = parsed_input.map do |match_data|
  password = match_data["password"]
  letter = match_data["letter"].char_at(0)
  min_count = match_data["min_count"].to_i
  max_count = match_data["max_count"].to_i

  PasswordChecka.new(password, letter, min_count..max_count)
end

puts password_checkas.count(&.valid?)
