# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.10'

gem 'bootsnap', require: false
gem 'cssbundling-rails'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.6'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[windows jruby]

gem 'devise'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'rails-i18n'

group :development, :test do
  gem 'debug', platforms: %i[mri windows]

  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'

  # RuboCop 本体 + 拡張（ここに集約）
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end
