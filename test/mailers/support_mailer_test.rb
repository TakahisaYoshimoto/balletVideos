require 'test_helper'

class SupportMailerTest < ActionMailer::TestCase
  test "sendmail_support" do
    mail = SupportMailer.sendmail_support
    assert_equal "Sendmail support", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
