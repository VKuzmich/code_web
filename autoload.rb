# frozen_string_literal: true


require 'erb'
require 'i18n'
require 'yaml'
require 'pry'

require 'codebreaker_vk'

require_relative 'application/config/i18n'
require_relative 'application/router'
require_relative 'application/codebreaker_rack'

I18n.config.load_path << Dir[File.expand_path('config/locales') + '/*.yml']
