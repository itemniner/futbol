module Statable
  def highest_total_score
    @games.highest_total_score
  end

  def percentage_home_wins
    @games_teams.percentage_home_wins
  end

  def percentage_visitor_wins
    @games_teams.percentage_visitor_wins
  end

  def percentage_ties
    @games_teams.percentage_ties
  end

  def lowest_total_score
    @games.lowest_total_score
  end

  def biggest_blowout
    @games_teams.biggest_blowout
  end

  def count_of_games_by_season
    @games.count_of_games_by_season
  end

  def average_goals_per_game
    @games.average_goals_per_game
  end

  def average_goals_by_season
    @games.average_goals_by_season
  end

  def count_of_teams
    @teams.count_of_teams
  end
end
