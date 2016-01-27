require 'pry'
require 'httparty'
require 'acts_as_scriptural'
require 'spec_helper'

describe RcvBible do
  it 'has a version number' do
    expect(RcvBible::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
