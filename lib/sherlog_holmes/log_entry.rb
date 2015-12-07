module Sherlog
  class LogEntry

    attr_accessor :time, :level, :category, :origin, :message, :exception_class

    def initialize(params = {})
      @time = params[:time]
      @level = params[:level]
      @category = params[:category]
      @origin = params[:origin]
      @message = params[:message]
      @exception_class = params[:exception_class]
      @stacktrace = []
    end

    def exception?
      !@exception_class.nil?
    end

    def <<(line)
      @stacktrace << line
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