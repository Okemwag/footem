defmodule Footem.Repo.Migrations.CreateBets do
  use Ecto.Migration

  def change do
    create table(:bets) do
      add :bet_type, :string
      add :bet_amount, :decimal
      add :potential_winnings, :decimal
      add :odds, :decimal
      add :status, :string
      add :game_id, references(:games, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:bets, [:game_id])
    create index(:bets, [:user_id])
  end
end
