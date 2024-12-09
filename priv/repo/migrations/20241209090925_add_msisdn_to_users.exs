defmodule Footem.Repo.Migrations.AddMsisdnToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :msisdn, :string
    end

  end
end
