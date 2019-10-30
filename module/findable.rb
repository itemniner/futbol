module Findable

  def find_by_in(element, attribute, collection)
    collection.find_all { |member| member.send(attribute) == element }
  end

  def games_with_team(team_id)
    find_by_in(team_id, "home_team_id", @games) + find_by_in(team_id, "away_team_id", @games)
  end

  def games_teams_with_team(team_id)
    find_by_in(team_id, "team_id", @games_teams)
  end

  def every(attribute, collection)
    collection.map { |element| element.send(attribute) }
  end

  def away_games_of_team(team_id)
    find_by_in(team_id, "team_id", find_by_in("away", "hoa", @games_teams))
  end

  def home_games_of_team(team_id)
    find_by_in(team_id, "team_id", find_by_in("home", "hoa", @games_teams))
  end

  def list_of_games_of_team(team_id) # see 101 line
    find_by_in(team_id, "team_id", @games_teams)
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

  def all_games_with_ids(game_ids)
    @games_teams.find_all { |game_team| game_ids.include?(game_team.game_id) }
  end

  def all_coach_games_in_season(coach, game_ids)
    all_games_with_ids(game_ids).find_all { |game_team| game_team.head_coach == coach }
  end

  def all_games_of_team_in_season(team_id, game_ids)
    all_games_with_ids(game_ids).select do |game|
      game.team_id == team_id
    end
  end

  def all_games_in_season(season)
    @games.select { |game| game.season == season }
  end

  def all_home_games_of_team(team_id)
    find_by_in(team_id, "home_team_id", @games)
  end

  def all_away_games_of_team(team_id)
    find_by_in(team_id, "away_team_id", @games)
  end

  def games_with_team_in_season(team_id, season)
    games_with_team(team_id).select do |game|
      game.season == season
    end
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

  def team_games_in_season_and_type(team_id, season, type)
    all_games_in_season_and_type(season, type).select do |game|
      team_id == game.home_team_id || team_id == game.away_team_id
    end
  end

  def team_wins_in_season_and_type(team_id, season, type)
    team_games_in_season_and_type(team_id, season, type).count do |game|
      team_id == game.home_team_id ? game.home_win? : game.away_win?
    end
  end

  def game_ids_in_season(season)
    all_games_in_season(season).map { |game| game.game_id }
  end

  def all_games_in_season_and_type(season, type)
    all_games_in_season(season).select { |game| game.type == type }
  end

  def game_ids_in_season_and_type(season, type)
    all_games_in_season_and_type(season, type).map { |game| game.game_id }
  end

  def games_between(team_id, team_opponent)
    games_with_team(team_id).find_all do |game|
      team_opponent == game.away_team_id || team_opponent == game.home_team_id
    end
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
end
