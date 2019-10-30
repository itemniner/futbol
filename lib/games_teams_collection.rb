require_relative 'game_team'
require 'csv'

class GamesTeamsCollection
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

  def total_home_games
    @games_teams.count do |game_team|
      game_team.hoa == 'home'
    end
  end

  def total_home_wins
    @games_teams.count do |game_team|
      game_team.hoa == 'home' && game_team.result == 'WIN'
    end
  end

  def percentage_home_wins
    (total_home_wins / total_home_games.to_f).round(2)
  end

  def total_away_games
    @games_teams.count do |game_team|
      game_team.hoa == 'away'
    end
  end

  def total_away_wins
    @games_teams.count do |game_team|
      game_team.hoa == 'away' && game_team.result == 'WIN'
    end
  end

  def percentage_visitor_wins
    (total_away_wins / total_away_games.to_f).round(2)
  end

  def total_ties
    @games_teams.count do |game_team|
      game_team.result == 'TIE'
    end
  end

  def percentage_ties
    (total_ties.to_f / @games_teams.count).round(2)
  end

  def number_of_wins
    winner_goals = []
    @games_teams.each do |game_team|
      if game_team.result == "WIN"
        winner_goals << game_team.goals.to_i
      end
    end
    winner_goals
  end

  def number_of_losses
    losser_goals = []
    @games_teams.each do |game_team|
      if game_team.result == "LOSS"
        losser_goals << game_team.goals.to_i
      end
    end
    losser_goals
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

  # Helper method designed to be reusable; consider moving to a parent Collection class
  def find_by_in(element, attribute, collection)
    collection.find_all { |member| member.send(attribute) == element }
  end

  # Helper method designed to be reusable; consider moving to a parent Collection class
  def total_found_by_in(element, attribute, collection)
    find_by_in(element, attribute, collection).length
  end

  # Helper method see 182
  def games_with_team(team_id)
    find_by_in(team_id, "team_id", @games_teams)
  end

  # Helper method
  def total_games_with_team(team_id)
    total_found_by_in(team_id, "team_id", @games_teams)
  end

  # Helper method
  def total_wins_of_team(team_id)
    games_with_team(team_id).count { |game_team| game_team.result == "WIN" }
  end

  # Helper method designed to be reusable; consider moving to a stats module
  def percent_of(numerator, denominator)
    ((numerator / denominator.to_f) * 100).round(2)
  end

  # Helper method
  def team_win_percentage(team_id)
    percent_of(total_wins_of_team(team_id), total_games_with_team(team_id))
  end

  # Helper method designed to be reusable; consider moving to a module
  def every(attribute, collection)
    collection.map { |element| element.send(attribute) }
  end

  # Helper method designed to be reusable; consider moving to a module
  def every_unique(attribute, collection)
    every(attribute, collection).uniq
  end

  # Helper method
  def all_team_ids
    every_unique("team_id", @games_teams)
  end

  def winningest_team
    all_team_ids.max_by { |team_id| team_win_percentage(team_id) }
  end

  # Helper method
  def away_games_of_team(team_id)
    find_by_in(team_id, "team_id", find_by_in("away", "hoa", @games_teams))
  end

  # Helper method
  def home_games_of_team(team_id)
    find_by_in(team_id, "team_id", find_by_in("home", "hoa", @games_teams))
  end

  # Helper method
  def number_of_wins_in(collection)
    collection.count { |game_team| game_team.result == "WIN" }
  end

  # Helper method
  def team_home_win_percentage(team_id)
    percent_of(number_of_wins_in(home_games_of_team(team_id)), home_games_of_team(team_id).length)
  end

  # Helper method
  def team_away_win_percentage(team_id)
    percent_of(number_of_wins_in(away_games_of_team(team_id)), home_games_of_team(team_id).length)
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

  def list_of_games_of_team(team_id) # see 101 line
    find_by_in(team_id, "team_id", @games_teams)
  end

  def total_goals_of_team(team_id)
    list_of_games_of_team(team_id).sum { |game_team| game_team.goals.to_i }
  end

  def average_goals_for_team(team_id)
    (total_goals_of_team(team_id) / total_games_with_team(team_id).to_f).round(2)
  end

  def best_offense
    all_team_ids.max_by { |team_id| average_goals_for_team(team_id) }
  end

  def worst_offense
    all_team_ids.min_by { |team_id| average_goals_for_team(team_id) }
  end

  def opponent_object(game_team_selected)
    @games_teams.find do |game_team|
      game_team.game_id == game_team_selected.game_id && game_team.hoa != game_team_selected.hoa
    end
  end

  def all_opponent_games(team_id)
    list_of_games_of_team(team_id).map do |game_team|
      opponent_object(game_team)
    end
  end

  def total_goals_of_opponents(team_id)
    all_opponent_games(team_id).sum { |game_team| game_team.goals.to_i }
  end

  def average_goals_of_opponents(team_id)
    (total_goals_of_opponents(team_id) / all_opponent_games(team_id).length.to_f).round(2)
  end

  def best_defense
    all_team_ids.min_by { |team_id| average_goals_of_opponents(team_id) }
  end

  def worst_defense
    all_team_ids.max_by { |team_id| average_goals_of_opponents(team_id) }
  end

  def team_goals(team_id)
    all_opponent_games(team_id).map { |game_team| game_team.goals.to_i }
  end

  def opponents_goals(team_id)
    list_of_games_of_team(team_id).map { |team_game| team_game.goals.to_i }
  end

  def biggest_team_blowout(team_id)
    difference = []
    team_goals(team_id).each_with_index do |team_goal, index|
      difference << team_goal - opponents_goals(team_id)[index]
    end
    difference.map { |number| number.abs }.max
  end

  def most_goals_scored(team_id)
    list_of_games_of_team(team_id).map(&:goals).max.to_i
  end

  def fewest_goals_scored(team_id)
    list_of_games_of_team(team_id).map(&:goals).min.to_i
  end

  def worst_loss(team_id)
    difference = []
    team_goals(team_id).each_with_index do |team_goal, index|
      difference << team_goal - opponents_goals(team_id)[index]
    end
    difference.map { |number| number }.max
  end

  def all_games_with_ids(game_ids)
    @games_teams.find_all { |game_team| game_ids.include?(game_team.game_id) }
  end

  def opponents_team_id(team_id)
    every_unique("team_id", all_opponent_games(team_id))
  end

  def total_shots_taken_by_team(team_id)
    list_of_games_of_team(team_id).sum { |game_team| game_team.shots.to_i }
  end

  def percentage_of_goals_to_shots_by_team(team_id)
    total = (total_goals_of_team(team_id) / total_shots_taken_by_team(team_id).to_f)
    (total * 100).round(2)
  end

  def all_coach_games_in_season(coach, game_ids)
    all_games_with_ids(game_ids).find_all { |game_team| game_team.head_coach == coach }
  end

  def total_wins_of_coach_in_season(coach, game_ids)
    all_coach_games_in_season(coach, game_ids).count do |game|
      game.result == "WIN"
    end
  end

  def total_coach_games_in_season(coach, game_ids)
    all_coach_games_in_season(coach, game_ids).length
  end

  def coach_win_percent_in_season(coach, game_ids)
    (total_wins_of_coach_in_season(coach, game_ids) / total_coach_games_in_season(coach, game_ids).to_f).round(2)
  end

  def unique_coaches_in_season(game_ids)
    all_games_with_ids(game_ids).map { |game| game.head_coach }.uniq
  end

  def winningest_coach(game_ids)
    unique_coaches_in_season(game_ids).max_by { |coach| coach_win_percent_in_season(coach, game_ids) }
  end

  def worst_coach(game_ids)
    unique_coaches_in_season(game_ids).min_by { |coach| coach_win_percent_in_season(coach, game_ids) }
  end

  # Helper method - DELETE
  def all_team_ids
    every_unique("team_id", @games_teams)
  end

  def all_games_of_team_in_season(team_id, game_ids)
    all_games_with_ids(game_ids).select do |game|
      game.team_id == team_id
    end
  end

  def total_team_tackles_in_season(team_id, game_ids)
    all_games_of_team_in_season(team_id, game_ids).sum do |game|
      game.tackles.to_i
    end
  end

  def unique_teams_in_season(game_ids)
    all_games_with_ids(game_ids).map do |game|
      game.team_id
    end.uniq
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
end
