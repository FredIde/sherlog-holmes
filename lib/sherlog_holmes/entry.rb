#                         The MIT License
#
# Copyright (c) 2015 Marcelo "Ataxexe" Guimarães <ataxexe@devnull.tools>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

module Sherlog
  class Entry

    attr_accessor :time, :level, :category, :origin, :message, :exceptions, :stacktrace, :raw_content

    def initialize(params = {})
      @time = params[:time]
      @level = params[:level]
      @category = params[:category]
      @origin = params[:origin]
      @message = params[:message]
      @exceptions = [params[:exception]] if params[:exception]
      @exceptions ||= params[:exceptions]
      @exceptions ||= []
      @stacktrace = []
    end

    def exception?
      !@exceptions.empty?
    end

    def exception
      @exceptions.first
    end

    def <<(line)
      @message << $/ << line
    end

    def to_s
      format = []
      params = []
      format << '%s' && params << time if time
      format << '%s' && params << level.to_s.ljust(7) if level
      format << '[%s]' && params << category if category
      format << '(%s)' && params << origin if origin
      format << '%s' && params << message if message
      string = format.join(' ') % params
      ([string] + @stacktrace).join($/)
    end

  end
end