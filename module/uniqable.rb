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
end
