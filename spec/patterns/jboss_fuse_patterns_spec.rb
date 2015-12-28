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

describe 'JBoss Fuse Patterns' do

  describe '#parse' do

    before(:each) do
      @filter = double Filter
      allow(@filter).to receive(:accept?).and_return(true)

      @parser = Sherlog::parser 'jboss.fuse'
      @parser.filter @filter
      @result = @parser.collect
    end

    it 'should parse the lines correctly' do
      @parser.parse '2015-12-26 20:54:15,828 | INFO  | FelixStartLevel  | NamespaceHandlerRegisterer       | 74 - org.apache.cxf.cxf-core - 3.0.4.redhat-621084 | Registered blueprint namespace handler for http://cxf.apache.org/blueprint/simple'

      entry = @result.entries[0]
      expect(entry.time).to eq('2015-12-26 20:54:15,828')
      expect(entry.level).to eq('INFO')
      expect(entry.category).to eq('NamespaceHandlerRegisterer')
      expect(entry.origin).to eq('FelixStartLevel')
      expect(entry.message).to eq('Registered blueprint namespace handler for http://cxf.apache.org/blueprint/simple')
      expect(entry[:bundle]).to eq('74 - org.apache.cxf.cxf-core - 3.0.4.redhat-621084')
      expect(entry[:bundle_id]).to eq('74')
      expect(entry[:bundle_name]).to eq('org.apache.cxf.cxf-core')
      expect(entry[:bundle_version]).to eq('3.0.4.redhat-621084')
    end

  end

end