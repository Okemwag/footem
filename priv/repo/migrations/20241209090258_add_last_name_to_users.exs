defmodule Footem.Repo.Migrations.AddLastNameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :last_name, :string
    end

  end
end
