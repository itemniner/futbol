require_relative 'test_helper'
require_relative '../lib/stat_tracker'


class StatTrackerTest < Minitest::Test
  def setup
    file_paths = {
                  games: './data/dummy_games.csv',
                  teams: './data/dummy_teams.csv',
                  game_teams: './data/dummy_games_teams.csv'
                }
    @stat_tracker = StatTracker.from_csv(file_paths)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_initializes_with_attributes
    assert_instance_of GamesCollection, @stat_tracker.games
    assert_instance_of TeamsCollection, @stat_tracker.teams
    assert_instance_of GamesTeamsCollection, @stat_tracker.games_teams
  end

  # Begin tests for iteration-required methods

  def test_it_grabs_highest_total_score
    assert_equal 8, @stat_tracker.highest_total_score
  end

  def test_it_grabs_lowest_total_score
    assert_equal 1, @stat_tracker.lowest_total_score
  end

  def test_it_has_a_big_blow_out
    assert_equal 4, @stat_tracker.biggest_blowout
  end

  def test_it_calculates_home_win_percentage_to_the_hundredths
    assert_equal 0.65, @stat_tracker.percentage_home_wins
  end

  def test_it_calculates_away_win_percentage_to_the_hundredths
    assert_equal 0.33, @stat_tracker.percentage_visitor_wins
  end

  def test_it_calculates_percentage_ties
    assert_equal 0.02, @stat_tracker.percentage_ties
  end

  def test_it_can_count_game_by_season

    expected = {
      "20122013" => 63,
      "20162017" => 4,
      "20142015" => 16,
      "20152016" => 16,
      "20132014" => 12
    }

    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_it_can_calculate_average_goals_per_game
    assert_equal 3.99, @stat_tracker.average_goals_per_game
  end

  def test_it_can_return_hash_of_average_goals_by_season
    expected_hash = {
                      "20122013"=>3.9,
                      "20162017"=>4.75,
                      "20142015"=>3.75,
                      "20152016"=>3.88,
                      "20132014"=>4.67
                    }
    assert_equal expected_hash, @stat_tracker.average_goals_by_season
  end

  def test_it_knows_how_many_teams_there_are
    assert_equal 32, @stat_tracker.count_of_teams
  end

  def test_it_can_get_name_of_team_by_id
    assert_equal "FC Dallas", @stat_tracker.name_of_team("6")
    assert_equal "Los Angeles FC", @stat_tracker.name_of_team("28")
  end

  def test_it_can_tell_name_of_highest_scoring_home_team
    assert_equal "Chicago Red Stars", @stat_tracker.highest_scoring_home_team
  end

  def test_it_can_tell_name_of_highest_scoring_visitor
    assert_equal "FC Dallas", @stat_tracker.highest_scoring_visitor
  end

  def test_it_can_tell_name_of_lowest_scoring_home_team
    assert_equal "Chicago Fire", @stat_tracker.lowest_scoring_home_team
  end

  def test_it_can_tell_name_of_lowest_scoring_visitor
    assert_equal "Seattle Sounders FC", @stat_tracker.lowest_scoring_visitor
  end

  def test_it_can_find_name_of_winningest_team
    assert_equal "FC Dallas", @stat_tracker.winningest_team
  end

  def test_it_can_find_team_with_best_fans
    assert_equal "New England Revolution", @stat_tracker.best_fans
  end

  def test_it_can_return_team_info_hash
    expected = {
      "abbreviation" => "ATL",
      "franchise_id" => "23",
      "link" => '/api/v1/teams/1',
      "team_id" => "1",
      "team_name" => "Atlanta United",
    }
    assert_equal expected, @stat_tracker.team_info("1")
  end

  def test_it_can_find_names_of_teams_with_worst_fans
    # no such teams exist in fixture data, but 2 exist in real data
    assert_equal [], @stat_tracker.worst_fans
  end

  def test_it_can_find_team_with_best_offense
    assert_equal "New York City FC", @stat_tracker.best_offense
  end

  def test_it_can_find_team_with_worst_offense
    assert_equal "Orlando City SC", @stat_tracker.worst_offense
  end

  def test_it_can_find_team_with_best_defense
    assert_equal "FC Dallas", @stat_tracker.best_defense
  end

  def test_it_can_find_team_with_worst_defense
    assert_equal "New York Red Bulls", @stat_tracker.worst_defense
  end

  def test_it_has_a_biggest_team_blowout
    assert_equal 3, @stat_tracker.biggest_team_blowout("2")
  end

  def test_it_can_find_the_most_goals_scored
    assert_equal 4, @stat_tracker.most_goals_scored("2")
  end

  def test_it_can_find_the_fewest_goals_scored
    assert_equal 0, @stat_tracker.fewest_goals_scored("2")
  end

  def test_it_can_tell_us_best_season_for_given_team
    assert_equal "20122013", @stat_tracker.best_season("2")
  end

  def test_it_can_tell_us_worst_season_for_given_team
    assert_equal "20122013", @stat_tracker.worst_season("2")
  end

  def test_it_calculates_win_percentage_for_given_team_id
    assert_equal 1.00, @stat_tracker.average_win_percentage("6")
    assert_equal 0.33, @stat_tracker.average_win_percentage("2")
    assert_equal 0.40, @stat_tracker.average_win_percentage("5")
  end

  def test_it_has_a_worst_loss
    assert_equal 3, @stat_tracker.worst_loss("2")
  end

  def test_it_has_a_seasonal_summary
    expected = {
                 "20122013"=>{
                             postseason:  {
                                                 win_percentage: 0.71,
                                                 total_goals_scored: 12,
                                                 total_goals_against: 10,
                                                 average_goals_scored: 1.71,
                                                 average_goals_against: 1.43
                                           },
                             regular_season:  {
                                                 win_percentage: 1.00,
                                                 total_goals_scored: 3,
                                                 total_goals_against: 2,
                                                 average_goals_scored: 3.00,
                                                 average_goals_against: 2.00
                                               }
                            },
                  "20152016"=>{
                              postseason:  {
                                                  win_percentage: 0.67,
                                                  total_goals_scored: 10,
                                                  total_goals_against: 6,
                                                  average_goals_scored: 1.67,
                                                  average_goals_against: 1.00
                                            },
                              regular_season:  {
                                                  win_percentage: 0.00,
                                                  total_goals_scored: 0,
                                                  total_goals_against: 0,
                                                  average_goals_scored: 0.00,
                                                  average_goals_against: 0.00
                                                }
                             }
                }
    assert_equal expected, @stat_tracker.seasonal_summary("15")
  end

  def test_it_can_find_favorite_opponent_of_given_team
    assert_equal "Seattle Sounders FC", @stat_tracker.favorite_opponent("5")
  end

  def test_in_can_find_rival_of_given_team
    assert_equal "FC Dallas", @stat_tracker.rival("5")
  end

  def test_it_can_change_team_id_keys_to_team_names
    incoming_hash = {
                      "6" => 0.00,
                      "2" => 0.67,
                      "3" => 0.40
                    }
    expected_hash = {
                      "Seattle Sounders FC" => 0.67,
                      "FC Dallas" => 0.00,
                      "Houston Dynamo" => 0.40
                    }
    assert_equal expected_hash, @stat_tracker.name_team_keys(incoming_hash)
  end

  def test_it_can_generate_head_to_head_hash_of_win_percentage_against_others
    expected_hash = {
                      "Seattle Sounders FC" => 0.67,
                      "FC Dallas" => 0.00,
                      "Houston Dynamo" => 0.40
                    }
    assert_equal expected_hash, @stat_tracker.head_to_head("5")
  end

  #
  # def test_it_can_find_all_games_given_season_and_team_id
  #   assert_equal 0, @stat_tracker.all_games_given_season_and_team_id("20122013")
  # end

  def test_it_can_find_total_shots_taken_by_team
    skip
    assert_equal 0, @stat_tracker.total_shots_taken_by_team("3", "20122013")
  end

  def test_it_can_get_all_games_in_games_teams_given_season
    assert_equal 98, @stat_tracker.all_game_given_the_season("20122013").length
  end

  def test_it_can_find_most_accurate_team
    assert_equal "New York City FC", @stat_tracker.most_accurate_team("20122013")
  end

  def test_it_can_find_least_accurate_team
    assert_equal "Houston Dynamo", @stat_tracker.least_accurate_team("20122013")
  end

  def test_it_can_find_winningest_coach_in_season
    game_ids = ["2012030131", "2012030132", "2012030133", "2012030134"]
    @stat_tracker.games.expects(:game_ids_in_season).returns(game_ids)
    assert_equal "Adam Oates", @stat_tracker.winningest_coach("20122013")
  end

  def test_it_can_find_worst_coach_in_season
    game_ids = ["2012030131", "2012030132", "2012030133", "2012030134"]
    @stat_tracker.games.expects(:game_ids_in_season).returns(game_ids)
    assert_equal "John Tortorella", @stat_tracker.worst_coach("20122013")
  end
  ##### in progress
  def test_it_can_tell_us_biggest_bust_in_season
    skip
    game_ids = ["2012030131", "2012030132", "2012030133", "2012030134"]
    @stat_tracker.games.expects(:game_ids_in_season).returns(game_ids)
    assert_equal "Team_1", @stat_tracker.biggest_bust("20122013")
  end
  ##### in progress
  def test_it_can_tell_us_biggest_surprise_in_season
    skip
    game_ids = ["2012030131", "2012030132", "2012030133", "2012030134"]
    @stat_tracker.games.expects(:game_ids_in_season).returns(game_ids)
    assert_equal "Team_2", @stat_tracker.biggest_surprise("20122013")
  end

  def test_it_can_name_of_team_with_most_tackles_in_season
    game_ids = ["2012030151", "2012030152", "2012030153", "2012030154", "2012030155"]
    @stat_tracker.games.expects(:game_ids_in_season).returns(game_ids)
    assert_equal "Orlando City SC", @stat_tracker.most_tackles("20122013")
  end

  def test_it_can_name_of_team_with_fewest_tackles_in_season
  end
end
