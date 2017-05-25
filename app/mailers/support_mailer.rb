class SupportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.support_mailer.sendmail_support.subject
  #

  def sendmail_support(title, text, username, email)
    @title = title
    @text = text
    @username = username
    @email = email

    mail(to: ENV['SUPPORT_EMAIL_ADDRESS'], from: ENV['EMAIL_ADDRESS'], subject: title)
  end

  def sendmail_board_commented_after(board_id, text, username)
    p '-----------------------------------------------------------------'
    p 'メールを送る'
    p board_id
    p '-----------------------------------------------------------------'
    @board = Board.find(board_id)
    @text = text
    @username = username

    mail(to: @board.user.email, from: ENV['EMAIL_ADDRESS'], subject: 'あなたのトークルームにコメントがつきました。')
  end
end
