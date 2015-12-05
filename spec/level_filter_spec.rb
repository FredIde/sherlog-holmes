require 'spec_helper'

describe LogFilter, '#level' do

  before :all do
    @info_entry = LogEntry::new level: :info
    @debug_entry = LogEntry::new level: :debug
    @error_entry = LogEntry::new level: :error

    @filter = LogFilter::level :info
  end

  it 'should filter only info entries' do
    expect(@filter.accept? @info_entry).to be_truthy
  end

end