require 'spec_helper'

describe Filter, '#origin' do

  before :all do
    @worker1_entry = Entry::new origin: 'http-worker-1'
    @worker2_entry = Entry::new origin: 'http-worker-2'
    @other_entry = Entry::new origin: 'other-origin'
  end

  it 'should filter entries correctly' do
    filter = Filter::origin 'http-worker-1'

    expect(filter.accept? @worker1_entry).to be_truthy
    expect(filter.accept? @worker2_entry).to be_falsey
    expect(filter.accept? @other_entry).to be_falsey
  end

  it 'should accept wildcards' do
    filter = Filter::origin 'http-worker*'

    expect(filter.accept? @worker1_entry).to be_truthy
    expect(filter.accept? @worker2_entry).to be_truthy
    expect(filter.accept? @other_entry).to be_falsey

    filter = Filter::origin '*worker-2'

    expect(filter.accept? @worker1_entry).to be_falsey
    expect(filter.accept? @worker2_entry).to be_truthy
    expect(filter.accept? @other_entry).to be_falsey

    filter = Filter::origin '*worker*'

    expect(filter.accept? @worker1_entry).to be_truthy
    expect(filter.accept? @worker2_entry).to be_truthy
    expect(filter.accept? @other_entry).to be_falsey
  end

end