class InputParser
  def initialize(
    @input : IO::FileDescriptor
  ); end

  def parsed_input
    parsed_input = [] of Array(Set(Char))

    while chunk = @input.gets("\n\n")
      parsed_input << chunk.split.map do |answer_string|
        Set.new(answer_string.each_char)
      end
    end

    parsed_input
  end
end

class CustomsDeclaration
  def initialize(
    @data : Array(Set(Char))
  ); end

  def count
    answers.size
  end

  private def answers
    @data.reduce { |acc, answer_set| acc & answer_set }
  end
end

parsed_input = InputParser.new(STDIN).parsed_input

sum = parsed_input.sum do |custom_data|
  CustomsDeclaration.new(custom_data).count
end

puts sum
