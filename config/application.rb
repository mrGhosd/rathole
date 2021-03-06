require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Rathole
  class Application < Rails::Application
    config.assets.precompile << 'delayed/web/application.css'
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.time_zone = 'Moscow'
    config.after_initialize do
      ActionView::Base.sanitized_allowed_attributes += ['rel', 'target', 'style']
    end
    config.autoload_paths << "#{config.root}/app/validators"
  end
end
