require 'spec_helper'

describe Filter, '#category' do

  before :all do
    @sherlog_entry = Entry::new category: 'tools.devnull.sherlog'
    @devnull_entry = Entry::new category: 'tools.devnull'
    @other_entry = Entry::new category: 'other'
  end

  it 'should filter entries correctly' do
    filter = Filter::category 'tools.devnull.sherlog'

    expect(filter.accept? @sherlog_entry).to be_truthy
    expect(filter.accept? @devnull_entry).to be_falsey
    expect(filter.accept? @other_entry).to be_falsey
  end

  it 'should accept wildcards' do
    filter = Filter::category 'tools.devnull*'

    expect(filter.accept? @sherlog_entry).to be_truthy
    expect(filter.accept? @devnull_entry).to be_truthy
    expect(filter.accept? @other_entry).to be_falsey

    filter = Filter::category '*devnull'

    expect(filter.accept? @sherlog_entry).to be_falsey
    expect(filter.accept? @devnull_entry).to be_truthy
    expect(filter.accept? @other_entry).to be_falsey

    filter = Filter::category '*devnull*'

    expect(filter.accept? @sherlog_entry).to be_truthy
    expect(filter.accept? @devnull_entry).to be_truthy
    expect(filter.accept? @other_entry).to be_falsey
  end

end