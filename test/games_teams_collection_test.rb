require_relative 'test_helper'

class GamesTeamsCollectionTest < Minitest::Test

  def setup
    @games_teams_collection = GamesTeamsCollection.new('./data/dummy_games_teams.csv')
  end

  def test_it_exists
    assert_instance_of GamesTeamsCollection, @games_teams_collection
  end

  def test_it_initializes_attributes
    assert_equal 98, @games_teams_collection.games_teams.length
    assert_equal true, @games_teams_collection.games_teams.all? {|game_team| game_team.is_a?(GameTeam)}
  end

  def test_it_can_get_total_home_games
    assert_equal 49, @games_teams_collection.total_home_games
  end

  def test_it_can_get_home_wins
    assert_equal 32, @games_teams_collection.total_home_wins
  end

  def test_it_calculates_home_win_percentage_to_the_hundredths
    assert_equal 0.65, @games_teams_collection.percentage_home_wins
  end

  def test_it_can_see_how_many_wins
    expected = [3, 3, 2, 3, 3, 3, 4, 2, 1, 2, 2, 3, 2, 2, 3, 2, 3, 4, 3, 4, 2, 3, 3, 3,
                3, 2, 2, 1, 3, 3, 2, 3, 3, 2, 3, 3, 3, 3, 3, 3, 3, 4, 2, 3, 3, 1, 3, 3]
    assert_equal expected, @games_teams_collection.number_of_wins
  end

  def test_it_can_see_how_many_losses
    expected = [2, 2, 1, 2, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 2, 1, 1, 1, 2, 1, 1, 2, 2, 0,
                1, 1, 1, 0, 2, 2, 1, 1, 2, 0, 2, 2, 2, 2, 0, 2, 2, 2, 0, 2, 1, 0, 2, 2]
    assert_equal expected, @games_teams_collection.number_of_losses
  end

  def test_it_has_a_big_blow_out
    assert_equal 4, @games_teams_collection.biggest_blowout
  end

  def test_it_can_get_total_away_games
    assert_equal 49, @games_teams_collection.total_away_games
  end

  def test_it_can_get_away_wins
    assert_equal 16, @games_teams_collection.total_away_wins
  end

  def test_it_calculates_away_win_percentage_to_the_hundredths
    assert_equal 0.33, @games_teams_collection.percentage_visitor_wins
  end

  def test_it_can_get_total_ties
    assert_equal 2, @games_teams_collection.total_ties
  end

  def test_it_calculates_percentage_ties
    assert_equal 0.02, @games_teams_collection.percentage_ties
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

  def test_it_finds_team_id_of_team_with_best_win_percentage_aka_winningest
    assert_equal "6", @games_teams_collection.winningest_team
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

  def test_it_finds_team_with_biggest_diff_btw_home_and_away_percent_aka_best_fans
    assert_equal "16", @games_teams_collection.best_fans
    refute_equal "2", @games_teams_collection.best_fans
  end

  def test_it_can_find_teams_with_higher_away_win_percentages_aka_worst_fans
    assert_equal [], @games_teams_collection.worst_fans # none in fixture data
  end

  def test_it_can_get_all_games_of_a_given_team
    assert_equal 6, @games_teams_collection.list_of_games_of_team("2").length
    assert_instance_of Array, @games_teams_collection.list_of_games_of_team("2")
    assert_equal true, @games_teams_collection.list_of_games_of_team("2").all? {|element| element.is_a?(GameTeam)}
  end

  def test_it_can_total_all_goals_of_given_team
    assert_equal 11, @games_teams_collection.total_goals_of_team("2")
  end

  def test_it_can_average_goals_of_team
    assert_equal 1.83, @games_teams_collection.average_goals_for_team("2")
  end

  def test_it_can_find_team_with_best_offense
    assert_equal "9", @games_teams_collection.best_offense
  end

  def test_it_can_find_team_with_worst_offense
    assert_equal "30", @games_teams_collection.worst_offense
  end

  def test_it_can_find_opponent_game_team_object_given_game_team_object
    assert_equal @games_teams_collection.games_teams[1], @games_teams_collection.opponent_object(@games_teams_collection.games_teams[0])
  end

  def test_it_can_find_all_opponent_games_by_team
    expected_array = [
      @games_teams_collection.games_teams[79],
      @games_teams_collection.games_teams[81],
      @games_teams_collection.games_teams[82],
      @games_teams_collection.games_teams[84],
      @games_teams_collection.games_teams[87],
      @games_teams_collection.games_teams[88]
    ]
    assert_equal expected_array, @games_teams_collection.all_opponent_games("2")
  end

  def test_it_can_find_total_goals_of_opponent
    assert_equal 15, @games_teams_collection.total_goals_of_opponents("2")
  end

  def test_it_can_find_average_of_opponents_goals
    assert_equal 2.50, @games_teams_collection.average_goals_of_opponents("2")
  end

  def test_it_can_find_team_with_best_defense
    assert_equal "6", @games_teams_collection.best_defense
  end

  def test_it_can_find_team_with_worst_defense
    assert_equal "8", @games_teams_collection.worst_defense
  end

  def test_it_can_find_team_goals
    assert_equal [3,3,3,2,2,2], @games_teams_collection.team_goals("2")
  end

  def test_it_can_find_opponent_goals
    assert_equal [0,2,2,4,0,3], @games_teams_collection.opponents_goals("2")
  end

  def test_it_can_see_biggest_team_blowout
    assert_equal 3, @games_teams_collection.biggest_team_blowout("2")
  end

  def test_it_can_find_most_goals_scored_per_team
    assert_equal 4, @games_teams_collection.most_goals_scored("2")
  end

  def test_it_can_find_least_goals_scored_per_team
    assert_equal 0, @games_teams_collection.fewest_goals_scored("2")
  end

  def test_it_can_find_the_worst_loss
    assert_equal 3, @games_teams_collection.worst_loss("2")
  end

  def test_it_can_find_all_games_with_matching_game_ids
    argument_array = [
                        "2012030311",
                        "2012030312",
                        "2012030313",
                        "2012030314"
                     ]
    expected_array = [
                        @games_teams_collection.games_teams[10],
                        @games_teams_collection.games_teams[11],
                        @games_teams_collection.games_teams[12],
                        @games_teams_collection.games_teams[13],
                        @games_teams_collection.games_teams[14],
                        @games_teams_collection.games_teams[15],
                        @games_teams_collection.games_teams[16],
                        @games_teams_collection.games_teams[17]
    ]
    assert_equal expected_array, @games_teams_collection.all_games_with_ids(argument_array)
  end

  def test_it_can_get_opponents_id
    assert_equal ["3", "5"], @games_teams_collection.opponents_team_id("6")
  end

  def test_it_can_get_all_games_with_a_given_coach_in_given_ids
    expected_array = [
      @games_teams_collection.games_teams[91],
      @games_teams_collection.games_teams[93],
      @games_teams_collection.games_teams[94],
      @games_teams_collection.games_teams[96]
    ]
    argument_array = [
      "2012030131",
      "2012030132",
      "2012030133",
      "2012030134"
    ]
    assert_equal expected_array, @games_teams_collection.all_coach_games_in_season("Adam Oates", argument_array)
  end

  def test_it_can_total_wins_of_given_coach_in_given_season
    argument_array = [
      "2012030131",
      "2012030132",
      "2012030133",
      "2012030134"
    ]
  assert_equal 4, @games_teams_collection.total_wins_of_coach_in_season("Adam Oates", argument_array)
  end

  def test_it_can_total_games_with_coach_in_season
    argument_array = [
      "2012030131",
      "2012030132",
      "2012030133",
      "2012030134"
    ]
    assert_equal 4, @games_teams_collection.total_coach_games_in_season("Adam Oates", argument_array)
  end

  def test_it_can_calculate_win_percentage_for_given_coach_in_given_season
    argument_array = [
      "2012030131",
      "2012030132",
      "2012030133",
      "2012030134"
    ]
    assert_equal 1.00, @games_teams_collection.coach_win_percent_in_season("Adam Oates", argument_array)
  end

  def test_it_can_find_unique_coaches_in_given_season
    expected_array = ["John Tortorella", "Adam Oates"]
    argument_array = [
                        "2012030131",
                        "2012030132",
                        "2012030133",
                        "2012030134"
                     ]
    assert_equal expected_array, @games_teams_collection.unique_coaches_in_season(argument_array)
  end

  def test_it_can_find_winningest_coach_in_given_season
    arg = ["2012030131", "2012030132", "2012030133", "2012030134"]
    assert_equal "Adam Oates", @games_teams_collection.winningest_coach(arg)
  end

  def test_it_can_find_worst_coach_in_given_season
    arg = ["2012030131", "2012030132", "2012030133", "2012030134"]
    assert_equal "John Tortorella", @games_teams_collection.worst_coach(arg)
  end

  def test_it_can_list_all_teams_games_in_preseason
    arg = ["2012030131", "2012030132", "2012030133", "2012030134"]
    assert_equal "Team_1", @games_teams.all_team_games_in_preseason(arg, "Preseason")
  end

  def test_it_can_list_all_teams_games_in_postseason
    arg = ["2012030131", "2012030132", "2012030133", "2012030134"]
    assert_equal "Team_2", @games_teams.all_team_games_in_preseason(arg, "Postseason")
  end

  def test_it_can_count_all_teams_wins_in_preseason
    arg = ["2012030131", "2012030132", "2012030133", "2012030134"]
    assert_equal 0, @games_teams.total_preseason_wins_of_team_in_season(arg, "Preseason")
  end

  def test_it_can_count_all_teams_wins_in_postseason
    arg = ["2012030131", "2012030132", "2012030133", "2012030134"]
    assert_equal 0, @games_teams.total_postseason_wins_of_team_in_season(arg, "Postseason")
  end
end
