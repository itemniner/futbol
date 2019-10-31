class Game
  attr_reader :game_id, :season, :type, :date_time, :away_team_id, :home_team_id,
    :away_goals, :home_goals, :venue, :venue_link

  def initialize(game_info)
    @game_id = game_info[:game_id]
    @season = game_info[:season]
    @type = game_info[:type]
    @date_time = game_info[:date_time]
    @away_team_id = game_info[:away_team_id]
    @home_team_id = game_info[:home_team_id]
    @away_goals = game_info[:away_goals]
    @home_goals = game_info[:home_goals]
    @venue = game_info[:venue]
    @venue_link = game_info[:venue_link]
  end

  def away_win?
    @away_goals > @home_goals
  end

  def home_win?
    @home_goals > @away_goals
  end
end
