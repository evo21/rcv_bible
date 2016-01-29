require 'pry'
require 'httparty'
require 'acts_as_scriptural'
require 'spec_helper'

describe RcvBible do
  it 'has a version number' do
    expect(RcvBible::VERSION).not_to be nil
  end
end

describe RcvBible::Extractor do
  describe "#text_of" do
    it 'returns some value--change this to Data Typer later' do
      expect(RcvBible::Extractor.text_of("Psalm 23").class).to eq Hash
    end
    it 'returns full verse list in chapters with more than 30 verses' do
      expect(RcvBible::Extractor.text_of("Psalm 119")["Psalm 119"].count).to eq 176
    end
    it 'returns correct verses when verses are submitted with chapter ref' do
      expect(RcvBible::Extractor.text_of("Psalm 119:1-30")["Psalm 119:1-30"].count).to eq 30
#      expect(RcvBible::Extractor.text_of("Psalm 119:1-35")["Psalm 119:1-35"].count).to eq 35
    end
    it 'returns same book/chapter hash key as the (valid) argument submission' do
      expect(RcvBible::Extractor.text_of("Mat 10").keys.first).to eq "Mat 10"
    end
    it 'returns verse list in chapters with fewer than 30 verses' do
      expect(RcvBible::Extractor.text_of("Psalm 23")["Psalm 23"].count).to eq 6
      expect(RcvBible::Extractor.text_of("1 John 1")["1 John 1"].count).to eq 10
      expect(RcvBible::Extractor.text_of("Jon 1")["Jon 1"].count).to eq 17
    end
    it 'returns verse list from books with only one chapter' do
      expect(RcvBible::Extractor.text_of("Jude")["Jude 1-24"].count).to eq 24
      expect(RcvBible::Extractor.text_of("3 john")['3 John 1-13'].count).to eq 13
    end
    it 'returns error message when passed bad book/chapter arguments' do
      expect(RcvBible::Extractor.text_of("Awesome")["Awesome"]).to eq "Bad Reference"
    end
  end
end
