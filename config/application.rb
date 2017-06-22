require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BalletVideos
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.default_locale = :ja

    config.time_zone = 'Tokyo'

    config.generators do |g|
      g.test_framework :rspec,
        view_specs: false,
        helper_specs: false,
        fixture: false
    end

    #フォームでエラーが出た時にfield_with_errorsというdivでエラーが出たフィールドが囲まれるのを拒否
    config.action_view.field_error_proc = Proc.new do |html_tag, instance|
      %Q(#{html_tag}).html_safe
    end
  end
end
