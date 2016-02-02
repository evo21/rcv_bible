class RcvBible::Reference

  def initialize(reference)
    @reference = reference
    @parsed_request = RcvBible::OneChapterBookConverter.adjust_reference(reference)
    initial_request
    verse_requests
  end

  def initial_request
    @response = HTTParty.get("https://api.lsm.org/recver.php?String=#{@parsed_request}").to_h
  end

  def error
    @error
  end

  def copyright
    [{copyright: @response["request"]["copyright"] }]
  end

  def verses
    @verses + copyright
  end

  def message
    @message ||= @response["request"]["message"]
  end

  def short_chapter_verses_array
    @short_chapter_verses_array ||= @response["request"]["verses"]["verse"]
  end

  def completed_response?
    message == "\t"
  end

  def invalid_reference?
    message["Bad Reference"]
  end

  def chapter_verse_count
    message.sub(/.*?requested /, '').split.first.to_i
  end

  def verse_requests
    if completed_response?
      @verses = short_chapter_verses_array
    elsif invalid_reference?
      @verses = []
      @error = "Bad Reference"
    else
      long_chapter_verses_array = []
      RcvBible::ChapterRangeMaker.new(chapter_verse_count).verse_ranges.each do |vr|
        verses_chunk = HTTParty.get(
                                  "https://api.lsm.org/recver.php?
                                  String=#{@reference}: #{vr.first}-#{vr.last}").
                                  to_h["request"]["verses"]["verse"]
        long_chapter_verses_array << verses_chunk
      end
      @verses = long_chapter_verses_array.flatten
    end
  end
end
