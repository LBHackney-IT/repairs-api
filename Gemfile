# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"

gem "bootsnap", ">= 1.4.2", require: false
gem "faraday"
gem "jwt"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 4.1"
gem "rack-cors"
gem "rails", "~> 6.0.3"
gem "rswag-api"
gem "rswag-ui"

group :development, :test do
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "factory_bot_rails"
  gem "pry-byebug"
  gem "rspec-rails", "~> 4.0.1"
  gem "rswag-specs"
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop", require: false
  gem "simplecov", require: false
  gem "webmock"
end

group :development do
  gem "listen", "~> 3.2"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
