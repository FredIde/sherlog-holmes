module Sherlog

  class LogFilter

    def initialize(&block)
      @block = block
    end

    def call(object)
      accept? object
    end

    def accept?(object)
      @block.call object
    end

    def and(other_filter = nil, &other_block)
      other_filter ||= LogFilter::new &other_block
      LogFilter::new do |entry|
        self.accept?(entry) && other_filter.accept?(entry)
      end
    end

    def or(other_filter = nil, &other_block)
      other_filter ||= LogFilter::new &other_block
      LogFilter::new do |entry|
        self.accept?(entry) || other_filter.accept?(entry)
      end
    end

    def self.level(expression)
      LogFilter::new do |entry|
        entry.level.to_s == expression.to_s
      end
    end

    def self.category(expression)
      LogFilter::new do |entry|
        if expression.start_with? '*'
          entry.category.to_s.end_with? expression[1..-1]
        elsif expression.end_with? '*'
          entry.category.to_s.start_with? expression[0...-1]
        else
          entry.category.to_s == expression.to_s
        end
      end
    end

    def self.message(expression)
      LogFilter::new do |entry|
        entry.message.to_s.downcase.index expression.to_s.downcase
      end
    end

    def self.exception(expression)
      LogFilter::new do |entry|
        if expression.start_with? '*'
          entry.exception.to_s.end_with? expression[1..-1]
        elsif expression.end_with? '*'
          entry.exception.to_s.start_with? expression[0...-1]
        else
          entry.exception.to_s == expression.to_s
        end
      end
    end

    def self.exceptions
      LogFilter::new do |entry|
        entry.exception?
      end
    end

  end

end