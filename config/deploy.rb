# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.16.0'

set :application, 'pinger'
set :repo_url, 'git@github.com:rubyroidlabs/pinger.git'

# set :branch, ENV['BRANCH'] if ENV['BRANCH']
# cap production deploy BRANCH=branch_name
set :branch, 'dm_try-do-deploy'

set :deploy_to, '/home/deployer/pinger'
set :deploy_user, 'deployer'
# set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }

append :linked_files, 'config/database.yml', 'config/master.key'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# set :init_system, :systemd
# set :service_unit_name, 'sidekiq'
