source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# gem 'webpacker', '~> 4.x'

# for datepicker
gem 'jquery-rails' # Add this line if you use Rails 5.1 or higher
gem 'jquery-ui-rails'
# bootstrap fix dropdown
gem 'bootstrap-sass', '~> 3.4.1'

gem 'autoprefixer-rails', '~> 9.5.1'
gem 'font-awesome-sass', '~> 5.6.1'
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.2'

# ttimezone issue
# gem 'momentjs-rails'

# Devise login authentication
gem 'devise'
gem 'dotenv-rails', groups: [:development, :test]
gem 'omniauth-facebook'

# S3 service from AWS - Active storage
gem "aws-sdk-s3", require: false
# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'

gem 'geocoder'

# Ransack for search
gem 'ransack', github: 'activerecord-hackery/ransack'


# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# SECOND ROUND
# sms twilio service
gem 'twilio-ruby'
# full calendar for booking system
gem 'fullcalendar-rails', '~> 3.4.0'
# handle date & time
gem 'momentjs-rails', '~> 2.17.1'

gem 'stripe'
# display nice creditcard form
source 'http://insecure.rails-assets.org' do
  gem 'rails-assets-card'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
