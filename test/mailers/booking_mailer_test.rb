require "test_helper"

class BookingMailerTest < ActionMailer::TestCase
  test "new_booking" do
    mail = BookingMailer.new_booking
    assert_equal "New booking", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
