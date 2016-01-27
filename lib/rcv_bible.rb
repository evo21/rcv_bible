require "acts_as_scriptural"
require "httparty"

class RcvBible

  VERSION = "0.0.1"

class RcvBible::Extractor

  def initialize(input_string)
    @input_string = input_string
    @parsed_request = parse_input_string(@input_string)

  end

  def self.text_of(input_string)
    self.new(input_string).text_of
  end

  def text_of
    response = HTTParty.get("https://api.lsm.org/recver.php?String=#{@parsed_request}&Out=json")
    return response
  end

  def parse_input_string(input_string)
    @input_string # this is temporary place holder, eventually will need to parse
                  # input_string to return a string form acceptable to LSM API
  end
end





end
