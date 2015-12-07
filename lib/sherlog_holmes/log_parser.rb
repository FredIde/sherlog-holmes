module Sherlog
  class LogParser

    def initialize(config, filter = nil)
      @config = config
      @config[:patterns][:exception] ||= /^$/
      @config[:patterns][:stacktrace] ||= /^$/

      @filter = filter
      @filter ||= LogFilter::new { |entry| true }
    end

    def parse(input)
      result = Log::new
      entry = nil
      foreach input do |line|
        if @config[:patterns][:entry] =~ line
          entry_data = Hash[Regexp.last_match.names.map { |k| [k.to_sym, Regexp.last_match[k]] }]
          entry = LogEntry::new entry_data
          entry.exception =
              Regexp.last_match[:exception] if @config[:patterns][:exception] =~ entry.message
          if @filter.accept? entry
            result << entry
          end
        else
          if entry
            if entry.exception? and @config[:patterns][:stacktrace] =~ line
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