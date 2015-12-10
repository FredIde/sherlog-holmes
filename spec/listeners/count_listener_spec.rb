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

describe CountListener do

  before(:each) do
    @listener = CountListener::new
  end

  it 'should count entries by level' do
    @listener.call Entry::new(level: :info)
    @listener.call Entry::new(level: :info)
    @listener.call Entry::new(level: :error)
    @listener.call Entry::new(level: :debug)

    expect(@listener.levels[:info]).to eq(2)
    expect(@listener.levels[:error]).to eq(1)
    expect(@listener.levels[:debug]).to eq(1)
  end

  it 'should count entries by category' do
    @listener.call Entry::new(category: 'devnull.tools')
    @listener.call Entry::new(category: 'sherlog holmes')
    @listener.call Entry::new(category: 'devnull.tools')
    @listener.call Entry::new(category: 'other')

    expect(@listener.categories['devnull.tools']).to eq(2)
    expect(@listener.categories['sherlog holmes']).to eq(1)
    expect(@listener.categories['other']).to eq(1)
  end

  it 'should count entries by origin' do
    @listener.call Entry::new(origin: 'main')
    @listener.call Entry::new(origin: 'main')
    @listener.call Entry::new(origin: 'worker')
    @listener.call Entry::new(origin: 'other')

    expect(@listener.origins['main']).to eq(2)
    expect(@listener.origins['worker']).to eq(1)
    expect(@listener.origins['other']).to eq(1)
  end

  it 'should count entries by exception' do
    @listener.call Entry::new(exception: 'NullPointerException')
    @listener.call Entry::new(exceptions: %w{NullPointerException IllegalArgumentException})
    @listener.call Entry::new(exception: 'UnbelievableException')
    @listener.call Entry::new(exception: 'OMGException')

    expect(@listener.exceptions['NullPointerException']).to eq(2)
    expect(@listener.exceptions['IllegalArgumentException']).to eq(1)
    expect(@listener.exceptions['UnbelievableException']).to eq(1)
    expect(@listener.exceptions['OMGException']).to eq(1)
  end

end