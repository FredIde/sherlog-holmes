module Sherlog
  class LogFile

    attr_reader :entries, :file

    def initialize(logfile, filter, params = {})
      @file = logfile
      @params = {
          stacktrace: true
      }.merge params
      @filter = filter
      @entries = []
      @exceptions = {}
      @map = {}
    end

    def read
      #         time          level    category origin      message
      regexp = /([0-9,.:]+)\s+(\w+)\s+\[(\S+)\]\s(\(\S+\))?\s?(.+)/
      entry = nil
      IO.foreach(file) do |line|
        data = regexp.match line.chomp
        if data
          entry = LogEntry::new time: data[1],
                                level: data[2],
                                category: data[3],
                                origin: data[4].to_s[1..-1],
                                message: data[5]
          if @filter.accept? entry
            @entries << entry
            if entry.exception?
              @exceptions[entry.exception_class] ||= []
              @exceptions[entry.exception_class] << entry
            end
            @map[entry.level] ||= {}
            @map[entry.level][entry.category] ||= []

            @map[entry.level][entry.category] << entry
          end
        else
          entry << line.chomp if entry and @params[:stacktrace]
        end
      end
    end

    def print_info(target = $stdout)
      @map.each do |level, categories|
        table = Yummi::Table::new
        table.title = 'Entries for %s level by category' % level
        table.header = %w(Category Count)
        table.colorize :category, with: 'bold.white'
        table.colorize :count, with: 'magenta'
        categories.sort_by { |k, v| v.size }.each do |category, entries|
          table << [category, entries.size]
        end
        table.print target
        target.print $/
      end
    end

    def print_entries(target = $stdout)
      @entries.each do |entry|
        target.print entry.to_s + $/
      end
    end

    def print_exception_entries(target = $stdout)
      @entries.each do |entry|
        target.print entry.to_s + $/ if entry.exception?
      end
    end

    def print_exception_info(target = $stdout)
      unless @exceptions.empty?
        table = Yummi::Table::new
        table.title = 'Exceptions by class'
        table.header = %w(Class Count)
        table.colorize :class, with: 'bold.white'
        table.colorize :count, with: 'magenta'
        @exceptions.sort_by { |k, v| v.size }.each do |exception_class, entries|
          table << [exception_class, entries.size]
        end
        table.print target
      end
    end

  end
end