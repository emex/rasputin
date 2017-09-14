require 'tilt'
require 'sprockets/engines'

require "rasputin/version"
require "rasputin/handlebars/compiler"
require "rasputin/handlebars/template"

require "rasputin/slim" if defined? Slim
require "rasputin/haml" if defined? Haml

require "rasputin/require_preprocessor"

module Rasputin
  class Engine < ::Rails::Engine
    config.rasputin = ActiveSupport::OrderedOptions.new
    config.rasputin.precompile_handlebars = Rails.env.production?
    config.rasputin.template_name_separator = '/'

    config.rasputin.use_javascript_require = true
    config.rasputin.strip_javascript_require = true

    config.assets.configure do |env|
      silence_warning = !Sprockets::VERSION.start_with?("4")
      env.register_preprocessor 'application/javascript', Rasputin::RequirePreprocessor
      env.register_engine '.handlebars', Rasputin::HandlebarsTemplate, silence_deprecation: silence_warning
      env.register_engine '.hbs', Rasputin::HandlebarsTemplate, silence_deprecation: silence_warning
    end
  end
end
