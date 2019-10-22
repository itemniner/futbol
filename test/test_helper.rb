require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'

require 'CSV'
require_relative '../lib/stat_tracker'

require_relative '../lib/games_collection'
require_relative '../lib/teams_collection'
require_relative '../lib/games_teams_collection'
require_relative '../lib/game'
require_relative '../lib/team'
require_relative '../lib/game_team'
