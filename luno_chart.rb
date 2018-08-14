#!/usr/bin/env ruby

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'bitx'
  gem 'pry'
  gem 'curses'
end

require 'bitx'
require 'bigdecimal'
require 'bigdecimal/util'
require 'curses'

# In a configure block somewhere in your app init:
BitX.configure do |config|
  config.api_key_secret = 'UricF2vqmPnKL8fWMt7JrhS8IPnUt7FEerNuCM9qoAo'
  config.api_key_id = 'ezhh2zass5k96'
  # config.api_key_pin = '1985'
end

Curses.noecho
Curses.init_screen
(1..10).each do |percent|
  print "\r#{percent*10}% complete"
  sleep(0.5)
end
Curses.clear
Curses.close_screen