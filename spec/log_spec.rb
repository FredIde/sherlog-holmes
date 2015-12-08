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

require 'spec_helper'

describe Result do

  describe '#<<' do

    before(:each) do
      @log = Result::new
    end

    it 'should add entries' do
      @log << Entry::new

      expect(@log.entries.size).to eq(1)
    end

    it 'should maintain the order the entries are added' do
      entry_a = Entry::new
      entry_b = Entry::new

      @log << entry_a << entry_b

      expect(@log.entries[0]).to eq(entry_a)
      expect(@log.entries[1]).to eq(entry_b)
    end

    it 'should filter entries if a filter is given' do
      @log << Entry::new(level: :info) << Entry::new(level: :error)

      expect(@log.entries(filter: Filter::level(:error)).size).to eq(1)
    end

  end

end