require 'spec_helper'

describe Filter do

  before :all do
    @true = Filter::new { |o| true }
    @false = Filter::new { |o| false }
  end

  describe '#and' do

    let(:true_and_true) { @true.and(@true) }
    let(:true_and_false) { @true.and(@false) }
    let(:false_and_false) { @false.and(@false) }

    it 'should create a new filter' do
      expect(true_and_true.hash).to_not eq(@true.hash)
    end

    it 'should honor the && operator' do
      expect(true_and_true.accept? nil).to be_truthy
      expect(true_and_false.accept? nil).to be_falsey
      expect(false_and_false.accept? nil).to be_falsey
    end
  end

  describe '#or' do

    let(:true_or_true) { @true.or(@true) }
    let(:true_or_false) { @true.or(@false) }
    let(:false_or_false) { @false.or(@false) }

    it 'should create a new filter' do
      expect(true_or_true.hash).to_not eq(@true.hash)
    end

    it 'should honor the || operator' do
      expect(true_or_true.accept? nil).to be_truthy
      expect(true_or_false.accept? nil).to be_truthy
      expect(false_or_false.accept? nil).to be_falsey
    end
  end

end