require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/puma'
require 'whenever/capistrano'

Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
