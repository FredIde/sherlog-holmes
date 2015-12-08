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
          entry: config['entry'],
          exception: config['exception'],
          stacktrace: config['stacktrace']
      }
    end
  end

  Dir[File.dirname(__FILE__) + '/../conf/patterns/*.yml'].each do |file|
    load_patterns file
  end

  def self.parser(pattern_id)
    Parser::new PATTERNS[pattern_id.to_sym]
  end
end
