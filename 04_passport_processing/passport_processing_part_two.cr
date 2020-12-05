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
    byr_valid? &&
      iyr_valid? &&
      eyr_valid? &&
      hgt_valid? &&
      hcl_valid? &&
      ecl_valid? &&
      pid_valid?
  end

  def byr_valid?
    if (byr = @attrs["byr"]?) && byr.match(/\A\d{4}\z/)
      byr.to_i.in?(1920..2002)
    else
      false
    end
  end

  def iyr_valid?
    if (iyr = @attrs["iyr"]?) && iyr.match(/\A\d{4}\z/)
      iyr.to_i.in?(2010..2020)
    else
      false
    end
  end

  def eyr_valid?
    if (eyr = @attrs["eyr"]?) && eyr.match(/\A\d{4}\z/)
      eyr.to_i.in?(2020..2030)
    else
      false
    end
  end

  def hgt_valid?
    if (hgt = @attrs["hgt"]?) &&
      (parsed_hgt = /\A(?<value>\d+)(?<unit>cm|in)\z/.match(hgt))

      value = parsed_hgt["value"].to_i

      case parsed_hgt["unit"]
      when "cm"
        value.in?(150..193)
      when "in"
        value.in?(59..76)
      end
    else
      false
    end
  end

  def hcl_valid?
    if hcl = @attrs["hcl"]?
      hcl.match(/\A#[0-9a-f]{6}\z/)
    else
      false
    end
  end

  def ecl_valid?
    if ecl = @attrs["ecl"]?
      ecl.match(/\Aamb|blu|brn|gry|grn|hzl|oth\z/)
    else
      false
    end
  end

  def pid_valid?
    if pid = @attrs["pid"]?
      pid.match(/\A\d{9}\z/)
    else
      false
    end
  end
end

parsed_input = InputParser.new(STDIN).parsed_input
puts parsed_input.count { |chunk| Passport.parse(chunk).valid? }
