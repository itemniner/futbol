require_relative 'test_helper'

class GamesCollectionTest < Minitest::Test

  def setup
    @games_collection = GamesCollection.new('./data/dummy_games.csv')
  end

  def test_it_exists
    assert_instance_of GamesCollection, @games_collection
  end

  def test_it_initializes_attributes
    assert_equal 111, @games_collection.games.length
    assert_equal true, @games_collection.games.all? {|game| game.is_a?(Game)}
  end

  def test_it_knows_the_number_of_games_in_each_season
    expected = [
      63,
      4,
      16,
      16,
      12
    ]
    assert_equal expected, @games_collection.number_of_games_in_each_season
  end

  def test_it_can_count_game_by_season
    expected = {
      "20122013" => 63,
      "20162017" => 4,
      "20142015" => 16,
      "20152016" => 16,
      "20132014" => 12
    }
    assert_equal expected, @games_collection.count_of_games_by_season
  end

  def test_it_grabs_highest_total_score
    assert_equal 8, @games_collection.highest_total_score
  end

  def test_it_grabs_lowest_total_score
    assert_equal 1, @games_collection.lowest_total_score
  end

  def test_it_can_return_total_goals_across_all_games
    assert_equal 443, @games_collection.total_goals(@games_collection.games)
  end

  def test_it_can_get_array_of_every_element_in_a_given_column
    assert_instance_of Array, @games_collection.every("game_id", @games_collection.games)
    assert_equal 111, @games_collection.every("game_id", @games_collection.games).length
  end

  def test_it_can_get_array_of_every_unique_element_in_a_given_column
    assert_equal 111, @games_collection.every_unique("game_id", @games_collection.games).length
  end

  def test_it_can_count_total_unique_elements_in_a_given_column
    assert_equal 111, @games_collection.total_unique("game_id", @games_collection.games)
  end

  def test_it_can_total_goals_for_given_game
    assert_equal 5, @games_collection.goals(@games_collection.games[0])
    assert_equal 3, @games_collection.goals(@games_collection.games[2])
    assert_equal 4, @games_collection.goals(@games_collection.games[4])
  end

  def test_it_can_calculate_average_goals_for_selection_of_games
    assert_equal 4.40, @games_collection.average_goals_in(@games_collection.games[0..4])
  end

  def test_it_can_calculate_average_goals_per_game
    assert_equal 3.99, @games_collection.average_goals_per_game
  end

  def test_it_can_select_all_games_in_given_season
    assert_equal 4, @games_collection.all_games_in_season("20162017").length
    assert_equal 16, @games_collection.all_games_in_season("20142015").length
  end

  def test_it_can_return_hash_of_average_goals_by_season
    expected_hash = {
      "20122013"=>3.9,
      "20162017"=>4.75,
      "20142015"=>3.75,
      "20152016"=>3.88,
      "20132014"=>4.67
    }
    assert_equal expected_hash, @games_collection.average_goals_by_season
  end

  def test_it_can_tell_us_each_unique_home_team_id
    #this validates that we're getting a condensed list of teams
    assert_equal 22, @games_collection.home_teams.length
  end

  def test_it_can_tell_us_total_team_home_goals
    assert_equal 12, @games_collection.total_home_goals("6")
  end

  def test_it_can_tell_us_total_team_home_games
    assert_equal 5, @games_collection.total_home_games("6")
  end

  def test_it_can_tell_us_each_unique_away_team_id
    assert_equal 24, @games_collection.away_teams.length
  end

  def test_it_can_calculate_average_home_score_of_given_team
    assert_equal 2.4, @games_collection.average_home_score_of_team("6")
  end

  def test_it_can_tell_us_highest_scoring_home_team
    assert_equal "25", @games_collection.highest_scoring_home_team
  end

  def test_it_can_tell_us_highest_scoring_visitor
    assert_equal "6", @games_collection.highest_scoring_visitor
  end

  def test_it_can_tell_us_lowest_scoring_home_team
    assert_equal "4", @games_collection.lowest_scoring_home_team
  end

  def test_it_can_tell_us_lowest_scoring_visitor
    assert_equal "2", @games_collection.lowest_scoring_visitor
  end


  # calculate: (total_wins_for_a_team_id / total_games_for_a_team_id)
  # calculate win percentage for given_set_of_games
  # get all games in a particular season (team_game_list)
  # calculate win_percentage for a given_season for a team_id
  # get list of unique seasons
  # for each season, calcul;ate win percentage for a given team
  # get highest
  # get lowest

  def test_it_knows_all_the_games_per_teams

    expected = [
      @games_collection.games[39],
      @games_collection.games[40],
      @games_collection.games[41],
      @games_collection.games[42],
      @games_collection.games[43],
      @games_collection.games[44]
    ]

    assert_equal expected, @games_collection.games_with_team("2").sort_by { |game| game.game_id}
  end

  def test_it_can_tell_away_win
    assert_equal true, @games_collection.away_win?(@games_collection.games[3])
    assert_equal false, @games_collection.away_win?(@games_collection.games[0])
  end

  def test_it_can_count_away_wins
    assert_equal 0, @games_collection.total_away_wins("2", "20122013")
  end

  def test_it_can_count_home_wins
    assert_equal 2, @games_collection.total_home_wins("2", "20122013")
  end

  def test_it_can_count_total_team_wins
    assert_equal 2, @games_collection.total_team_wins("2", "20122013")
  end

  def test_it_can_calculate_win_percentage_for_a_team
    assert_equal 0.33, @games_collection.team_win_percentage("2", "20122013")
  end

  def test_it_can_list_seasons
    expected = [
      "20122013",
      "20162017",
      "20142015",
      "20152016",
      "20132014"
    ]
    assert_equal expected, @games_collection.unique_seasons
  end

  def test_it_can_list_seasons_a_team_played_in
    assert_equal ["20122013", "20152016", "20142015"], @games_collection.team_seasons("5")
  end

  def test_it_can_tell_us_best_season_for_given_team
    assert_equal "20152016", @games_collection.best_season("5")
  end

  def test_it_can_tell_us_worst_season_for_given_team
    assert_equal "20142015", @games_collection.worst_season("5")
  end

  def test_it_can_generate_season_sub_type_summary
    expected = {
                  win_percentage: 0.20,
                  total_goals_scored: 9,
                  total_goals_against: 14,
                  average_goals_scored: 1.80,
                  average_goals_against: 2.80
               }
    assert_equal expected, @games_collection.season_sub_type_summary("8", "20122013", "Postseason")
  end

  def test_it_can_generate_single_season_summary_for_given_team
    expected = {
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
               }
    assert_equal expected, @games_collection.season_summary("15", "20122013")
  end

  def test_it_can_generate_multi_season_seasonal_summary_for_given_team
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
    assert_equal expected, @games_collection.seasonal_summary("15")
  end

  def test_it_can_find_the_home_goals_if_away_team
    assert_equal 8, @games_collection.find_opponents_goals_if_away_team("2")
  end

  def test_it_can_find_the_away_goals_if_home_team
    assert_equal 7, @games_collection.find_opponents_goals_if_home_team("2")
  end

  def test_it_can_get_total_opponents_goals
    assert_equal 15, @games_collection.total_opponent_goals("2")
  end

  def test_it_can_find_average_of_opponenets_goals_given_team
    assert_equal 2.5, @games_collection.average_goals_of_opponent("2")
  end

  def test_it_can_get_total_wins_across_seasons
    assert_equal 8, @games_collection.total_wins_across_seasons("5")
  end

  def test_it_can_calculate_average_win_percentage_across_seasons
    assert_equal 0.40, @games_collection.average_win_percentage("5")
  end

  def test_it_can_count_number_of_ties_of_team_in_given_season
    assert_equal 1, @games_collection.total_team_ties_in_season("5", "20152016")
  end

  def test_it_calculates_total_non_tie_games_for_team_in_season
    assert_equal 1, @games_collection.total_team_ties_in_season("9", "20122013")
    expected = @games_collection.games_with_team_in_season("9", "20122013").length - 1
    assert_equal expected, @games_collection.total_non_tie_games("9", "20122013")
  end

  def test_it_can_find_all_opponents_of_given_team
    assert_equal ["6", "2", "3"], @games_collection.team_opponents("5")
  end

  def test_it_can_get_all_games_between_two_teams
    expected_array_1 = [
                          @games_collection.games[5],
                          @games_collection.games[6],
                          @games_collection.games[7],
                          @games_collection.games[8]
                       ]
    assert_equal expected_array_1, @games_collection.games_between("5", "6").sort_by {|game| game.game_id}
    expected_array_2 = [
                          @games_collection.games[39],
                          @games_collection.games[40],
                          @games_collection.games[41],
                          @games_collection.games[42],
                          @games_collection.games[43],
                          @games_collection.games[44]
                       ]
    assert_equal expected_array_2, @games_collection.games_between("5", "2").sort_by {|game| game.game_id}
    expected_array_3 = [
                          @games_collection.games[89],
                          @games_collection.games[90],
                          @games_collection.games[91],
                          @games_collection.games[92],
                          @games_collection.games[93],
                          @games_collection.games[67],
                          @games_collection.games[68],
                          @games_collection.games[69],
                          @games_collection.games[70],
                          @games_collection.games[71]

                       ]
    assert_equal expected_array_3, @games_collection.games_between("5", "3").sort_by {|game| game.game_id}
  end

  def test_it_can_total_wins_of_one_team_against_another
    assert_equal 4, @games_collection.total_wins_against("6", "5")
    assert_equal 0, @games_collection.total_wins_against("5", "6")
    assert_equal 2, @games_collection.total_wins_against("2", "5")
    assert_equal 4, @games_collection.total_wins_against("5", "2")
    assert_equal 5, @games_collection.total_wins_against("3", "5")
    assert_equal 4, @games_collection.total_wins_against("5", "3")
  end

  def test_it_can_total_games_between_two_teams
    assert_equal 4, @games_collection.total_games_between("6", "5")
    assert_equal 4, @games_collection.total_games_between("5", "6")
    assert_equal 6, @games_collection.total_games_between("2", "5")
    assert_equal 6, @games_collection.total_games_between("5", "2")
    assert_equal 10, @games_collection.total_games_between("3", "5")
    assert_equal 10, @games_collection.total_games_between("5", "3")
  end

  def test_it_calculates_win_percentage_of_one_team_against_another
    assert_equal 1.00, @games_collection.win_percentage_against("6", "5")
    assert_equal 0.00, @games_collection.win_percentage_against("5", "6")
    assert_equal 0.33, @games_collection.win_percentage_against("2", "5")
    assert_equal 0.67, @games_collection.win_percentage_against("5", "2")
    assert_equal 0.50, @games_collection.win_percentage_against("3", "5")
    assert_equal 0.40, @games_collection.win_percentage_against("5", "3")
  end

  def test_it_can_find_favorite_opponent_of_given_team
    assert_equal "2", @games_collection.favorite_opponent("5")
  end

  def test_in_can_find_rival_of_given_team
    assert_equal "6", @games_collection.rival("5")
  end

  def test_it_can_generate_head_to_head_hash_of_win_percentage_against_others
    expected_hash = {
                      "6" => 0.00,
                      "2" => 0.67,
                      "3" => 0.40
                    }
    assert_equal expected_hash, @games_collection.head_to_head("5")
  end

  def test_it_can_get_all_game_ids_of_games_in_given_season
    expected_array_1 = [
                        "2016030171",
                        "2016030172",
                        "2016030173",
                        "2016030174"
                     ]
    assert_equal expected_array_1, @games_collection.game_ids_in_season("20162017")
    expected_array_2 = [
                        "2014030411",
                        "2014030412",
                        "2014030413",
                        "2014030414",
                        "2014030415",
                        "2014030416",
                        "2014030131",
                        "2014030132",
                        "2014030133",
                        "2014030134",
                        "2014030135",
                        "2014030311",
                        "2014030312",
                        "2014030313",
                        "2014030314",
                        "2014030315"
                     ]
    assert_equal expected_array_2, @games_collection.game_ids_in_season("20142015")
  end

  def test_it_can_get_all_games_in_season_and_subtype
    expected_array_1 = [
                        @games_collection.games[77],
                        @games_collection.games[78],
                        @games_collection.games[79],
                        @games_collection.games[80],
                        @games_collection.games[81],
                        @games_collection.games[82]
                       ]
    assert_equal expected_array_1, @games_collection.all_games_in_season_and_type("20132014", "Postseason")
    expected_array_2 = [
                        @games_collection.games[101],
                        @games_collection.games[102],
                        @games_collection.games[103],
                        @games_collection.games[106],
                        @games_collection.games[107],
                        @games_collection.games[110]
                       ]
    assert_equal expected_array_2, @games_collection.all_games_in_season_and_type("20132014", "Regular Season")
  end

  def test_it_can_get_all_game_ids_of_games_in_given_season_and_type
    expected_array_1 = [
                        "2013030161",
                        "2013030162",
                        "2013030163",
                        "2013030164",
                        "2013030165",
                        "2013030166"
                       ]
    assert_equal expected_array_1, @games_collection.game_ids_in_season_and_type("20132014", "Postseason")
    expected_array_2 = [
                        "2013020727",
                        "2013020010",
                        "2013020920",
                        "2013020444",
                        "2013021105",
                        "2013020357"
                       ]
    assert_equal expected_array_2, @games_collection.game_ids_in_season_and_type("20132014", "Regular Season")
  end

  def test_it_can_find_games_of_given_team_in_given_season_and_subtype
    expected_array_1 = [
      @games_collection.games[99],
      @games_collection.games[100],
      @games_collection.games[109]
    ]
    assert_equal expected_array_1, @games_collection.team_games_in_season_and_type("23", "20122013", "Regular Season")
    expected_array_2 = [
      @games_collection.games[16],
      @games_collection.games[17],
      @games_collection.games[18],
      @games_collection.games[19],
      @games_collection.games[20]
    ]
    assert_equal expected_array_2, @games_collection.team_games_in_season_and_type("8", "20122013", "Postseason")
  end

  def test_it_can_find_team_wins_in_season_and_type
    assert_equal 1, @games_collection.team_wins_in_season_and_type("8", "20122013", "Postseason")
    assert_equal 0, @games_collection.team_wins_in_season_and_type("23", "20122013", "Regular Season")
  end

  def test_it_can_total_team_games_in_season_and_type
    assert_equal 5, @games_collection.team_games_denominator("8", "20122013", "Postseason")
    assert_equal 3, @games_collection.team_games_denominator("23", "20122013", "Regular Season")
  end

  def test_it_can_calculate_win_percentage_for_a_team_in_season_and_type
    assert_equal 0.20, @games_collection.team_win_percentage_in_season_and_type("8", "20122013", "Postseason")
    assert_equal 0.00, @games_collection.team_win_percentage_in_season_and_type("23", "20122013", "Regular Season")
  end

  def test_it_can_total_team_goals_in_season_and_type
    assert_equal 9, @games_collection.total_team_goals_in_season_and_type("8", "20122013", "Postseason")
    assert_equal 4, @games_collection.total_team_goals_in_season_and_type("23", "20122013", "Regular Season")
  end

  def test_it_can_total_opponent_goals_of_team_in_season_and_type
    assert_equal 14, @games_collection.total_opponent_goals_in_season_and_type("8", "20122013", "Postseason")
    assert_equal 6, @games_collection.total_opponent_goals_in_season_and_type("23", "20122013", "Regular Season")
  end

  def test_it_can_calculate_average_goals_of_team_in_season_and_type
    assert_equal 1.80, @games_collection.avg_team_goals_in_season_and_type("8", "20122013", "Postseason")
    assert_equal 1.33, @games_collection.avg_team_goals_in_season_and_type("23", "20122013", "Regular Season")
  end

  def test_it_can_calculate_average_goals_of_opponents_in_season_and_type
    assert_equal 2.80, @games_collection.avg_opponent_goals_in_season_and_type("8", "20122013", "Postseason")
    assert_equal 2.00, @games_collection.avg_opponent_goals_in_season_and_type("23", "20122013", "Regular Season")
  end

  def test_it_can_convert_type_to_symbol
    assert_equal :regular_season, @games_collection.type_to_symbol("Regular Season")
    assert_equal :postseason, @games_collection.type_to_symbol("Postseason")
  end
end
