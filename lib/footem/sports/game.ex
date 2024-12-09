defmodule Footem.Sports.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :status, :string
    field :sport_type, :string
    field :home_team, :string
    field :away_team, :string
    field :start_time, :utc_datetime
    field :home_team_odds, :decimal
    field :away_team_odds, :decimal
    field :draw_odds, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:sport_type, :home_team, :away_team, :start_time, :status, :home_team_odds, :away_team_odds, :draw_odds])
    |> validate_required([:sport_type, :home_team, :away_team, :start_time, :status, :home_team_odds, :away_team_odds, :draw_odds])
  end
end
