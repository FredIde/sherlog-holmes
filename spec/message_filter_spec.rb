require 'spec_helper'

describe Filter, '#message' do

  before :all do
    @message_a = Entry::new message: 'this is a message'
    @message_b = Entry::new message: 'may day! may day!'
  end

  it 'should filter entries correctly' do
    filter = Filter::message 'message'

    expect(filter.accept? @message_a).to be_truthy
    expect(filter.accept? @message_b).to be_falsey
  end

  it 'should ignore case' do
    filter = Filter::message 'MessagE'

    expect(filter.accept? @message_a).to be_truthy
    expect(filter.accept? @message_b).to be_falsey
  end

end