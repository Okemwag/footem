defmodule Footem.Accounts.BetService do
  alias Footem.Accounts.{User, Bet}
  alias Footem.Repo

  def place_bet(user, game, bet_params) do
    Repo.transaction(fn ->
      with {:ok, bet_amount} <- validate_bet_amount(user, bet_params),
           {:ok, odds} <- validate_game_odds(game, bet_params),
           {:ok, potential_winnings} <- calculate_potential_winnings(bet_amount, odds) do

        # Deduct from wallet
        user
        |> User.wallet_changeset(%{wallet: Decimal.sub(user.wallet, bet_amount)})
        |> Repo.update!()

        # Create bet
        %Bet{}
        |> Bet.changeset(Map.merge(bet_params, %{
          user_id: user.id,
          game_id: game.id,
          potential_winnings: potential_winnings,
          status: "pending",
          odds: odds
        }))
        |> Repo.insert!()

        {:ok, :bet_placed}
      else
        {:error, reason} -> Repo.rollback(reason)
      end
    end)
  end

  defp validate_bet_amount(user, %{bet_amount: amount}) do
    amount = Decimal.new(amount)
    if Decimal.compare(amount, user.wallet) == :gt do
      {:error, "Insufficient funds"}
    else
      {:ok, amount}
    end
  end

  defp validate_game_odds(game, %{result: result}) do
    odds =
      case result do
        "Home" -> game.home_team_odds
        "Draw" -> game.draw_odds
        "Away" -> game.away_team_odds
        _ -> nil
      end

    if odds, do: {:ok, odds}, else: {:error, "Invalid bet result"}
  end

  defp calculate_potential_winnings(bet_amount, odds) do
    potential_winnings = Decimal.mult(bet_amount, odds)
    {:ok, potential_winnings}
  end
end
