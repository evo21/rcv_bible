require 'pry'
require 'httparty'
require 'acts_as_scriptural'
require 'spec_helper'

describe RcvBible do
  it 'has a version number' do
    expect(RcvBible::VERSION).not_to be nil
  end
end

describe RcvBible::Reference do
  describe "#text_of" do
    it "foo" do
    end
    it 'returns some value' do
      expect(RcvBible::Reference.text_of("Psalm 23")).not_to be nil
      expect(RcvBible::Reference.text_of("Matt 1").class).to eq Hash
    end
    it 'returns full verse list in chapters with more than 30 verses' do
      expect(RcvBible::Reference.text_of("Psalm 119")["Psalm 119"].count).to eq 176
    end
    it 'returns correct verses when verses are submitted with chapter ref' do
      expect(RcvBible::Reference.text_of("Psalm 119:1-30")["Psalm 119:1-30"].count).to eq 30
#      expect(RcvBible::Reference.text_of("Psalm 119:1-35")["Psalm 119:1-35"].count).to eq 35
    end
    it 'returns same book/chapter hash key as the (valid) argument submission' do
      expect(RcvBible::Reference.text_of("Mat 10").keys.first).to eq "Mat 10"
    end
    it 'returns verse list in chapters with fewer than 30 verses' do
      expect(RcvBible::Reference.text_of("Psalm 23")["Psalm 23"].count).to eq 6
      expect(RcvBible::Reference.text_of("1 John 1")["1 John 1"].count).to eq 10
      expect(RcvBible::Reference.text_of("Jon 1")["Jon 1"].count).to eq 17
    end
    it 'returns verse list from books with only one chapter' do
      expect(RcvBible::Reference.text_of("Jude")["Jude"].count).to eq 24
      expect(RcvBible::Reference.text_of("3 john")['3 john'].count).to eq 13
    end
    it 'returns error message when passed bad book/chapter arguments' do
      expect(RcvBible::Reference.text_of("Awesome")["Awesome"]).to eq "Bad Reference"
    end
    it 'returns a valid response regardless of single, double, or [no] quotes in submission' do
      expect(RcvBible::Reference.text_of("Matt 1")["Matt 1"].count).to eq 25
      expect(RcvBible::Reference.text_of('Matt 1')["Matt 1"].count).to eq 25
      expect(RcvBible::Reference.text_of("1 Kings 1")["1 Kings 1"].count).to eq 53
      expect(RcvBible::Reference.text_of('1 Kings 1')["1 Kings 1"].count).to eq 53
      expect(RcvBible::Reference.text_of('2 John 1')["2 John 1"].count).to eq 13
      expect(RcvBible::Reference.text_of("2 John 1")["2 John 1"].count).to eq 13
    end
  end
end
