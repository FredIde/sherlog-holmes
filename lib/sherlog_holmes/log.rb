module Sherlog
  class Log

    attr_reader :entries, :exceptions

    def initialize
      @entries = []
      @exceptions = []
      @exceptions_map = {}
      @entry_map = {}
    end

    def <<(entry)
      @entries << entry
      if entry.exception?
        @exceptions << entry
        @exceptions_map[entry.exception] ||= []
        @exceptions_map[entry.exception] << entry
      end
      @entry_map[entry.level] ||= {}
      @entry_map[entry.level][entry.category] ||= []

      @entry_map[entry.level][entry.category] << entry
    end

    def size
      @entries.size
    end

  end
end