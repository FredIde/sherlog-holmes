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

describe Filter, '#level' do

  before :all do
    @info_entry = Entry::new level: :info
    @debug_entry = Entry::new level: :debug
    @error_entry = Entry::new level: :error

    @info_filter = Filter::level :info
    @debug_filter = Filter::level :debug
  end

  it 'should filter entries correctly' do
    expect(@info_filter.accept? @info_entry).to be_truthy
    expect(@info_filter.accept? @debug_entry).to be_falsey
    expect(@info_filter.accept? @error_entry).to be_falsey

    expect(@debug_filter.accept? @debug_entry).to be_truthy
    expect(@debug_filter.accept? @info_entry).to be_falsey
    expect(@debug_filter.accept? @error_entry).to be_falsey
  end

  it 'should filter only the matched level' do
    expect(@info_filter.accept? Entry::new(category: :information)).to be_falsey
  end

end