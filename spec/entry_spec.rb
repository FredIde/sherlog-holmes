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

describe Entry do

  describe '#new' do

    it 'should store level attribute' do
      entry = Entry::new level: 'foo'
      expect(entry.level).to eq 'foo'
    end

    it 'should store category attribute' do
      entry = Entry::new category: 'foo'
      expect(entry.category).to eq 'foo'
    end

    it 'should store origin attribute' do
      entry = Entry::new origin: 'foo'
      expect(entry.origin).to eq 'foo'
    end

    it 'should store message attribute' do
      entry = Entry::new message: 'foo'
      expect(entry.message).to eq 'foo'
    end

    it 'should store exception attribute' do
      entry = Entry::new exception: 'foo'
      expect(entry.exception).to eq 'foo'
      expect(entry.exceptions.size).to eq 1
    end

    it 'should store exceptions attribute' do
      entry = Entry::new exceptions: %w{foo bar}
      expect(entry.exceptions).to eq %w{foo bar}
      expect(entry.exceptions.size).to eq 2
    end

    it 'should store raw_content attribute' do
      entry = Entry::new raw_content: 'foo'
      expect(entry.raw_content).to eq 'foo'
    end

  end

  describe '#[]' do
    it 'should access custom attribute with symbols and strings' do
      entry = Entry::new bundle: 'foo'
      expect(entry[:bundle]).to eq 'foo'
      expect(entry['bundle']).to eq 'foo'
    end
  end

  describe '#exception' do
    it 'should return the fist exception stored' do
      entry = Entry::new exceptions: %w{foo bar}
      expect(entry.exception).to eq 'foo'
    end
  end

  describe '#exception?' do
    it 'should return true if there is an exception stored' do
      entry = Entry::new exceptions: %w{foo bar}
      expect(entry.exception?).to be_truthy

      entry = Entry::new exception: 'foo'
      expect(entry.exception?).to be_truthy
    end

    it 'should return false if there is no exception stored' do
      entry = Entry::new
      expect(entry.exception?).to be_falsey

      entry = Entry::new level: 'foo'
      expect(entry.exception?).to be_falsey

      entry = Entry::new category: 'foo'
      expect(entry.exception?).to be_falsey

      entry = Entry::new origin: 'foo'
      expect(entry.exception?).to be_falsey

      entry = Entry::new message: 'foo'
      expect(entry.exception?).to be_falsey
    end
  end

  describe '#<<' do
    it 'should append the argument to message' do
      entry = Entry::new message: 'foo'
      entry << 'bar'
      expect(entry.message).to eq <<END.chomp
foo
bar
END
    end
  end

end