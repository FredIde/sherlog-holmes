require 'spec_helper'

describe LogFilter, '#level' do

  before :all do
    @info_entry = LogEntry::new level: :info
    @debug_entry = LogEntry::new level: :debug
    @error_entry = LogEntry::new level: :error

    @info_filter = LogFilter::level :info
    @debug_filter = LogFilter::level :debug
  end

  it 'should filter entries correctly' do
    expect(@info_filter.accept? @info_entry).to be_truthy
    expect(@info_filter.accept? @debug_entry).to be_falsey
    expect(@info_filter.accept? @error_entry).to be_falsey

    expect(@debug_filter.accept? @debug_entry).to be_truthy
    expect(@debug_filter.accept? @info_entry).to be_falsey
    expect(@debug_filter.accept? @error_entry).to be_falsey
  end

  it 'should filter ignoring case' do
    expect(@info_filter.accept? LogEntry::new(level: 'INFO')).to be_truthy
    expect(@info_filter.accept? LogEntry::new(level: 'Info')).to be_truthy

    expect(@debug_filter.accept? LogEntry::new(level: 'DEBUG')).to be_truthy
    expect(@debug_filter.accept? LogEntry::new(level: 'Debug')).to be_truthy
  end

end