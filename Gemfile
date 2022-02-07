# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.0'

gem 'httparty'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# user auth
gem 'devise'

# jobs
gem 'good_job', '~> 2.9.5'

# database
gem 'pg'

# allowing users to view swagger docs
# so far rubygems version is not compatible with rails rails 7.x
gem 'rswag', git: 'https://github.com/rswag/rswag.git', branch: 'master'

# pagination
gem 'will_paginate', '~> 3.3'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

gem 'rspec-rails', '~> 5.0.0'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  # linting
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false

  # creating test data
  gem 'factory_bot'
  gem 'factory_bot_rails'

  # generating fake data
  gem 'faker'
end
