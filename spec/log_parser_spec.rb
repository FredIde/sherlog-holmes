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

describe Parser do

  describe '#parse' do

    let(:header) { <<END.chomp }
Log Header
Should be ignored
END

    let(:line) { 'ENTRY: This is a log entry' }
    let(:multiline) do
      <<END.chomp
ENTRY: This is a log entry
  and has multiple lines
END
    end
    let(:exception_and_stacktrace) do
      <<END.chomp
ENTRY: This is a log entry with an EXCEPTION: UnbelievableException
  STACKTRACE: and has a stacktrace
  STACKTRACE: with multiple lines
END
    end

    let(:exception_in_multiline) do
      <<END.chomp
ENTRY: This is a log entry with
  an EXCEPTION: UnbelievableException
END
    end

    let(:exceptions_and_stacktrace) do
      <<END.chomp
ENTRY: This is a log entry with an EXCEPTION: UnbelievableException
  STACKTRACE: caused by EXCEPTION: OMGException
  STACKTRACE: and has a stacktrace
  STACKTRACE: with multiple lines
END
    end

    let(:no_exception_and_stacktrace) do
      <<END.chomp
ENTRY: This is a log entry
  STACKTRACE: and has a stacktrace
  STACKTRACE: but no exception
END
    end

    let(:input) { [line, multiline, exception_and_stacktrace, no_exception_and_stacktrace].join $/ }

    before(:each) do
      @filter = double Filter
      allow(@filter).to receive(:accept?).and_return(true)

      @parser = Parser::new
      @parser.filter @filter
      @parser.patterns entry: /ENTRY:\s(?<message>.+)/,
                       exception: /EXCEPTION:\s(?<exception>\w+)/,
                       stacktrace: /^\s+STACKTRACE/
      @result = @parser.collect
      @listener = double 'listener'
      allow(@listener).to receive(:call)
      @parser.on_new_entry @listener
    end

    it 'should use the given filter' do
      @parser.parse input
      expect(@filter).to have_received(:accept?).exactly(4).times
    end

    it 'should store the raw content of entries' do
      @parser.parse input
      expect(@result.entries[0].raw_content).to eq(line)
      expect(@result.entries[1].raw_content).to eq(multiline)
      expect(@result.entries[2].raw_content).to eq(exception_and_stacktrace)
      expect(@result.entries[3].raw_content).to eq(no_exception_and_stacktrace)
    end

    it 'should call listeners' do
      @parser.parse input
      expect(@listener).to have_received(:call).exactly(4).times
    end

    it 'should parse multiline messages' do
      @parser.parse input
      expect(@result.entries[1].message).to eq(<<END.chomp)
This is a log entry
  and has multiple lines
END
    end

    it 'should parse an exception message' do
      @parser.parse input
      expect(@result.exceptions.first.exception?).to be_truthy
      expect(@result.exceptions.first.exception).to eq('UnbelievableException')
      expect(@result.exceptions.first.stacktrace.size).to eq(2)
    end

    it 'should not parse a stacktrace if entry is not an exception' do
      @parser.parse input
      expect(@result.exceptions.size).to eq(1)
      expect(@result.entries[3].exception?).to be_falsey
    end

    it 'should parse exceptions in stacktrace' do
      @parser.parse exceptions_and_stacktrace

      expect(@result.exceptions.size).to eq(1) # there is one entry that is an exception entry
      expect(@result.entries.first.exceptions.size).to eq(2) # that entry has 2 exceptions
    end

    it 'should parse exceptions in multiline messages' do
      @parser.parse exception_in_multiline

      expect(@result.exceptions.first.exception?).to be_truthy
      expect(@result.exceptions.first.exception).to eq('UnbelievableException')
    end

    it 'should try to guess the pattern if none is given' do
      parser = Parser::new
      result = parser.collect
      parser.parse '18:50:42,129 INFO  [org.jboss.modules] (main) JBoss Modules version 1.3.6.Final-redhat-1'
      expect(result.entries.size).to eq(1)
      expect(result.entries.first.message).to eq('JBoss Modules version 1.3.6.Final-redhat-1')
    end

    it 'should apply filters after the entire entry was built' do
      @parser.filter Filter::exception('UnbelievableException')
      @parser.parse <<END.chomp
ENTRY: This is a log entry with an EXCEPTION: OMGException
  STACKTRACE: caused by EXCEPTION: UnbelievableException
  STACKTRACE: and has a stacktrace
  STACKTRACE: with multiple lines
END
      expect(@result.entries.first.exception?).to be_truthy
    end

  end

end