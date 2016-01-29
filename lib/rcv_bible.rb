require "acts_as_scriptural"
require "httparty"

class RcvBible

  VERSION = "0.0.1"

  SINGLES = { "obadiah" => "Oba 1-21",
              "obadiah 1" => "Oba 1-21",
              "obadiah 1:1-21" => "Oba 1-21",
              "philemon" => "Philem 1-25",
              "philemon 1" => "Philem 1-25",
              "philemon 1:1-25" => "Philem 1-25",
              "2 john" => '2 John 1-13',
              "2 john 1" => '2 John 1-13',
              "2 john 1:1-13" => '2 John 1-13',
              "3 john" => '3 John 1-13',
              "3 john 1" => '3 John 1-13',
              "3 john 1:1-13" => '3 John 1-13',
              "jude" => "Jude 1-24",
              "jude 1" => "Jude 1-24",
              "jude 1:1-24" => "Jude 1-24"
            }

class RcvBible::Extractor

  def initialize(input_string)
    @input_string = input_string
    @parsed_request = parse_input_string

  end

  def self.text_of(input_string)  # RcvBible::Extractor('Book Chapter:Verses')
    self.new(input_string).text_of
  end

  def text_of
    initial_hash = HTTParty.get("https://api.lsm.org/recver.php?String=#{@parsed_request}").to_h
    input_string = initial_hash["request"]["inputstring"]
    initial_verses_array = initial_hash["request"]["verses"]["verse"]
    message = initial_hash["request"]["message"]
    if message == "\t"  #keeping hash response instead of JSON response, b/c of API error with their JSON encoding, which gives response unrecognized by rubyJSON.
      return { input_string => initial_verses_array }
    elsif message["Bad Reference"]
      return { input_string => message["Bad Reference"] }
    else
      chapter_verse_count = message.sub(/.*?requested /, '').split.first.to_i
      iterations = chapter_verse_count / 30
      verses_array = []
      0.upto(iterations) do |x|
        if x == iterations
          additional_verses = HTTParty.get("https://api.lsm.org/recver.php?String=#{input_string}: #{(30 * x) + 1}-#{chapter_verse_count}").to_h["request"]["verses"]["verse"]
          verses_array << additional_verses
          return { input_string => verses_array.flatten }
        else
          additional_verses = HTTParty.get("https://api.lsm.org/recver.php?String=#{input_string}: #{x * 30 + 1}-#{30 * (x + 1)}").to_h["request"]["verses"]["verse"]
          verses_array << additional_verses
        end
      end
    end
  end


  def parse_input_string
    @input_string.gsub('"', "%27")
    if SINGLES[@input_string.downcase]
      SINGLES[@input_string.downcase]
                    # this is temporary place holder, eventually this
                    # will need to parse input-string to return a 
                    # string form acceptable to LSM API for all requests
    else
      @input_string
    end
  end

  private
    def more_than_thirty_verses?
      @verses.size > 30
    end

end
end
