# Preview all emails at http://localhost:3000/rails/mailers/support_mailer
class SupportMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/support_mailer/sendmail_support
  def sendmail_support
    SupportMailer.sendmail_support
  end

end
