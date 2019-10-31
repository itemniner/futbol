require_relative '../module/statable'
require_relative 'games_collection'
require_relative 'games_teams_collection'
require_relative 'teams_collection'


class StatTracker
  include Statable
  attr_reader :games, :teams, :games_teams

  def initialize(file_paths)
    @games = GamesCollection.new(file_paths[:games])
    @teams = TeamsCollection.new(file_paths[:teams])
    @games_teams = GamesTeamsCollection.new(file_paths[:game_teams])
  end

  def self.from_csv(file_paths)
    self.new(file_paths)
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

  def head_to_head(team_id)
    name_team_keys(@games.head_to_head(team_id))
  end

  def most_accurate_team(season)
    name_of_team(@games_teams.most_accurate_team(@games.game_ids_in_season(season)))
  end

  def least_accurate_team(season)
    name_of_team(@games_teams.least_accurate_team(@games.game_ids_in_season(season)))
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

  def name_team_keys(team_hash)
    team_hash.reduce({}) { |hash, pair| hash[name_of_team(pair[0])] = pair[1]; hash }
  end

  def name_of_team(team_id)
    @teams.name_of_team_by_id(team_id)
  end
end
