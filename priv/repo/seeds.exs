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

defmodule Footem.Repo.Seeds do
  alias Footem.Accounts.User

  def seed_admin_user do
    %User{}
    |> User.changeset(%{
      email: "info@admin.footem",
      password: "Meta2Pl0it",
      role: "admin"
    })
    |> Footem.Repo.insert!()
  end
end
