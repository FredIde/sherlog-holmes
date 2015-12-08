require 'yummi'
require 'yaml'

require_relative 'sherlog_holmes/version'
require_relative 'sherlog_holmes/result'
require_relative 'sherlog_holmes/entry'
require_relative 'sherlog_holmes/filter'
require_relative 'sherlog_holmes/parser'

module Sherlog

  PATTERNS = {}

  def self.load_patterns(file)
    patterns = YAML::load_file file
    patterns.each do |id, config|
      PATTERNS[id.to_sym] = {
          entry: Regexp::new(config['entry']),
          exception: Regexp::new(config['exception']),
          stacktrace: Regexp::new(config['stacktrace'])
      }
    end
  end

  Dir['%s/../conf/patterns/*.yml' % File.dirname(__FILE__)].each do |file|
    load_patterns file
  end

  Dir['%s/.sherlog/patterns/*.yml' % ENV['HOME']].each do |file|
    load_patterns file
  end

  def self.parser(pattern_id)
    Parser::new PATTERNS[pattern_id.to_sym]
  end

  def self.loaded_patterns
    PATTERNS
  end

end
