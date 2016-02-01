class RcvBible::ChapterRangeMaker

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
