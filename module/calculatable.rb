module Calculatable

  def percent_of(numerator, denominator)
    ((numerator / (denominator.to_f.nonzero? || 1)) * 100).round(2)
  end

  def team_win_percentage(team_id)
    percent_of(total_wins_of_team(team_id), total_games_with_team(team_id))
  end

  def team_home_win_percentage(team_id)
    percent_of(number_of_wins_in(home_games_of_team(team_id)), home_games_of_team(team_id).length)
  end

  def team_away_win_percentage(team_id)
    percent_of(number_of_wins_in(away_games_of_team(team_id)), home_games_of_team(team_id).length)
  end

  def average_goals_for_team(team_id)
    (total_goals_of_team(team_id) / total_games_with_team(team_id).to_f).round(2)
  end

  def average_goals_of_opponents(team_id)
    (total_goals_of_opponents(team_id) / all_opponent_games(team_id).length.to_f).round(2)
  end

  # def percentage_of_goals_to_shots_by_team(team_id)
  #   total = (total_goals_of_team(team_id) / total_shots_taken_by_team(team_id).to_f)
  #   (total * 100).round(2)
  # end

  def coach_win_percent_in_season(coach, game_ids)
    (total_wins_of_coach_in_season(coach, game_ids) / total_coach_games_in_season(coach, game_ids).to_f).round(2)
  end

  def percentage_of_goals_to_shots_by_team_in_season(team_id, game_ids)
    percent_of(total_goals_of_team_in_season(team_id, game_ids), total_shots_taken_by_team_in_season(team_id, game_ids))
  end

  def average_goals_in(games)
    (total_goals(games) / total_unique("game_id", games).to_f).round(2)
  end

  def average_home_score_of_team(team_id)
    total_home_goals_of_team(team_id) / total_home_games_of_team(team_id).to_f
  end

  def average_away_score_of_team(team_id)
    total_away_goals_of_team(team_id) / total_away_games_of_team(team_id).to_f
  end

  def team_win_percentage_in_season(team_id, season)
    (total_team_wins_in_season(team_id, season) / games_with_team_in_season(team_id, season).length.to_f).round(2)
  end

  def team_games_denominator(team_id, season, type)
    team_games_in_season_and_type(team_id, season, type).length.to_f.nonzero? || 1.0
  end

  def team_win_percentage_in_season_and_type(team_id, season, type)
    (team_wins_in_season_and_type(team_id, season, type) / team_games_denominator(team_id, season, type)).round(2)
  end

  def avg_team_goals_in_season_and_type(team_id, season, type)
    (total_team_goals_in_season_and_type(team_id, season, type) / team_games_denominator(team_id, season, type)).round(2)
  end

  def avg_opponent_goals_in_season_and_type(team_id, season, type)
    (total_opponent_goals_in_season_and_type(team_id, season, type) / team_games_denominator(team_id, season, type)).round(2)
  end

  def average_goals_of_opponent(team_id)
    total_opponent_goals(team_id) / games_with_team(team_id).length.to_f
  end

  def win_percentage_against(team_id, team_opponent)
    (total_wins_against(team_id, team_opponent) / total_games_between(team_id, team_opponent).to_f).round(2)
  end

  def team_difference_in_win_percentage_by_season(team_id, season)
    regular_season = team_win_percentage_in_season_and_type(team_id, season, "Regular Season")
    post_season = team_win_percentage_in_season_and_type(team_id, season, "Postseason")
    regular_season - post_season
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
end
