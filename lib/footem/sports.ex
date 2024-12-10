defmodule Footem.Sports do
  @moduledoc """
  The Sports context.
  """

  import Ecto.Query, warn: false
  alias Footem.Repo

  alias Footem.Sports.Game

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  # This is an admin-only function

  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end


  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end
  @doc """
  Creates a game with admin privileges.
  Only admins and superadmins should be able to call this function.

  ## Examples

      iex> create_game_as_admin(%{field: value}, admin_user)
      {:ok, %Game{}}

      iex> create_game_as_admin(%{field: bad_value}, admin_user)
      {:error, %Ecto.Changeset{}}

  """
  def create_game_as_admin(attrs \\ %{}, user) when user.role in ["admin", "superadmin"] do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game with admin privileges.
  Only admins and superadmins should be able to call this function.

  ## Examples

      iex> update_game_as_admin(game, %{field: new_value}, admin_user)
      {:ok, %Game{}}

      iex> update_game_as_admin(game, %{field: bad_value}, admin_user)
      {:error, %Ecto.Changeset{}}

  """
  def update_game_as_admin(%Game{} = game, attrs, user) when user.role in ["admin", "superadmin"] do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game with admin privileges.
  Only admins and superadmins should be able to call this function.

  ## Examples

      iex> delete_game_as_admin(game, admin_user)
      {:ok, %Game{}}

      iex> delete_game_as_admin(game, admin_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game_as_admin(%Game{} = game, user) when user.role in ["admin", "superadmin"] do
    Repo.delete(game)
  end
end


#   alias Footem.Sports.Game

#   @doc """
#   Returns the list of games.

#   ## Examples

#       iex> list_games()
#       [%Game{}, ...]

#   """
#   def list_games do
#     Repo.all(Game)
#   end

#   @doc """
#   Gets a single game.

#   Raises `Ecto.NoResultsError` if the Game does not exist.

#   ## Examples

#       iex> get_game!(123)
#       %Game{}

#       iex> get_game!(456)
#       ** (Ecto.NoResultsError)

#   """
#   def get_game!(id), do: Repo.get!(Game, id)

#   @doc """
#   Creates a game.

#   ## Examples

#       iex> create_game(%{field: value})
#       {:ok, %Game{}}

#       iex> create_game(%{field: bad_value})
#       {:error, %Ecto.Changeset{}}

#   """
#   def create_game(attrs \\ %{}) do
#     %Game{}
#     |> Game.changeset(attrs)
#     |> Repo.insert()
#   end

#   @doc """
#   Updates a game.

#   ## Examples

#       iex> update_game(game, %{field: new_value})
#       {:ok, %Game{}}

#       iex> update_game(game, %{field: bad_value})
#       {:error, %Ecto.Changeset{}}

#   """
#   def update_game(%Game{} = game, attrs) do
#     game
#     |> Game.changeset(attrs)
#     |> Repo.update()
#   end

#   @doc """
#   Deletes a game.

#   ## Examples

#       iex> delete_game(game)
#       {:ok, %Game{}}

#       iex> delete_game(game)
#       {:error, %Ecto.Changeset{}}

#   """
#   def delete_game(%Game{} = game) do
#     Repo.delete(game)
#   end

#   @doc """
#   Returns an `%Ecto.Changeset{}` for tracking game changes.

#   ## Examples

#       iex> change_game(game)
#       %Ecto.Changeset{data: %Game{}}

#   """
#   def change_game(%Game{} = game, attrs \\ %{}) do
#     Game.changeset(game, attrs)
#   end
# end
