require 'pry'
require 'httparty'
require 'acts_as_scriptural'
require 'spec_helper'

describe RcvBible do
  it 'has a version number' do
    expect(RcvBible::VERSION).not_to be nil
  end

  it 'returns some data' do
    expect(RcvBible.new("Psalm 23").text_of).not_to be nil
  end
end
