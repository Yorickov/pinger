# frozen_string_literal: true

# Dev mode
set :bundle_command, '/Users/demian/.asdf/shims/bundle exec'
set :output, 'log/cron.log'

every '* * * * *' do
  runner 'PingSitesJob.perform_later'
end
