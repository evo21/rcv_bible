require 'pry'
require 'httparty'
require 'acts_as_scriptural'
require 'spec_helper'

describe RcvBible do
  it 'has a version number' do
    expect(RcvBible::VERSION).not_to be nil
  end

  it 'returns some data' do
    expect(RcvBible::Extractor.text_of("Psalm 23")).not_to be nil
  end
end
