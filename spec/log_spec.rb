require 'spec_helper'

describe Result do

  describe '#<<' do

    before(:each) do
      @log = Result::new
    end

    it 'should add entries' do
      @log << Entry::new

      expect(@log.entries.size).to eq(1)
    end

    it 'should maintain the order the entries are added' do
      entry_a = Entry::new
      entry_b = Entry::new

      @log << entry_a << entry_b

      expect(@log.entries[0]).to eq(entry_a)
      expect(@log.entries[1]).to eq(entry_b)
    end

    it 'should filter entries if a filter is given' do
      @log << Entry::new(level: :info) << Entry::new(level: :error)

      expect(@log.entries(filter: Filter::level(:error)).size).to eq(1)
    end

  end

end