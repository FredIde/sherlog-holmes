module Sherlog

  class Filter

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
      other_filter ||= Filter::new &other_block
      Filter::new do |entry|
        self.accept?(entry) && other_filter.accept?(entry)
      end
    end

    def or(other_filter = nil, &other_block)
      other_filter ||= Filter::new &other_block
      Filter::new do |entry|
        self.accept?(entry) || other_filter.accept?(entry)
      end
    end

    def self.expression(expression)
      Filter::new do |object|
        wildcard_at_start = expression.start_with? '*'
        wildcard_at_end = expression.end_with? '*'
        if wildcard_at_start and wildcard_at_end
          object.to_s.index expression[1...-1]
        elsif wildcard_at_start
          object.to_s.end_with? expression[1..-1]
        elsif wildcard_at_end
          object.to_s.start_with? expression[0...-1]
        else
          object.to_s == expression.to_s
        end
      end
    end

    def self.level(expression)
      Filter::new do |entry|
        entry.level.to_s == expression.to_s
      end
    end

    def self.category(expression)
      Filter::new do |entry|
        expression(expression).accept? entry.category
      end
    end

    def self.origin(expression)
      Filter::new do |entry|
        expression(expression).accept? entry.origin
      end
    end

    def self.message(expression)
      Filter::new do |entry|
        expression(expression).accept? entry.message
      end
    end

    def self.exception(expression)
      Filter::new do |entry|
        expression(expression).accept? entry.exception
      end
    end

    def self.exceptions
      Filter::new do |entry|
        entry.exception?
      end
    end

  end

end