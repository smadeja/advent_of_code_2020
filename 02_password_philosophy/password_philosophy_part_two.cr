class InputParser
  LINE_REGEX =
    /\A(?<position_one>\d+)-(?<position_two>\d+) (?<letter>\w): (?<password>\w+)\z/

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
  private getter positions

  def initialize(
    @password : String,
    @letter : Char,
    @positions : {Int32, Int32}
  ); end

  def valid?
    positioned_letter_count == 1
  end

  private def positioned_letters
    positioned_letters = [] of Char

    positions.each do |position|
      positioned_letters << password.char_at(position)
    end

    positioned_letters
  end

  private def positioned_letter_count
    positioned_letters.count(&.==(letter))
  end
end

parsed_input = InputParser.new(STDIN).parsed_input

password_checkas = parsed_input.map do |match_data|
  password = match_data["password"]
  letter = match_data["letter"].char_at(0)
  position_one = match_data["position_one"].to_i - 1
  position_two = match_data["position_two"].to_i - 1

  PasswordChecka.new(password, letter, {position_one, position_two})
end

puts password_checkas.count(&.valid?)
