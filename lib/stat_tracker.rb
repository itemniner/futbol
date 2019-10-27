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

  def worst_loss(team_id)
    @games_teams.worst_loss(team_id)
  end
end
