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

  class CountListener
    attr_reader :level, :category, :origin, :exception

    def initialize
      @level = {}
      @category = {}
      @origin = {}
      @exception = {}
    end

    def call(entry)
      initialize_counters entry
      count entry
    end

    private

    def initialize_counters(entry)
      @level[entry.level] ||= 0 if entry.level
      @category[entry.category] ||= 0 if entry.category
      @origin[entry.origin] ||= 0 if entry.origin
      entry.exceptions.each do |exception|
        @exception[exception] ||= 0
      end
    end

    def count(entry)
      @level[entry.level] += 1 if entry.level
      @category[entry.category] += 1 if entry.category
      @origin[entry.origin] += 1 if entry.origin
      entry.exceptions.each do |exception|
        @exception[exception] += 1
      end
    end

  end

end