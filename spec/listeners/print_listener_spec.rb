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

describe PrintListener do

  let(:entry) {<<END.chomp}
ENTRY: This is a message with an EXCEPTION: Foo
  STACKTRACE: at bla
  STACKTRACE: at bar
  STACKTRACE: at run
END

  before(:each) do
    @parser = Parser::new
    @parser.patterns entry: /ENTRY:\s(?<message>.+)/,
                     exception: /EXCEPTION:\s(?<exception>\w+)/,
                     stacktrace: /^\s+STACKTRACE/
    @output = ''
    @listener = PrintListener::new @output
    @parser.on_new_entry @listener
  end

  it 'should print parsed entry' do
    @parser.parse entry
    expect(@output.chomp).to eq(entry)
  end

  it 'should omit stacktrace if configured' do
    @listener.hide_stacktrace
    @parser.parse entry
    expect(@output.chomp).to eq('ENTRY: This is a message with an EXCEPTION: Foo')
  end

end