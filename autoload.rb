# frozen_string_literal: true

require 'i18n'
require 'yaml'
require 'rack'
require 'haml'

require 'codebreaker_vk'

require_relative 'application/config/i18n'
require_relative 'application/game_helper'
require_relative 'application/game_process'
require_relative 'application/codebreaker_rack'
require_relative 'application/routing'

