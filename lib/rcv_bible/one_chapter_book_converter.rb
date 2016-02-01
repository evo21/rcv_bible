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
