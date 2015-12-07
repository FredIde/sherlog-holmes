require 'spec_helper'

describe LogFilter, '#category' do

  before :all do
    @sherlog_entry = LogEntry::new category: 'tools.devnull.sherlog'
    @devnull_entry = LogEntry::new category: 'tools.devnull'
    @other_entry = LogEntry::new category: 'other'
  end

  it 'should filter entries correctly' do
    filter = LogFilter::category 'tools.devnull.sherlog'

    expect(filter.accept? @sherlog_entry).to be_truthy
    expect(filter.accept? @devnull_entry).to be_falsey
    expect(filter.accept? @other_entry).to be_falsey
  end

  it 'should expect wildcards' do
    filter = LogFilter::category 'tools.devnull*'

    expect(filter.accept? @sherlog_entry).to be_truthy
    expect(filter.accept? @devnull_entry).to be_truthy
    expect(filter.accept? @other_entry).to be_falsey

    filter = LogFilter::category '*devnull'

    expect(filter.accept? @sherlog_entry).to be_falsey
    expect(filter.accept? @devnull_entry).to be_truthy
    expect(filter.accept? @other_entry).to be_falsey
  end

end