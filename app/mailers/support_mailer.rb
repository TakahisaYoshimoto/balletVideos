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
    @board = Board.find(board_id)
    @text = text
    @username = username

    mail(to: @board.user.email, from: ENV['EMAIL_ADDRESS'], subject: 'あなたのトークルームにコメントがつきました。')
  end

  def sendmail_periodic_notification(user, youtubes, boards, master_comments)
    @youtubes = youtubes
    @boards = boards
    @master_comments = master_comments
    mail(to: user, from: ENV['EMAIL_ADDRESS'], subject: 'Bit新着情報配信メール')
  end
end