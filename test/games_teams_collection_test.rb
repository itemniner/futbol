require_relative 'test_helper'

class GamesTeamsCollectionTest < Minitest::Test

  def setup
    @games_teams_collection = GamesTeamsCollection.new('./data/dummy_games_teams.csv')
  end

  def test_it_exists
    assert_instance_of GamesTeamsCollection, @games_teams_collection
  end

  def test_it_initializes_attributes
    assert_equal 99, @games_teams_collection.games_teams.length
    assert_equal true, @games_teams_collection.games_teams.all? {|game_team| game_team.is_a?(GameTeam)}
  end

  def test_it_can_get_total_home_games
    assert_equal 49, @games_teams_collection.total_home_games
  end

  def test_it_can_get_home_wins
    assert_equal 32, @games_teams_collection.total_home_wins
  end

  def test_it_calculates_home_win_percentage_to_the_hundredths
    assert_equal 65.31, @games_teams_collection.percentage_home_wins
  end

  def test_it_can_see_how_many_wins
    expected = [3, 3, 2, 3, 3, 3, 4, 2, 1, 2, 2, 3, 2, 2, 3, 2, 3, 4, 3, 4, 2, 3, 3, 3,
                3, 2, 2, 1, 3, 3, 2, 3, 3, 2, 3, 3, 3, 3, 3, 3, 3, 4, 2, 3, 3, 1, 3, 3]
    assert_equal expected, @games_teams_collection.number_of_wins
  end

  def test_it_can_see_how_many_losses
    expected = [2, 2, 1, 2, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 2, 1, 1, 1, 2, 1, 1, 2, 2, 0,
                1, 1, 1, 0, 2, 2, 1, 1, 2, 0, 2, 2, 2, 2, 0, 2, 2, 2, 0, 2, 1, 0, 2, 2, 1]
    assert_equal expected, @games_teams_collection.number_of_losses
  end

  def test_it_has_a_big_blow_out
    assert_equal 4, @games_teams_collection.biggest_blowout
  end

  def test_it_can_get_total_away_games
    assert_equal 50, @games_teams_collection.total_away_games
  end

  def test_it_can_get_away_wins
    assert_equal 16, @games_teams_collection.total_away_wins
  end

  def test_it_calculates_away_win_percentage_to_the_hundredths
    assert_equal 32.00, @games_teams_collection.percentage_visitor_wins
  end

  def test_it_can_get_total_ties
    assert_equal 2, @games_teams_collection.total_ties
  end

  def test_it_calculates_percentage_ties
    assert_equal 2.02, @games_teams_collection.percentage_ties
  end

  def test_it_can_find_rows_by_given_value_in_given_column
    assert_instance_of Array, @games_teams_collection.find_by_in("6", "team_id", @games_teams_collection.games_teams)
    assert_equal 9, @games_teams_collection.find_by_in("6", "team_id", @games_teams_collection.games_teams).length
    assert_equal true, @games_teams_collection.find_by_in("6", "team_id", @games_teams_collection.games_teams).all? { |element| element.is_a?(GameTeam) }
  end

  def test_it_can_find_all_rows_with_given_team_id
    assert_instance_of Array, @games_teams_collection.games_with_team("6")
    assert_equal 9, @games_teams_collection.games_with_team("6").length
    assert_equal true, @games_teams_collection.games_with_team("6").all? { |element| element.is_a?(GameTeam) }
  end

  def test_it_totals_games_for_given_team
    assert_equal 9, @games_teams_collection.total_found_by_in("6", "team_id", @games_teams_collection.games_teams)
    assert_equal 6, @games_teams_collection.total_found_by_in("2", "team_id", @games_teams_collection.games_teams)
  end

  def test_it_totals_wins_of_given_team
    assert_equal 9, @games_teams_collection.total_wins_of_team("6")
    assert_equal 2, @games_teams_collection.total_wins_of_team("2")
  end

  def test_it_can_make_percentage_with_numerator_and_denominator
    assert_equal 50.00, @games_teams_collection.percent_of(1, 2)
    assert_equal 33.33, @games_teams_collection.percent_of(2, 6)
  end

  def test_it_calculates_win_percentage_for_given_team_id
    assert_equal 100.00, @games_teams_collection.team_win_percentage("6")
    assert_equal 33.33, @games_teams_collection.team_win_percentage("2")
  end

  def test_it_can_find_all_team_ids
    expected_array = ["2", "3", "5", "6", "8", "9", "15", "16", "17", "19", "24", "26", "30"].sort
    assert_equal expected_array, @games_teams_collection.all_team_ids.sort
  end

  def test_it_can_return_team_id_of_team_with_best_win_percentage
    assert_equal "6", @games_teams_collection.team_id_with_best_win_percentage
  end

  def test_it_can_find_all_away_games_of_team_by_id
    assert_instance_of Array, @games_teams_collection.away_games_of_team("2")
    assert_equal 3, @games_teams_collection.away_games_of_team("2").length
    assert_equal true, @games_teams_collection.away_games_of_team("2").all? { |element| element.is_a?(GameTeam) }
  end

  def test_it_can_find_all_home_games_of_team_by_id
    assert_instance_of Array, @games_teams_collection.away_games_of_team("2")
    assert_equal 3, @games_teams_collection.away_games_of_team("2").length
    assert_equal true, @games_teams_collection.away_games_of_team("2").all? { |element| element.is_a?(GameTeam) }
  end

  def test_it_can_find_team_win_percentage_at_home_by_id
    assert_equal 66.67, @games_teams_collection.team_home_win_percentage("2")
  end

  def test_it_can_find_team_win_percentage_while_away_by_id
    assert_equal 0.00, @games_teams_collection.team_away_win_percentage("2")
  end

  def test_it_can_find_id_of_team_with_highest_home_win_percentage
    assert_equal "6", @games_teams_collection.team_with_best_home_win_percentage
    refute_equal "2", @games_teams_collection.team_with_best_home_win_percentage
  end

  def test_it_can_find_array_of_team_ids_with_higher_away_win_percentages
    assert_equal [], @games_teams_collection.teams_with_better_away_win_percentage_than_home
  end
end
