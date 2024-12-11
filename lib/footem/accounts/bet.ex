defmodule Footem.Accounts.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bets" do
    field :status, :string
    field :result, :string
    field :bet_amount, :decimal
    field :odds, :decimal

    belongs_to :user, Footem.Accounts.User
    belongs_to :game, Footem.Sports.Game

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bet, attrs) do
    bet
    |> cast(attrs, [:bet_amount, :odds, :status])
    |> validate_required([:bet_amount, :odds, :status])
  end

  @doc """
  A bet changeset for creating a bet.
  """
  def create_changeset(bet, attrs) do
    bet
    |> changeset(attrs)
    |> validate_required([:game_id, :user_id])
  end
end
