require_relative 'game'
require 'csv'
require './module/uniqable'
require './module/totalable'

class GamesCollection
  include Uniqable
  include Totalable
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
      team_win_percentage(team_id, season)
    end
  end

  def worst_season(team_id)
    team_seasons(team_id).min_by do |season|
      team_win_percentage(team_id, season)
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
  "----------------------------------SUPPORT_METHODS------------------------------"
  def number_of_games_in_each_season
    seasons_of_games = @games.group_by {|game| game.season}
    seasons_of_games.values.map {|value| value.length}
  end

  def every(attribute, collection)
    collection.map { |element| element.send(attribute) }
  end

  # def every_unique(attribute, collection)
  #   every(attribute, collection).uniq
  # end

  # def total_unique(attribute, collection)
  #   every_unique(attribute, collection).length
  # end

  def goals(game)
    game.home_goals.to_i + game.away_goals.to_i
  end

  # def total_goals(games)
  #   games.sum { |game| goals(game) }
  # end

  def average_goals_in(games)
    (total_goals(games) / total_unique("game_id", games).to_f).round(2)
  end

  def all_games_in_season(season)
    @games.select { |game| game.season == season }
  end

  def home_teams
    every_unique("home_team_id", @games)
  end

  def find_by_in(element, attribute_str, collection)
    collection.find_all { |member| member.send(attribute_str) == element }
  end

  def all_home_games_of_team(team_id)
    find_by_in(team_id, "home_team_id", @games)
  end

  def total_home_games(team)
    all_home_games_of_team(team).count
  end

  # def total_home_goals(team)
  #   all_home_games_of_team(team).sum { |game| game.home_goals.to_i }
  # end

  def average_home_score_of_team(team_id)
    total_home_goals(team_id) / total_home_games(team_id).to_f
  end

  def away_teams
    every_unique("away_team_id", @games)
  end

  def all_away_games_of_team(team_id)
    find_by_in(team_id, "away_team_id", @games)
  end

  # def total_away_games(team)
  #   all_away_games_of_team(team).count
  # end

  # def total_away_goals(team)
  #   all_away_games_of_team(team).sum { |game| game.away_goals.to_i }
  # end

  def average_away_score_of_team(team_id)
    total_away_goals(team_id) / total_away_games(team_id).to_f
  end

  def games_with_team(team_id)
    find_by_in(team_id, "home_team_id", @games) + find_by_in(team_id, "away_team_id", @games)
  end

  def games_with_team_in_season(team_id, season)
    games_with_team(team_id).select do |game|
      game.season == season
    end
  end

  def away_win?(game)
    game.away_goals > game.home_goals
  end

  def home_win?(game)
    game.home_goals > game.away_goals
  end

  def away_games_in_season(team_id, season)
    all_away_games_of_team(team_id).select do |game|
      game.season == season
    end
  end

  def home_games_in_season(team_id, season)
    all_home_games_of_team(team_id).select do |game|
      game.season == season
    end
  end

  # def total_away_wins(team_id, season)
  #   away_games_in_season(team_id, season).count do |game|
  #     away_win?(game)
  #   end
  # end

  # def total_home_wins(team_id, season)
  #   home_games_in_season(team_id, season).count do |game|
  #     home_win?(game)
  #   end
  # end

  # def total_team_wins(team_id, season)
  #   total_home_wins(team_id, season) + total_away_wins(team_id, season)
  # end

  def team_win_percentage(team_id, season)
    (total_team_wins(team_id, season) / games_with_team_in_season(team_id, season).length.to_f).round(2)
  end

  # def total_non_tie_games(team_id, season)
  #   games_with_team_in_season(team_id, season).reject do |game|
  #     game.away_goals == game.home_goals
  #   end.length
  # end

  # def unique_seasons
  #   @games.map {|game| game.season}.uniq
  # end

  def team_seasons(team_id)
    games_with_team(team_id).map do |game|
      game.season
    end.uniq
  end

  def team_games_in_season_and_type(team_id, season, type)
    all_games_in_season_and_type(season, type).select do |game|
      team_id == game.home_team_id || team_id == game.away_team_id
    end
  end

  def team_wins_in_season_and_type(team_id, season, type)
    team_games_in_season_and_type(team_id, season, type).count do |game|
      team_id == game.home_team_id ? home_win?(game) : away_win?(game)
    end
  end

  def team_games_denominator(team_id, season, type)
    team_games_in_season_and_type(team_id, season, type).length.to_f.nonzero? || 1.0
  end

  def team_win_percentage_in_season_and_type(team_id, season, type)
    (team_wins_in_season_and_type(team_id, season, type) / team_games_denominator(team_id, season, type)).round(2)
  end

  # def total_team_goals_in_season_and_type(team_id, season, type)
  #   team_games_in_season_and_type(team_id, season, type).sum do |game|
  #     team_id == game.home_team_id ? game.home_goals.to_i : game.away_goals.to_i
  #   end
  # end

  # def total_opponent_goals_in_season_and_type(team_id, season, type)
  #   team_games_in_season_and_type(team_id, season, type).sum do |game|
  #     team_id == game.home_team_id ? game.away_goals.to_i : game.home_goals.to_i
  #   end
  # end

  def avg_team_goals_in_season_and_type(team_id, season, type)
    (total_team_goals_in_season_and_type(team_id, season, type) / team_games_denominator(team_id, season, type)).round(2)
  end

  def avg_opponent_goals_in_season_and_type(team_id, season, type)
    (total_opponent_goals_in_season_and_type(team_id, season, type) / team_games_denominator(team_id, season, type)).round(2)
  end

  def season_sub_type_summary(team_id, season, type)
    {
      win_percentage: team_win_percentage_in_season_and_type(team_id, season, type),
      total_goals_scored: total_team_goals_in_season_and_type(team_id, season, type),
      total_goals_against: total_opponent_goals_in_season_and_type(team_id, season, type),
      average_goals_scored: avg_team_goals_in_season_and_type(team_id, season, type),
      average_goals_against: avg_opponent_goals_in_season_and_type(team_id, season, type)
    }
  end

  def type_to_symbol(season_type)
    season_type.gsub(/\s+/, "_").downcase.intern
  end

  def season_summary(team_id, season)
    ["Regular Season", "Postseason"].reduce({}) do |season_summary, type|
      season_summary[type_to_symbol(type)] = season_sub_type_summary(team_id, season, type)
      season_summary
    end
  end

  def find_opponents_goals_if_away_team(team_id)
    games_with_team(team_id).sum do |game_team|
      team_id == game_team.away_team_id ? game_team.home_goals.to_i : 0
    end
  end

  def find_opponents_goals_if_home_team(team_id)
    games_with_team(team_id).sum do |game_team|
      team_id == game_team.home_team_id ? game_team.away_goals.to_i : 0
    end
  end

  # def total_opponent_goals(team_id)
  #   find_opponents_goals_if_home_team(team_id) + find_opponents_goals_if_away_team(team_id)
  # end

  def average_goals_of_opponent(team_id)
    total_opponent_goals(team_id) / games_with_team(team_id).length.to_f
  end

  # def total_wins_across_seasons(team_id)
  #   unique_seasons.sum do |season|
  #     games_with_team_in_season(team_id, season) != nil ? total_team_wins(team_id, season) : 0
  #   end
  # end
  #
  # def total_team_ties_in_season(team_id, season)
  #   games_with_team_in_season(team_id, season).count do |game|
  #     game.away_goals == game.home_goals
  #   end
  # end

  def game_ids_in_season(season)
    all_games_in_season(season).map { |game| game.game_id }
  end

  def all_games_in_season_and_type(season, type)
    all_games_in_season(season).select { |game| game.type == type }
  end

  def game_ids_in_season_and_type(season, type)
    all_games_in_season_and_type(season, type).map { |game| game.game_id }
  end

  def team_opponents(team_id)
    games_with_team(team_id).map do |game|
      team_id == game.away_team_id ? game.home_team_id : game.away_team_id
    end.uniq
  end

  def games_between(team_id, team_opponent)
    games_with_team(team_id).find_all do |game|
      team_opponent == game.away_team_id || team_opponent == game.home_team_id
    end
  end

  # def total_wins_against(team_id, team_opponent)
  #   games_between(team_id, team_opponent).count do |game|
  #     team_id == game.home_team_id ? home_win?(game) : away_win?(game)
  #   end
  # end
  #
  # def total_games_between(team_id, team_opponent)
  #   games_between(team_id, team_opponent).length
  # end

  def win_percentage_against(team_id, team_opponent)
    (total_wins_against(team_id, team_opponent) / total_games_between(team_id, team_opponent).to_f).round(2)
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

  def team_difference_in_win_percentage_by_season(team_id, season)
    regular_season = team_win_percentage_in_season_and_type(team_id, season, "Regular Season")
    post_season = team_win_percentage_in_season_and_type(team_id, season, "Postseason")
    regular_season - post_season
  end

  def all_unique_teams_in_season(season)
    home_ids = every_unique("home_team_id", all_games_in_season(season))
    away_ids = every_unique("away_team_id", all_games_in_season(season))
    (home_ids + away_ids).uniq
  end

  def teams_with_season_decrease(season)
    all_unique_teams_in_season(season).find_all do |team_id|
      reg_percent = team_win_percentage_in_season_and_type(team_id, season, "Regular Season")
      post_percent = team_win_percentage_in_season_and_type(team_id, season, "Postseason")
      reg_percent > post_percent
    end
  end

  def teams_with_season_increase(season)
    all_unique_teams_in_season(season).find_all do |team_id|
      reg_percent = team_win_percentage_in_season_and_type(team_id, season, "Regular Season")
      post_percent = team_win_percentage_in_season_and_type(team_id, season, "Postseason")
      reg_percent < post_percent
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
end
