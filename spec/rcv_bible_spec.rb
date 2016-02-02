#require 'pry'
require 'httparty'
require 'spec_helper'
require 'rcv_bible'

describe RcvBible do
  it 'has a version number' do
    expect(RcvBible::VERSION).not_to be nil
  end
end

describe RcvBible::Reference do
  describe "#text_of" do
    it 'returns full verse list in chapters with more than 30 verses' do
      expect(RcvBible::Reference.new("Psalm 119").verses.size).to eq 177 #extra element is the LSM copyright
    end

    it 'returns correct verses when verses are submitted with chapter ref' do
      expect(RcvBible::Reference.new("Psalm 119:1-30").verses.size).to eq 31
    end
    it 'returns verse list in chapters with fewer than 30 verses' do
      expect(RcvBible::Reference.new("Psalm 23").verses.size).to eq 7
      expect(RcvBible::Reference.new("1 John 1").verses.size).to eq 11
      expect(RcvBible::Reference.new("Jon 1").verses.size).to eq 18
    end
    it 'returns verse list from books with only one chapter' do
      expect(RcvBible::Reference.new("Jude").verses.size).to eq 25
      expect(RcvBible::Reference.new("3 john").verses.size).to eq 14
    end
    it 'returns error message when passed bad book/chapter arguments' do
      expect(RcvBible::Reference.new("Awesome").error).to eq "Bad Reference"
    end
    it 'returns a valid response regardless of single, double, or [no] quotes in submission' do
      expect(RcvBible::Reference.new("Matt 1").verses.size).to eq 26
      expect(RcvBible::Reference.new('Matt 1').verses.size).to eq 26
      expect(RcvBible::Reference.new("1 Kings 1").verses.size).to eq 54
      expect(RcvBible::Reference.new('1 Kings 1').verses.size).to eq 54
      expect(RcvBible::Reference.new('2 John 1').verses.size).to eq 14
      expect(RcvBible::Reference.new("2 John 1").verses.size).to eq 14
    end
  end
end
