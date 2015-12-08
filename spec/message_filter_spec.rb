require 'spec_helper'

describe Filter, '#message' do

  before :all do
    @message_a = Entry::new message: 'this is a message'
    @message_b = Entry::new message: 'may day! may day!'
  end

  it 'should filter entries correctly' do
    filter = Filter::message 'this is a message'

    expect(filter.accept? @message_a).to be_truthy
    expect(filter.accept? @message_b).to be_falsey
  end

  it 'should accept wildcards' do
    filter = Filter::message '*message'
    expect(filter.accept? @message_a).to be_truthy
    expect(filter.accept? @message_b).to be_falsey

    filter = Filter::message 'this is*'
    expect(filter.accept? @message_a).to be_truthy
    expect(filter.accept? @message_b).to be_falsey

    filter = Filter::message '*day*'
    expect(filter.accept? @message_a).to be_falsey
    expect(filter.accept? @message_b).to be_truthy
  end

end