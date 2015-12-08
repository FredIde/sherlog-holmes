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

describe Filter, '#category' do

  before :all do
    @sherlog_entry = Entry::new category: 'tools.devnull.sherlog'
    @devnull_entry = Entry::new category: 'tools.devnull'
    @other_entry = Entry::new category: 'other'
  end

  it 'should filter entries correctly' do
    filter = Filter::category 'tools.devnull.sherlog'

    expect(filter.accept? @sherlog_entry).to be_truthy
    expect(filter.accept? @devnull_entry).to be_falsey
    expect(filter.accept? @other_entry).to be_falsey
  end

  it 'should accept wildcards' do
    filter = Filter::category 'tools.devnull*'

    expect(filter.accept? @sherlog_entry).to be_truthy
    expect(filter.accept? @devnull_entry).to be_truthy
    expect(filter.accept? @other_entry).to be_falsey

    filter = Filter::category '*devnull'

    expect(filter.accept? @sherlog_entry).to be_falsey
    expect(filter.accept? @devnull_entry).to be_truthy
    expect(filter.accept? @other_entry).to be_falsey

    filter = Filter::category '*devnull*'

    expect(filter.accept? @sherlog_entry).to be_truthy
    expect(filter.accept? @devnull_entry).to be_truthy
    expect(filter.accept? @other_entry).to be_falsey
  end

end