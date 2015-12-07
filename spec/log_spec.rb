require 'spec_helper'

describe Log do

  describe '#<<' do

    before(:each) do
      @log = Log::new
    end

    it 'should add entries' do
      @log << LogEntry::new

      expect(@log.entries.size).to eq(1)
    end

    it 'should maintain the order the entries are added' do
      entry_a = LogEntry::new
      entry_b = LogEntry::new

      @log << entry_a << entry_b

      expect(@log.entries[0]).to eq(entry_a)
      expect(@log.entries[1]).to eq(entry_b)
    end

    it 'should filter entries if a filter is given' do
      @log << LogEntry::new(level: :info) << LogEntry::new(level: :error)

      expect(@log.entries(filter: LogFilter::level(:error)).size).to eq(1)
    end

  end

end