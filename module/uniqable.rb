module Uniqable

  def unique_coaches_in_season(game_ids)
    all_games_with_ids(game_ids).map { |game| game.head_coach }.uniq
  end

  def every_unique(attribute, collection)
    every(attribute, collection).uniq
  end

  def unique_teams_in_season(game_ids)
    all_games_with_ids(game_ids).map do |game|
      game.team_id
    end.uniq
  end

  def total_unique(attribute, collection)
    every_unique(attribute, collection).length
  end

  def unique_seasons
    @games.map {|game| game.season}.uniq
  end

  def all_team_ids
    every_unique("team_id", @games_teams)
  end

  def opponents_team_id(team_id)
    every_unique("team_id", all_opponent_games(team_id))
  end

  def home_teams
    every_unique("home_team_id", @games)
  end

  def away_teams
    every_unique("away_team_id", @games)
  end

  def team_seasons(team_id)
    games_with_team(team_id).map do |game|
      game.season
    end.uniq
  end

  def team_opponents(team_id)
    games_with_team(team_id).map do |game|
      team_id == game.away_team_id ? game.home_team_id : game.away_team_id
    end.uniq
  end

  def all_unique_teams_in_season(season)
    home_ids = every_unique("home_team_id", all_games_in_season(season))
    away_ids = every_unique("away_team_id", all_games_in_season(season))
    (home_ids + away_ids).uniq
  end
end
