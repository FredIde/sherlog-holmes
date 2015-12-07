module Sherlog
  class Parser

    def initialize
      @patterns = {
          entry: /(?<message>.+)/,
          exception: /^$/,
          stacktrace: /^$/
      }
      @filter = filter { |entry| true }
    end

    def filter(filter = nil, &block)
      @filter = filter if filter
      @filter = Filter::new &block if block
    end

    def patterns(config)
      @patterns.merge! config
    end

    def parse(input)
      result = Log::new
      entry = nil
      foreach input do |line|
        if @patterns[:entry] =~ line
          entry_data = Hash[Regexp.last_match.names.map { |k| [k.to_sym, Regexp.last_match[k]] }]
          entry = Entry::new entry_data
          entry.exception =
              Regexp.last_match[:exception] if @patterns[:exception] =~ entry.message
          if @filter.accept? entry
            result << entry
          end
        else
          if entry
            if entry.exception? and @patterns[:stacktrace] =~ line
              entry.stacktrace << line.chomp
            else
              entry << line.chomp
            end
          end
        end
      end
      result
    end

    private

    def foreach(input, &block)
      if File.exist? input
        IO.foreach(file) &block
      else
        input.each_line &block
      end
    end

  end
end