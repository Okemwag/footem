defmodule Footem.Accounts.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bets" do
    field :status, :string
    field :bet_type, :string
    field :bet_amount, :decimal
    field :potential_winnings, :decimal
    field :odds, :decimal

    belongs_to :user, Accounts.User
    belongs_to :game, Sports.Game

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bet, attrs) do
    bet
    |> cast(attrs, [:bet_type, :bet_amount, :potential_winnings, :odds, :status])
    |> validate_required([:bet_type, :bet_amount, :potential_winnings, :odds, :status])
  end
end
