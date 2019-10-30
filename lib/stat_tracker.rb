require_relative 'games_collection'
require_relative 'teams_collection'
require_relative 'games_teams_collection'
require 'csv'

class StatTracker
  attr_reader :games, :teams, :games_teams

  def initialize(file_paths)
    @games = GamesCollection.new(file_paths[:games])
    @teams = TeamsCollection.new(file_paths[:teams])
    @games_teams = GamesTeamsCollection.new(file_paths[:game_teams])
  end

  def self.from_csv(file_paths)
    self.new(file_paths)
  end

  def highest_total_score
    @games.highest_total_score
  end

  def lowest_total_score
    @games.lowest_total_score
  end

  def biggest_blowout
    @games_teams.biggest_blowout
  end

  def percentage_home_wins
    @games_teams.percentage_home_wins
  end

  def percentage_visitor_wins
    @games_teams.percentage_visitor_wins
  end

  def percentage_ties
    @games_teams.percentage_ties
  end

  def count_of_games_by_season
    @games.count_of_games_by_season
  end

  def average_goals_per_game
    @games.average_goals_per_game
  end

  def average_goals_by_season
    @games.average_goals_by_season
  end

  def count_of_teams
    @teams.count_of_teams
  end

  # Helper method
  def name_of_team(team_id)
    @teams.name_of_team_by_id(team_id)
  end

  def highest_scoring_visitor
    name_of_team(@games.highest_scoring_visitor)
  end

  def highest_scoring_home_team
    name_of_team(@games.highest_scoring_home_team)
  end

  def lowest_scoring_visitor
    name_of_team(@games.lowest_scoring_visitor)
  end

  def lowest_scoring_home_team
    name_of_team(@games.lowest_scoring_home_team)
  end

  def winningest_team
    name_of_team(@games_teams.winningest_team)
  end

  def best_fans
    name_of_team(@games_teams.best_fans)
  end

  def worst_fans
    @games_teams.worst_fans.map { |team_id| name_of_team(team_id) }
  end

  def team_info(team_id)
    @teams.team_info(team_id)
  end

  def best_offense
    name_of_team(@games_teams.best_offense)
  end

  def worst_offense
    name_of_team(@games_teams.worst_offense)
  end

  def best_defense
    name_of_team(@games_teams.best_defense)
  end

  def worst_defense
    name_of_team(@games_teams.worst_defense)
  end

  def biggest_team_blowout(team_id)
    @games_teams.biggest_team_blowout(team_id)
  end

  def most_goals_scored(team_id)
    @games_teams.most_goals_scored(team_id)
  end

  def fewest_goals_scored(team_id)
    @games_teams.fewest_goals_scored(team_id)
  end

  def best_season(team_id)
    @games.best_season(team_id)
  end

  def worst_season(team_id)
    @games.worst_season(team_id)
  end

  def average_win_percentage(team_id)
    @games.average_win_percentage(team_id)
  end

  def worst_loss(team_id)
    @games_teams.worst_loss(team_id)
  end

  def seasonal_summary(team_id)
    @games.seasonal_summary(team_id)
  end

  def favorite_opponent(team_id)
    name_of_team(@games.favorite_opponent(team_id))
  end

  def rival(team_id)
    name_of_team(@games.rival(team_id))
  end

  def name_team_keys(team_hash)
    team_hash.reduce({}) do |hash, pair|
      hash[name_of_team(pair[0])] = pair[1]
      hash
    end
  end

  def head_to_head(team_id)
    name_team_keys(@games.head_to_head(team_id))
  end

  def all_game_given_the_season(season)
    @games_teams.all_games_with_ids(@games.game_ids_in_season(season))
  end

  def all_team_ids_for_accurate_team(season)
    @games_teams.every_unique("team_id", all_game_given_the_season(season))
  end

  def most_accurate_team(season)
    name_of_team(all_team_ids_for_accurate_team(season).max_by { |team_id| @games_teams.percentage_of_goals_to_shots_by_team(team_id) })
  end

  def least_accurate_team(season)
    name_of_team(all_team_ids_for_accurate_team(season).min_by { |team_id| @games_teams.percentage_of_goals_to_shots_by_team(team_id) })
  end

  def winningest_coach(season)
    @games_teams.winningest_coach(@games.game_ids_in_season(season))
  end

  def worst_coach(season)
    @games_teams.worst_coach(@games.game_ids_in_season(season))
  end

  def biggest_bust(season)
    name_of_team(@games.biggest_bust(season))
  end

  def biggest_surprise(season)
    name_of_team(@games.biggest_surprise(season))
  end

  def most_tackles(season)
    name_of_team(@games_teams.most_tackles(@games.game_ids_in_season(season)))
  end

  def fewest_tackles(season)
    name_of_team(@games_teams.fewest_tackles(@games.game_ids_in_season(season)))
  end
end
