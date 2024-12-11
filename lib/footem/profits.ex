defmodule Footem.Accounts.Profits do
  import Ecto.Query
  alias Footem.Repo
  alias Footem.Accounts.Bet

  @doc """
  Calculates the profits for a given user.
  The profit is the total winnings minus the total bet amount.
  """
  def calculate_user_profit(user_id) do
     Repo.all(from b in Bet, where: b.user_id == ^user_id , where: b.status != "won", select: %{
      bet_amount: b.bet_amount,
      odds: b.odds,
      status: b.status,
      profit: b.bet_amount * b.odds
    })

  end
end
