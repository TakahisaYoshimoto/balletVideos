class SupportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.support_mailer.sendmail_support.subject
  #

  def sendmail_support(title, text)
    @title = title
    @text = text

    mail(to: "gatsuonrails@gmail.com", from: ENV['EMAIL_ADDRESS'], subject: title)
  end
end
