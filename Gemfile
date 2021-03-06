# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Create backends for website administration
gem 'activeadmin'
# Addons for ActiveAdmin
gem 'activeadmin_addons'
# In place editing in active admin
gem 'best_in_place', git: 'https://github.com/mmotherwell/best_in_place'
# Audit active record models
gem 'audited', '~> 5.0'
# Rails template charting
gem 'chartkick'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Annotate Rails classes with schema and routes info
  gem 'annotate'
  # Ruby linter
  gem 'rubocop', require: false
  # Testing
  gem 'rspec'
  # Rspec for Rail
  gem 'rspec-rails'
  # Fixtures in Rails
  gem 'factory_bot_rails'
end

group :development do
  gem 'listen', '~> 3.3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
