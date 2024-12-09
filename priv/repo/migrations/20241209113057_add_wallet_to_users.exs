defmodule Footem.Repo.Migrations.AddWalletToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :wallet, :decimal, default: 200.0
    end

  end
end
