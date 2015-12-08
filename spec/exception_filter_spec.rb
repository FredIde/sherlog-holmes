require 'spec_helper'

describe Filter do

  before :all do
    @nullpointer_entry = Entry::new exception: 'some.bla.NullPointerException'
    @generic_exception_entry = Entry::new exception: 'some.bla.Exception'
    @no_exception_entry = Entry::new message: 'Everything went well'
  end

  describe '#exception' do
    it 'should filter entries correctly' do
      filter = Filter::exception 'some.bla.NullPointerException'

      expect(filter.accept? @nullpointer_entry).to be_truthy
      expect(filter.accept? @generic_exception_entry).to be_falsey
      expect(filter.accept? @no_exception_entry).to be_falsey
    end

    it 'should accept wildcards' do
      filter = Filter::exception '*NullPointerException'

      expect(filter.accept? @nullpointer_entry).to be_truthy
      expect(filter.accept? @generic_exception_entry).to be_falsey
      expect(filter.accept? @no_exception_entry).to be_falsey

      filter = Filter::exception 'some.bla*'

      expect(filter.accept? @nullpointer_entry).to be_truthy
      expect(filter.accept? @generic_exception_entry).to be_truthy
      expect(filter.accept? @no_exception_entry).to be_falsey

      filter = Filter::exception '*bla*'

      expect(filter.accept? @nullpointer_entry).to be_truthy
      expect(filter.accept? @generic_exception_entry).to be_truthy
      expect(filter.accept? @no_exception_entry).to be_falsey
    end
  end

  describe '#exceptions' do
    it 'should filter entries correctly' do
      filter = Filter::exceptions

      expect(filter.accept? @nullpointer_entry).to be_truthy
      expect(filter.accept? @generic_exception_entry).to be_truthy
      expect(filter.accept? @no_exception_entry).to be_falsey
    end
  end

end