require_relative 'game'
require 'csv'
require_relative '../module/uniqable'
require_relative '../module/totalable'
require_relative '../module/calculatable'
require_relative '../module/findable'

class GamesCollection
  include Uniqable
  include Totalable
  include Calculatable
  include Findable
  attr_reader :games

  def initialize(games_path)
    @games = generate_objects_from_csv(games_path)
  end

  def generate_objects_from_csv(csv_games_path)
    objects = []
    CSV.foreach(csv_games_path, headers: true, header_converters: :symbol) do |row_object|
      objects << Game.new(row_object)
    end
    objects
  end

  def highest_total_score
    @games.map {|game| game.away_goals.to_i + game.home_goals.to_i }.max
  end

  def lowest_total_score
    @games.map {|game| game.away_goals.to_i + game.home_goals.to_i }.min
  end

  def count_of_games_by_season
    target_hash = {}
    unique_seasons.each_with_index do |season, index|
      target_hash[season] = number_of_games_in_each_season[index]
    end
    target_hash
  end

  def average_goals_per_game
    average_goals_in(@games)
  end

  def average_goals_by_season
    every_unique("season", @games).reduce({}) do |hash, season|
      hash[season] = average_goals_in(all_games_in_season(season))
      hash
    end
  end

  def highest_scoring_home_team
    home_teams.max_by do |home_team_id|
      average_home_score_of_team(home_team_id)
    end
  end

  def highest_scoring_visitor
    away_teams.max_by do |away_team_id|
      average_away_score_of_team(away_team_id)
    end
  end

  def lowest_scoring_visitor
    away_teams.min_by do |away_team_id|
      average_away_score_of_team(away_team_id)
    end
  end

  def lowest_scoring_home_team
    home_teams.min_by do |home_team_id|
      average_home_score_of_team(home_team_id)
    end
  end

  def best_season(team_id)
    team_seasons(team_id).max_by do |season|
      team_win_percentage_in_season(team_id, season)
    end
  end

  def worst_season(team_id)
    team_seasons(team_id).min_by do |season|
      team_win_percentage_in_season(team_id, season)
    end
  end

  def average_win_percentage(team_id)
    (total_wins_across_seasons(team_id).to_f / games_with_team(team_id).length.to_f).round(2)
  end

  def favorite_opponent(team_id)
    team_opponents(team_id).min_by do |team_opponent|
      win_percentage_against(team_opponent, team_id)
    end
  end

  def rival(team_id)
    team_opponents(team_id).max_by do |team_opponent|
      win_percentage_against(team_opponent, team_id)
    end
  end

  def head_to_head(team_id)
    team_opponents(team_id).reduce({}) do |record, team_opponent|
      record[team_opponent] = win_percentage_against(team_id, team_opponent)
      record
    end
  end

  def seasonal_summary(team_id)
    team_seasons(team_id).reduce({}) do |season_info, season|
      season_info[season] = season_summary(team_id, season)
      season_info
    end
  end

  def season_summary(team_id, season)
    ["Regular Season", "Postseason"].reduce({}) do |season_summary, type|
      season_summary[type_to_symbol(type)] = season_sub_type_summary(team_id, season, type)
      season_summary
    end
  end

  def biggest_bust(season)
    teams_with_season_decrease(season).max_by do |team_id|
      team_difference_in_win_percentage_by_season(team_id, season).abs
    end
  end

  def biggest_surprise(season)
    teams_with_season_increase(season).max_by do |team_id|
      team_difference_in_win_percentage_by_season(team_id, season).abs
    end
  end

  def type_to_symbol(season_type)
    season_type.gsub(/\s+/, "_").downcase.intern
  end
end
