module Sherlog
  class Parser

    def initialize(patterns = {}, filter = nil)
      @filter = filter
      @patterns = {
          entry: /(?<message>.+)/,
          exception: /^$/,
          stacktrace: /^$/
      }.merge patterns
      @filter ||= filter { |entry| true }
      @listeners = []
    end

    def collect
      result = Result::new
      on_new_entry do |entry|
        result << entry
      end
      result
    end

    def on_new_entry(listener = nil, &block)
      listener ||= block
      @listeners << listener
    end

    def filter(filter = nil, &block)
      @filter = filter if filter
      @filter = Filter::new &block if block
    end

    def patterns(config)
      @patterns.merge! config
    end

    def parse(input)
      entry = nil
      foreach input do |line|
        if @patterns[:entry] =~ line
          entry_data = Hash[Regexp.last_match.names.map { |k| [k.to_sym, Regexp.last_match[k]] }]
          notify entry
          entry = Entry::new entry_data
          entry.raw_content = line.chomp
          entry.exception = Regexp.last_match[:exception] if @patterns[:exception] =~ entry.message
          entry = nil unless @filter.accept? entry
        else
          if entry
            if entry.exception? and @patterns[:stacktrace] =~ line
              entry.stacktrace << line.chomp
            else
              entry << line.chomp
            end
            entry.raw_content << $/ << line.chomp
          end
        end
      end
      notify entry
    end

    private

    def foreach(input, &block)
      if File.exist? input
        IO.foreach input, &block
      else
        input.each_line &block
      end
    end

    def notify(entry)
      return unless entry
      @listeners.each do |listener|
        listener.call entry
      end
    end

  end
end