# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Footem.Repo.insert!(%Footem.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Footem.Repo.Migrations.SeedAdminAndSuperadmin do
  use Ecto.Migration

  alias Footem.Repo
  alias Footem.Accounts.User

  def up do
    # Insert Admin user
    Repo.insert!(%User{
      email: "admin@footem.com",
      first_name: "Admin",
      last_name: "User",
      role: "admin",
      custom_permissions: %{
        "view_users" => true,
        "soft_delete_user" => true,
        "view_profits" => true
      },
      hashed_password: Bcrypt.hash_pwd_salt("M3taS3cur3P@ssw0rd")
    })

    # Insert Superadmin user
    Repo.insert!(%User{
      email: "superadmin@footem.com",
      first_name: "Super",
      last_name: "Admin",
      role: "superadmin",
      custom_permissions: %{
        "configure_games" => true,
        "grant_admin_access" => true,
        "revoke_admin_access" => true
      },
      hashed_password: Bcrypt.hash_pwd_salt("M3taS3cur3P@ssw0rd")
    })
  end

  def down do
    Repo.delete_all(User, where: [email: "admin@footem.com"])
    Repo.delete_all(User, where: [email: "superadmin@footem.com"])
  end
end
