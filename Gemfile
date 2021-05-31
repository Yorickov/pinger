source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

gem 'bootsnap', '>= 1.4.4', require: false
gem 'devise', '~> 4.8.0'
gem 'jbuilder', '~> 2.7'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.3', '>= 6.1.3.2'
gem 'sass-rails', '>= 6'
gem 'slim-rails'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.0'

group :development, :test do
  gem 'annotate', '~> 3.1.1'
  gem 'database_cleaner-active_record'
  gem 'dotenv-rails', '~> 2.7.6'
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 5.0.0'
  gem 'sqlite3'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'ordinare'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'solargraph'
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
  gem 'rubocop'
end

group :test do
  gem 'capybara'
  gem 'faker', git: 'https://github.com/faker-ruby/faker.git', branch: 'master'
  gem 'launchy'
  gem 'shoulda-matchers'
end
