module Sherlog

  class LogFilter

    def initialize(&block)
      @block = block
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
      filter do |entry|
        entry.level.to_s == expression.to_s
      end
    end

    def self.category(expression)
      filter do |entry|
        if expression.index '*'
          /#{expression.gsub('.', '\.').gsub('*', '.*')}/i.match entry.category
        else
          entry.category.to_s == expression.to_s
        end
      end
    end

    def self.message(expression)
      filter do |entry|
        entry.message.to_s.downcase.index expression.to_s.downcase
      end
    end

    def self.exception(expression)
      filter do |entry|
        /#{expression}/.match entry.category
      end
    end

    def self.exceptions
      filter do |entry|
        entry.exception?
      end
    end

    def self.filter(&block)
      LogFilter::new &block
    end

  end

end