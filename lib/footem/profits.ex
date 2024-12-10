defmodule Footem.Accounts.Profits do
  import Ecto.Query
  alias Footem.Repo
  alias Footem.Accounts.Bet

  @doc """
  Calculates the profits for a given user.
  The profit is the total winnings minus the total bet amount.
  """
  def calculate_user_profit(user_id) do
    user_bets = Repo.all(from b in Bet, where: b.user_id == ^user_id)

    total_bet_amount = Enum.reduce(user_bets, Decimal.new(0), fn bet, acc ->
      Decimal.add(acc, bet.bet_amount)
    end)

    total_potential_winnings = Enum.reduce(user_bets, Decimal.new(0), fn bet, acc ->
      Decimal.add(acc, bet.potential_winnings)
    end)

    # Use status to determine losses
    total_losses = Enum.reduce(user_bets, Decimal.new(0), fn bet, acc ->
      if bet.status == "lost" do
        Decimal.add(acc, bet.bet_amount)
      else
        acc
      end
    end)

    total_winnings = Decimal.sub(total_potential_winnings, total_losses)
    profit = Decimal.sub(total_winnings, total_bet_amount)

    profit
  end
end
