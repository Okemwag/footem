defmodule Footem.SportsTest do
  use Footem.DataCase

  alias Footem.Sports

  describe "games" do
    alias Footem.Sports.Game

    import Footem.SportsFixtures

    @invalid_attrs %{status: nil, sport_type: nil, home_team: nil, away_team: nil, start_time: nil, home_team_odds: nil, away_team_odds: nil, draw_odds: nil}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Sports.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Sports.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{status: "some status", sport_type: "some sport_type", home_team: "some home_team", away_team: "some away_team", start_time: ~U[2024-12-08 09:30:00Z], home_team_odds: "120.5", away_team_odds: "120.5", draw_odds: "120.5"}

      assert {:ok, %Game{} = game} = Sports.create_game(valid_attrs)
      assert game.status == "some status"
      assert game.sport_type == "some sport_type"
      assert game.home_team == "some home_team"
      assert game.away_team == "some away_team"
      assert game.start_time == ~U[2024-12-08 09:30:00Z]
      assert game.home_team_odds == Decimal.new("120.5")
      assert game.away_team_odds == Decimal.new("120.5")
      assert game.draw_odds == Decimal.new("120.5")
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sports.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{status: "some updated status", sport_type: "some updated sport_type", home_team: "some updated home_team", away_team: "some updated away_team", start_time: ~U[2024-12-09 09:30:00Z], home_team_odds: "456.7", away_team_odds: "456.7", draw_odds: "456.7"}

      assert {:ok, %Game{} = game} = Sports.update_game(game, update_attrs)
      assert game.status == "some updated status"
      assert game.sport_type == "some updated sport_type"
      assert game.home_team == "some updated home_team"
      assert game.away_team == "some updated away_team"
      assert game.start_time == ~U[2024-12-09 09:30:00Z]
      assert game.home_team_odds == Decimal.new("456.7")
      assert game.away_team_odds == Decimal.new("456.7")
      assert game.draw_odds == Decimal.new("456.7")
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Sports.update_game(game, @invalid_attrs)
      assert game == Sports.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Sports.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Sports.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Sports.change_game(game)
    end
  end
end
