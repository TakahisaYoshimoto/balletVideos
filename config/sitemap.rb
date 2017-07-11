# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = ENV["SITE_URL"]

SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  # これだとhttp://example.com/shopsというページを
  # 更新頻度を毎月、優先度を0.75という形で登録しています
  add '/bits', :changefreq => 'monthly', :priority => 0.75
  add '/bits/videotop', :changefreq => 'monthly', :priority => 0.75
  add '/boards', :changefreq => 'monthly', :priority => 0.75

  YoutubeVideo.find_each do |youtube|
    add youtube_video_path(youtube), :lastmod => youtube.updated_at, :changefreq => 'monthly', :priority => 0.75
  end

  Board.find_each do |board|
    add board_path(board), :lastmod => board.updated_at, :changefreq => 'monthly', :priority => 0.75
  end

  User.find_each do |user|
    add profile_path(user), :lastmod => user.updated_at, :changefreq => 'monthly', :priority => 0.75
  end
end
