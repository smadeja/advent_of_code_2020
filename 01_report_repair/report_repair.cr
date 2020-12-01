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

  def find_pair_by_sum(sum : Int32) : Tuple(Int32, Int32)?
    @expenses.each_with_index do |base_expense, base_offset|
      index = base_offset + 1

      while index < @expenses.size
        current_expense = @expenses[index]

        if base_expense + current_expense == sum
          return {base_expense, current_expense}
        end

        index = index + 1
      end
    end
  end
end

input = InputParser.new(STDIN).parsed_input
matching_pair = ExpenseReport.new(input).find_pair_by_sum(2020)

if matching_pair
  puts matching_pair.product
end
