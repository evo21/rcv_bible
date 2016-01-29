require "acts_as_scriptural"
require "httparty"




class RcvBible

  VERSION = "0.0.1"


class RcvBible::Reference

  def initialize(reference)
    @reference = reference
    @parsed_request = RcvBible::OneChapterBookConverter.adjust_reference(reference)
    @response = HTTParty.get("https://api.lsm.org/recver.php?String=#{@parsed_request}").to_h
  end

  def self.text_of(reference)
    self.new(reference).text_of
  end

  def reference_chapter

  end

  def message
    @response["request"]["message"]
  end

  def verses_array
    @verses_array ||= @response["request"]["verses"]["verse"]
  end

  def completed_response?
    @message == "\t"
  end

  def invalid_reference?
    @message["Bad Reference"]
  end

  def chapter_verse_count
    @message.sub(/.*?requested /, '').split.first.to_i
  end

  def required_iterations
    (chapter_verse_count / 30)
  end

  def verse_ranges
    result = []
    0.upto(required_iterations) do |vr|
      result << [(vr * 30) +1, (vr * 30) + 30]
    end
    result.last.last = chapter_verse_count
    result
  end

  def text_of
    if completed_response?
      return { input_string => verses_array }
    elsif invalid_reference?
      return { input_string => message["Bad Reference"] }
    else
      verses_array = []
      verse_ranges.each do |range|
        additional_verses = HTTParty.get("https://api.lsm.org/recver.php?String=#{@reference}: #{range.first}-#{range.last}").to_h["request"]["verses"]["verse"]
        verses_array << additional_verses
      end
      return { input_string => verses_array.flatten }
    end
  end


end



class RcvBible::OneChapterBookConverter

  OCB_REFERENCES = { "obadiah" => "Oba 1-21",
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

  def self.adjust_reference(reference)
    self.new(reference).adjust_reference
  end

  def initialize(reference)
    @reference = reference
  end

  def adjust_reference
    if OCB_REFERENCES[@reference.downcase]
      OCB_REFERENCES[@reference.downcase]
    else
      @reference
    end
  end

end
end
