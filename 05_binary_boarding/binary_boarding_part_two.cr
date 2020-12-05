class InputParser
  private getter input

  def initialize(
    @input : IO::FileDescriptor
  ); end

  def parsed_input
    parsed_input = [] of String

    input.each_line do |line|
      parsed_input << line
    end

    parsed_input
  end
end

class SeatLocator
  private getter boarding_pass

  def initialize(
    @boarding_pass : String
  ); end

  def row_number
    binarised_row_code.to_i(2)
  end

  def column_number
    binarised_column_code.to_i(2)
  end

  def seat_id
    row_number * 8 + column_number
  end

  private def row_code
    boarding_pass[0..6]
  end

  private def column_code
    boarding_pass[7..9]
  end

  private def binarised_row_code
    row_code.gsub({'F' => '0', 'B' => '1'})
  end

  private def binarised_column_code
    column_code.gsub({'L' => '0', 'R' => '1'})
  end
end

parsed_input = InputParser.new(STDIN).parsed_input

sorted_seat_locators = parsed_input.map do |boarding_pass|
  SeatLocator.new(boarding_pass)
end.sort_by(&.seat_id)

my_seat_id = sorted_seat_locators.each_cons_pair do |lower_sl, higher_sl|
  suspected_seat_id = lower_sl.seat_id + 1

  if suspected_seat_id != higher_sl.seat_id
    break suspected_seat_id
  end
end

puts my_seat_id
