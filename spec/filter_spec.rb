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

describe Filter do

  before :all do
    @true = Filter::new { |o| true }
    @false = Filter::new { |o| false }
  end

  describe '#and' do

    let(:true_and_true) { @true.and(@true) }
    let(:true_and_false) { @true.and(@false) }
    let(:false_and_false) { @false.and(@false) }

    it 'should create a new filter' do
      expect(true_and_true.hash).to_not eq(@true.hash)
    end

    it 'should honor the && operator' do
      expect(true_and_true.accept? nil).to be_truthy
      expect(true_and_false.accept? nil).to be_falsey
      expect(false_and_false.accept? nil).to be_falsey
    end
  end

  describe '#or' do

    let(:true_or_true) { @true.or(@true) }
    let(:true_or_false) { @true.or(@false) }
    let(:false_or_false) { @false.or(@false) }

    it 'should create a new filter' do
      expect(true_or_true.hash).to_not eq(@true.hash)
    end

    it 'should honor the || operator' do
      expect(true_or_true.accept? nil).to be_truthy
      expect(true_or_false.accept? nil).to be_truthy
      expect(false_or_false.accept? nil).to be_falsey
    end
  end

end