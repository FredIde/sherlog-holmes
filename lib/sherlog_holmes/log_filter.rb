module Sherlog
  class LogFilter

    def initialize
      @filters = []
    end

    def filter(filter = nil, &block)
      @filters << filter if filter
      @filters << block if block
    end

    def level(expression)
      filter do |entry|
        /#{expression}/i.match entry.level
      end
    end

    def category(expression)
      filter do |entry|
        /#{expression}/.match entry.category
      end
    end

    def message(expression)
      filter do |entry|
        /#{expression}/i.match entry.category
      end
    end

    def exception(expression)
      filter do |entry|
        /#{expression}/.match entry.category
      end
    end

    def exceptions
      self << lambda do |entry|
        entry.exception?
      end
    end

    def accept?(entry)
      @filters.all? { |filter| filter.call entry }
    end

  end
end