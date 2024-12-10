defmodule Footem.SportsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Footem.Sports` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        away_team: "some away_team",
        away_team_odds: "120.5",
        draw_odds: "120.5",
        home_team: "some home_team",
        home_team_odds: "120.5",
        sport_type: "some sport_type",
        start_time: ~U[2024-12-08 09:30:00Z],
        status: "some status"
      })
      |> Footem.Sports.create_game()

    game
  end

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        away_team: "some away_team",
        away_team_odds: "120.5",
        draw_odds: "120.5",
        home_team: "some home_team",
        home_team_odds: "120.5",
        sport_type: "some sport_type",
        start_time: ~U[2024-12-09 11:05:00Z],
        status: "some status"
      })
      |> Footem.Sports.create_game()

    game
  end
end
