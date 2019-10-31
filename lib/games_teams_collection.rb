require_relative 'game_team'
require 'csv'
require_relative '../module/uniqable'
require_relative '../module/totalable'
require_relative '../module/calculatable'
require_relative '../module/findable'

class GamesTeamsCollection
  include Uniqable
  include Totalable
  include Calculatable
  include Findable
  attr_reader :games_teams

  def initialize(games_teams_path)
    @games_teams = generate_objects_from_csv(games_teams_path)
  end

  def generate_objects_from_csv(csv_file_path)
    objects = []
    CSV.foreach(csv_file_path, headers: true, header_converters: :symbol) do |row_object|
      objects << GameTeam.new(row_object)
    end
    objects
  end

  def most_goals_scored(team_id)
    list_of_games_of_team(team_id).map(&:goals).max.to_i
  end

  def fewest_goals_scored(team_id)
    list_of_games_of_team(team_id).map(&:goals).min.to_i
  end

  def biggest_team_blowout(team_id)
    difference = []
    team_goals(team_id).each_with_index do |team_goal, index|
      difference << team_goal - opponents_goals(team_id)[index]
    end
    difference.map { |number| number.abs }.max
  end

  def worst_loss(team_id)
    difference = []
    team_goals(team_id).each_with_index do |team_goal, index|
      difference << team_goal - opponents_goals(team_id)[index]
    end
    difference.map { |number| number }.max
  end

  def best_offense
    all_team_ids.max_by { |team_id| average_goals_for_team(team_id) }
  end

  def worst_offense
    all_team_ids.min_by { |team_id| average_goals_for_team(team_id) }
  end

  def best_defense
    all_team_ids.min_by { |team_id| average_goals_of_opponents(team_id) }
  end

  def worst_defense
    all_team_ids.max_by { |team_id| average_goals_of_opponents(team_id) }
  end

  def winningest_team
    all_team_ids.max_by { |team_id| team_win_percentage(team_id) }
  end

  def best_fans
    all_team_ids.max_by do |team_id|
      (team_home_win_percentage(team_id) - team_away_win_percentage(team_id)).abs
    end
  end

  def worst_fans
    all_team_ids.find_all do |team_id|
      team_home_win_percentage(team_id) < team_away_win_percentage(team_id)
    end
  end

  def biggest_blowout
    difference = []
    number_of_wins.each do |wins|
      number_of_losses.each do |losses|
        difference << wins - losses
      end
    end
    difference.max
  end

  def percentage_home_wins
    (total_home_wins / total_home_games.to_f).round(2)
  end

  def percentage_visitor_wins
    (total_away_wins / total_away_games.to_f).round(2)
  end

  def percentage_ties
    (total_ties.to_f / @games_teams.count).round(2)
  end

  def winningest_coach(game_ids)
    unique_coaches_in_season(game_ids).max_by { |coach| coach_win_percent_in_season(coach, game_ids) }
  end

  def worst_coach(game_ids)
    unique_coaches_in_season(game_ids).min_by { |coach| coach_win_percent_in_season(coach, game_ids) }
  end

  def most_tackles(game_ids)
    unique_teams_in_season(game_ids).max_by do |team_id|
      total_team_tackles_in_season(team_id, game_ids)
    end
  end

  def fewest_tackles(game_ids)
    unique_teams_in_season(game_ids).min_by do |team_id|
      total_team_tackles_in_season(team_id, game_ids)
    end
  end

  def most_accurate_team(game_ids)
    unique_teams_in_season(game_ids).max_by do |team_id|
      percentage_of_goals_to_shots_by_team_in_season(team_id, game_ids)
    end
  end

  def least_accurate_team(game_ids)
    unique_teams_in_season(game_ids).min_by do |team_id|
      percentage_of_goals_to_shots_by_team_in_season(team_id, game_ids)
    end
  end
end
