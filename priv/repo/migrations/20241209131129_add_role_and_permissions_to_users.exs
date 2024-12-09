defmodule Footem.Repo.Migrations.AddRoleAndPermissionsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :custom_permissions, :map, default: %{}
    end
    
  end
end
