defmodule Footem.Repo.Migrations.AddIndexesToGames do
  use Ecto.Migration

  def change do
    create index(:games, [:sport_type])
    create index(:games, [:status])
    create index(:games, [:start_time])

  end
end
