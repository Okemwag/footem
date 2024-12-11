defmodule Footem.Repo.Migrations.UpdateBetsTable do
  use Ecto.Migration

  def change do
    alter table(:bets) do
      remove :bet_type
      remove :potential_winnings
      add :result, :string
    end
  end
end
