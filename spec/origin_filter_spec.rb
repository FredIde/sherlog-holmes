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

describe Filter, '#origin' do

  before :all do
    @worker1_entry = Entry::new origin: 'http-worker-1'
    @worker2_entry = Entry::new origin: 'http-worker-2'
    @other_entry = Entry::new origin: 'other-origin'
  end

  it 'should filter entries correctly' do
    filter = Filter::origin 'http-worker-1'

    expect(filter.accept? @worker1_entry).to be_truthy
    expect(filter.accept? @worker2_entry).to be_falsey
    expect(filter.accept? @other_entry).to be_falsey
  end

  it 'should accept wildcards' do
    filter = Filter::origin 'http-worker*'

    expect(filter.accept? @worker1_entry).to be_truthy
    expect(filter.accept? @worker2_entry).to be_truthy
    expect(filter.accept? @other_entry).to be_falsey

    filter = Filter::origin '*worker-2'

    expect(filter.accept? @worker1_entry).to be_falsey
    expect(filter.accept? @worker2_entry).to be_truthy
    expect(filter.accept? @other_entry).to be_falsey

    filter = Filter::origin '*worker*'

    expect(filter.accept? @worker1_entry).to be_truthy
    expect(filter.accept? @worker2_entry).to be_truthy
    expect(filter.accept? @other_entry).to be_falsey
  end

end