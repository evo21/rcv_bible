# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "rcv_bible"
  spec.version       = '0.0.4'
  spec.authors       = ["Evan Koch"]
  spec.email         = ["evankoch@gmail.com"]

  spec.summary       = %q{Build text from the Recovery Version from verse/chapter/book submissions.}
  spec.description   = %q{Gateway to API--returns text from the Recovery Version of the New Testament, accessed from the Holy Bible Recovery Version (text-only edition) Copyright 2012 Living Stream Ministry.}
  spec.homepage      = "https://github.com/evo21/rcv_bible"
  spec.license       = "MIT"

  spec.files         = ["lib/rcv_bible.rb",
                        "lib/rcv_bible/one_chapter_book_converter.rb",
                        "lib/rcv_bible/chapter_range_maker.rb",
                        "lib/rcv_bible/reference.rb"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "httparty", "~>0.13.7"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0"
end
