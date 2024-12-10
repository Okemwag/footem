defmodule Footem.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:games) do
      add :sport_type, :string
      add :home_team, :string
      add :away_team, :string
      add :start_time, :utc_datetime
      add :status, :string
      add :home_team_odds, :decimal
      add :away_team_odds, :decimal
      add :draw_odds, :decimal

      timestamps(type: :utc_datetime)
    end
  end
end
