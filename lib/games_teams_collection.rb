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
    @games_teams.count {|game_team| game_team.hoa == 'home'}
  end

  def home_wins
    @games_teams.count {|game_team| game_team.hoa == 'home' && game_team.result == 'WIN'}
  end

  def percentage_home_wins
    ((home_wins / total_home_games.to_f) * 100).round(2)
  end

  def max_goals
    @games_teams.map {|game_team| game_team.goals.to_i}
  end

  def min_goals
    @games_teams.each {|game_team| game_team.goals.to_i}
  end

  def biggest_blowout
    max_goals - min_goals
  end
end
