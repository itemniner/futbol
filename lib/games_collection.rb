class GamesCollection
  attr_reader :games

  def initialize(games_path)
    @games = generate_objects_from_csv(games_path)
  end

  def generate_objects_from_csv(csv_games_path)
    objects = []
    CSV.foreach(csv_games_path, headers: true, header_converters: :symbol) do |row_object|
      objects << Game.new(row_object)
    end
    objects
  end

  def count_of_games_by_season
    @games.map {|game| games_by_season[game.season] = game.game_id.length}
  end
end
