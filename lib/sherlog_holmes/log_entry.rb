module Sherlog
  class LogEntry

    attr_accessor :time, :level, :category, :origin, :message, :exception, :stacktrace

    def initialize(params = {})
      @time = params[:time]
      @level = params[:level]
      @category = params[:category]
      @origin = params[:origin]
      @message = params[:message]
      @exception = params[:exception]
      @stacktrace = []
    end

    def exception?
      !@exception.nil?
    end

    def <<(line)
      @message << $/ << line
    end

    def to_s
      format = []
      params = []
      format << '%s' && params << time if time
      format << '|%s|' && params << level.to_s.ljust(7) if level
      format << '[%s]' && params << category if category
      format << '(%s)' && params << origin if origin
      format << '%s' && params << message if message
      string = format.join(' ') % params
      ([string] + @stacktrace).join($/)
    end

  end
end