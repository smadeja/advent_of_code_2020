class InputParser
  @parsed_input : Array(Int32)?

  def initialize(input : IO::FileDescriptor)
    @input = input
  end

  def parsed_input : Array(Int32)
    @parsed_input ||= parse
  end

  private def parse : Array(Int32)
    parsed_input = [] of Int32

    @input.each_line do |line|
      parsed_input << line.to_i
    end

    parsed_input
  end
end

class ExpenseReport
  def initialize(expenses : Array(Int32))
    @expenses = expenses
  end

  def find_triple_by_sum(sum : Int32) : Tuple(Int32, Int32, Int32)?
    @expenses.each_with_index do |first_expense, first_offset|
      second_index = first_offset + 1

      while second_index < @expenses.size
        second_expense = @expenses[second_index]
        third_index = second_index + 1

        while third_index < @expenses.size
          third_expense = @expenses[third_index]

          if first_expense + second_expense + third_expense == sum
            return {first_expense, second_expense, third_expense}
          end

          third_index = third_index + 1
        end

        second_index = second_index + 1
      end
    end
  end
end

input = InputParser.new(STDIN).parsed_input
matching_pair = ExpenseReport.new(input).find_triple_by_sum(2020)

if matching_pair
  puts matching_pair.product
end
