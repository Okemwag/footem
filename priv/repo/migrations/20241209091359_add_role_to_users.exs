defmodule Footem.Repo.Migrations.AddRoleToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :string, default: "user", null: false
    end

    create constraint(:users, :valid_roles,
      check: "role IN ('user', 'Admin', 'superadmin')")
  end
end
