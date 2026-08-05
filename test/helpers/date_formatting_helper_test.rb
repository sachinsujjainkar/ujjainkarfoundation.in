require "test_helper"

class DateFormattingHelperTest < ActionView::TestCase
  include DateFormattingHelper

  setup { @date = Date.new(2026, 8, 5) }

  test "marathi_date renders Marathi month name with Devanagari numerals" do
    assert_equal "५ ऑगस्ट २०२६", marathi_date(@date)
  end

  test "marathi_date handles a blank date" do
    assert_equal "", marathi_date(nil)
  end

  test "dateline renders the standard Marathi press form, no year" do
    assert_equal "पुणे, दि. ५ ऑगस्ट", dateline("पुणे", @date)
  end

  test "dateline falls back to just the place when the date is blank" do
    assert_equal "पुणे", dateline("पुणे", nil)
  end

  test "localized_date is Marathi prose style in the mr locale" do
    I18n.with_locale(:mr) { assert_equal "५ ऑगस्ट २०२६", localized_date(@date) }
  end

  test "localized_date falls back to I18n.l with Latin numerals in the en locale" do
    I18n.with_locale(:en) { assert_equal "August 05, 2026", localized_date(@date) }
  end
end
