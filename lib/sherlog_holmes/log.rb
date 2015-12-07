module Sherlog
  class Log

    def initialize
      @entries = []
    end

    def <<(entry)
      @entries << entry
      self
    end

    def entries(params = {})
      return @entries.find_all { |entry| params[:filter].accept? entry } if params[:filter]
      @entries
    end

    def exceptions
      entries filter: Filter::exceptions
    end

    def size
      @entries.size
    end

  end
end