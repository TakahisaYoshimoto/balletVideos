require 'clockwork'
require File.expand_path('../../../config/boot', __FILE__)
require File.expand_path('../../../config/environment', __FILE__)

  module Clockwork
    lastsend = 0
    handler do |job|
      d = Date.today
      t = Time.now

      if (d.wday == 0 || d.wday == 5)
        p '1'
      end
      if (t.hour > 1)
        p '2'
      end
      if (lastsend != d.day)
        p '3'
      end

      #火曜日か金曜日で、１８時以降で、今日メールを送っていなかったら、メールを送る
      if (d.wday == 0 || d.wday == 5) && (t.hour > 1) && (lastsend != d.day)
        #メールを受信する設定にしているユーザーの一覧を取得
        users = User.where('acceptance = ?', true)

        #過去三日間で、一番よく見られている動画を上位３個取得
        ids = Impression.where("created_at >= ?", Time.now.ago(3.days))
                        .group(:impressionable_id)
                        .order('count_all desc')
                        .limit(3)
                        .offset(0)
                        .count
                        .keys
        youtubes = YoutubeVideo.where(:id => ids).order("field(id, #{ids.join(',')})")

        #過去三日で、たくさんコメントがついたboardの上位３個を取得
        b_count = BoardComment.where("created_at >= ?", Time.now.ago(3.days)).count

        #過去３日でコメントがあればtrue、過去３日間コメントが無ければfalse
        if b_count > 0
          board_comments_count = BoardComment.where("created_at >= ?", Time.now.ago(3.days))
                                              .group(:board_id)
                                              .order('count_all desc')
                                              .limit(3)
                                              .offset(0)
                                              .count
                                              .keys
          boards = Board.where(:id => board_comments_count).order("field(id, #{board_comments_count.join(',')})")
          master_comments = {}
          boards.each do |board|
            master_comment = BoardComment.where(board_id: board.id).order('created_at asc').first
            master_comments = { master_comment.board_id => master_comment.text}
          end
        else
          boards = Board.all.order('created_at desc')
                            .limit(3)
                            .offset(0)
          boards.each do |board|
            master_comment = BoardComment.where(board_id: board.id).order('created_at asc').first
            master_comments = { master_comment.board_id => master_comment.text}
          end
        end
        #メールする
        users.each do |user|
          @mail = SupportMailer.sendmail_periodic_notification(user.email, youtubes, boards, master_comments)
            .deliver
        end

        lastsend = d.day
        p '------------------------------------------'
        p Time.now
        p '定期メール送信'
        p '-------------------------------------------'
      else
        p '-------------------------------------------'
        p '送信しませんでした。'
        p '-------------------------------------------'
      end
    end

    every(15.seconds, 'frequent.job')
    #every(1.minutes, 'sendmail')
  end