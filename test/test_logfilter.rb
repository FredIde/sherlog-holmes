require 'test/unit'
require_relative '../lib/sherlog_holmes'

class TestFilter < Test::Unit::TestCase

  def test_level_filter
    logfilter = Sherlog::LogFilter::new
    logfilter.level :error

    error_entry = Sherlog::LogEntry::new
    error_entry.level = 'error'

    info_entry = Sherlog::LogEntry::new
    info_entry.level = 'info'

    assert_true logfilter.accept? error_entry
    assert_false logfilter.accept? info_entry
  end

end