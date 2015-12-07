require 'spec_helper'

describe LogFilter, '#message' do

  before :all do
    @message_a = LogEntry::new message: 'this is a message'
    @message_b = LogEntry::new message: 'may day! may day!'
  end

  it 'should filter entries correctly' do
    filter = LogFilter::message 'message'

    expect(filter.accept? @message_a).to be_truthy
    expect(filter.accept? @message_b).to be_falsey
  end

  it 'should ignore case' do
    filter = LogFilter::message 'MessagE'

    expect(filter.accept? @message_a).to be_truthy
    expect(filter.accept? @message_b).to be_falsey
  end

end