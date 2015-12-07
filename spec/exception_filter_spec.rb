require 'spec_helper'

describe LogFilter, '#exception' do

  before :all do
    @nullpointer_entry = LogEntry::new exception_class: 'some.bla.NullPointerException'
    @generic_exception_entry = LogEntry::new exception_class: 'some.bla.Exception'
    @no_exception_entry = LogEntry::new message: 'Everything went well'
  end

  it 'should filter entries correctly' do
    filter = LogFilter::exception 'some.bla.NullPointerException'

    expect(filter.accept? @nullpointer_entry).to be_truthy
    expect(filter.accept? @generic_exception_entry).to be_falsey
    expect(filter.accept? @no_exception_entry).to be_falsey
  end

  it 'should expect wildcards' do
    filter = LogFilter::exception '*NullPointerException'

    expect(filter.accept? @nullpointer_entry).to be_truthy
    expect(filter.accept? @generic_exception_entry).to be_falsey
    expect(filter.accept? @no_exception_entry).to be_falsey

    filter = LogFilter::exception 'some.bla*'

    expect(filter.accept? @nullpointer_entry).to be_truthy
    expect(filter.accept? @generic_exception_entry).to be_truthy
    expect(filter.accept? @no_exception_entry).to be_falsey
  end

end