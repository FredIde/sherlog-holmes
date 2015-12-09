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

  class Filter

    def initialize(&block)
      @block = block
    end

    def call(object)
      accept? object
    end

    def accept?(object)
      @block.call object
    end

    def and(other_filter = nil, &other_block)
      other_filter ||= Filter::new &other_block
      Filter::new do |entry|
        self.accept?(entry) && other_filter.accept?(entry)
      end
    end

    def or(other_filter = nil, &other_block)
      other_filter ||= Filter::new &other_block
      Filter::new do |entry|
        self.accept?(entry) || other_filter.accept?(entry)
      end
    end

    def negate
      Filter::new do |entry|
        !self.accept?(entry)
      end
    end

    def self.expression(expression)
      Filter::new do |object|
        wildcard_at_start = expression.start_with? '*'
        wildcard_at_end = expression.end_with? '*'
        if wildcard_at_start and wildcard_at_end
          object.to_s.index expression[1...-1]
        elsif wildcard_at_start
          object.to_s.end_with? expression[1..-1]
        elsif wildcard_at_end
          object.to_s.start_with? expression[0...-1]
        else
          object.to_s == expression.to_s
        end
      end
    end

    def self.level(expression)
      Filter::new do |entry|
        entry.level.to_s == expression.to_s
      end
    end

    def self.category(expression)
      Filter::new do |entry|
        expression(expression).accept? entry.category
      end
    end

    def self.origin(expression)
      Filter::new do |entry|
        expression(expression).accept? entry.origin
      end
    end

    def self.message(expression)
      Filter::new do |entry|
        expression(expression).accept? entry.message
      end
    end

    def self.exception(expression)
      Filter::new do |entry|
        expression(expression).accept? entry.exception
      end
    end

    def self.exceptions
      Filter::new do |entry|
        entry.exception?
      end
    end

  end

end