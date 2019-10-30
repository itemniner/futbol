module Totalable
  def total_goals(games)
    games.sum { |game| goals(game) }
  end

  def total_goals_of_team(team_id)
    list_of_games_of_team(team_id).sum { |game_team| game_team.goals.to_i }
  end

  def total_goals_of_opponents(team_id)
    all_opponent_games(team_id).sum { |game_team| game_team.goals.to_i }
  end

  def total_home_games(team)
    all_home_games_of_team(team).count
  end

  def total_home_games
    @games_teams.count do |game_team|
      game_team.hoa == 'home'
    end
  end

  def total_home_goals(team)
    all_home_games_of_team(team).sum { |game| game.home_goals.to_i }
  end

  def total_away_games_team(team)
    all_away_games_of_team(team).count
  end

  def total_away_games
    @games_teams.count do |game_team|
      game_team.hoa == 'away'
    end
  end

  def total_away_goals(team)
    all_away_games_of_team(team).sum { |game| game.away_goals.to_i }
  end

  def total_away_wins_in_season(team_id, season)
    away_games_in_season(team_id, season).count do |game|
      away_win?(game)
    end
  end

  def total_away_wins
    @games_teams.count do |game_team|
      game_team.hoa == 'away' && game_team.result == 'WIN'
    end
  end

  def total_home_wins_in_season(team_id, season)
    home_games_in_season(team_id, season).count do |game|
      home_win?(game)
    end
  end

  def total_home_wins
    @games_teams.count do |game_team|
      game_team.hoa == 'home' && game_team.result == 'WIN'
    end
  end

  def total_team_wins(team_id, season)
    total_home_wins_in_season(team_id, season) + total_away_wins_in_season(team_id, season)
  end

  def total_non_tie_games(team_id, season)
    games_with_team_in_season(team_id, season).reject do |game|
      game.away_goals == game.home_goals
    end.length
  end

  def total_team_goals_in_season_and_type(team_id, season, type)
    team_games_in_season_and_type(team_id, season, type).sum do |game|
      team_id == game.home_team_id ? game.home_goals.to_i : game.away_goals.to_i
    end
  end

  def total_opponent_goals_in_season_and_type(team_id, season, type)
    team_games_in_season_and_type(team_id, season, type).sum do |game|
      team_id == game.home_team_id ? game.away_goals.to_i : game.home_goals.to_i
    end
  end

  def total_opponent_goals(team_id)
    find_opponents_goals_if_home_team(team_id) + find_opponents_goals_if_away_team(team_id)
  end

  def total_wins_across_seasons(team_id)
    unique_seasons.sum do |season|
      games_with_team_in_season(team_id, season) != nil ? total_team_wins(team_id, season) : 0
    end
  end

  def total_team_ties_in_season(team_id, season)
    games_with_team_in_season(team_id, season).count do |game|
      game.away_goals == game.home_goals
    end
  end

  def total_wins_against(team_id, team_opponent)
    games_between(team_id, team_opponent).count do |game|
      team_id == game.home_team_id ? home_win?(game) : away_win?(game)
    end
  end

  def total_games_between(team_id, team_opponent)
    games_between(team_id, team_opponent).length
  end

  def total_ties
    @games_teams.count do |game_team|
      game_team.result == 'TIE'
    end
  end

  def total_found_by_in(element, attribute, collection)
    find_by_in(element, attribute, collection).length
  end

  def total_games_with_team(team_id)
    total_found_by_in(team_id, "team_id", @games_teams)
  end

  def total_wins_of_team(team_id)
    games_with_team(team_id).count { |game_team| game_team.result == "WIN" }
  end


  def total_shots_taken_by_team(team_id)
    list_of_games_of_team(team_id).sum { |game_team| game_team.shots.to_i }
  end

  def total_wins_of_coach_in_season(coach, game_ids)
    all_coach_games_in_season(coach, game_ids).count do |game|
      game.result == "WIN"
    end
  end

  def total_coach_games_in_season(coach, game_ids)
    all_coach_games_in_season(coach, game_ids).length
  end

  def total_team_tackles_in_season(team_id, game_ids)
    all_games_of_team_in_season(team_id, game_ids).sum do |game|
      game.tackles.to_i
    end
  end
end
