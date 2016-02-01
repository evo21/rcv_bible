require "acts_as_scriptural"
require "httparty"

class RcvBible

  VERSION = "0.0.1"

class RcvBible::Reference

  def initialize(reference)
    @reference = reference
    @parsed_request = RcvBible::OneChapterBookConverter.adjust_reference(reference)
    @response = HTTParty.get("https://api.lsm.org/recver.php?String=#{@parsed_request}").to_h
    @message = @response["request"]["message"]
  end

  def self.text_of(reference)
    self.new(reference).text_of
  end

  def reference_chapter

  end

  def message
    @response["request"]["message"]
  end

  def short_chapter_verses_array
    @short_chapter_verses_array ||= @response["request"]["verses"]["verse"]
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

#  def required_iterations
#    (chapter_verse_count / 30)
#  end
#
#  def verse_ranges
#    result = []
#    0.upto(required_iterations) do |vr|
#      result << [(vr * 30) +1, (vr * 30) + 30]
#    end
#    result.last.last = chapter_verse_count
#    result
#  end

  def text_of
    if completed_response?
      return { @reference => short_chapter_verses_array }
    elsif invalid_reference?
      return { @reference => @message["Bad Reference"] }
    else
      long_chapter_verses_array = []
      RcvBible::ChapterRangeMaker.new(chapter_verse_count).verse_ranges.each do |vr|
      verses_chunk = HTTParty.get(
                                  "https://api.lsm.org/recver.php?String=#{@reference}: #{vr.first}-#{vr.last}").
                                  to_h["request"]["verses"]["verse"]
        long_chapter_verses_array << verses_chunk
      end
      return { @reference => long_chapter_verses_array.flatten }
    end
  end
end

class ChapterRangeMaker

  VERSELIMIT = 30

  def initialize(num_verses)
    @num_verses = num_verses
  end

  def verse_ranges
    result = []
    1.step(@num_verses,VERSELIMIT) do |i|
      result << [i, last_verse_in_range(i)]
    end
    result
  end

  def last_verse_in_range(first_verse_in_range)
    last_verse_number = first_verse_in_range + VERSELIMIT - 1
    if last_verse_number > @num_verses
      @num_verses
    else
      last_verse_number
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
