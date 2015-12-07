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
      string = if origin
                 '%s %s [%s] (%s) %s' % [time, level.ljust(7), category, origin, message]
               else
                 '%s %s [%s] %s' % [time, level.ljust(7), category, message]
               end
      ([string] + @stacktrace).join($/)
    end

  end
end