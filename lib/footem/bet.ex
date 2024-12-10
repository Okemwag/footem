defmodule Accounts.BetService do
  alias Footem.Accounts.{User, Bet}
  alias Footem.Workers.BetNotificationWorker
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

  defp validate_game_odds(game, %{bet_type: bet_type}) do
    case bet_type do
      "home_team" -> {:ok, game.home_team_odds}
      "away_team" -> {:ok, game.away_team_odds}
      "draw" -> {:ok, game.draw_odds}
      _ -> {:error, "Invalid bet type"}
    end
  end

  defp calculate_potential_winnings(bet_amount, odds) do
    potential_winnings = Decimal.mult(bet_amount, odds)
    {:ok, potential_winnings}
  end

  def settle_bet(bet, result) do
    Repo.transaction(fn ->
      bet = Repo.preload(bet, :user)

      cond do
        result == bet.bet_type ->
          # Winning bet - credit potential winnings
          bet.user
          |> User.wallet_changeset(%{
            wallet: Decimal.add(bet.user.wallet, bet.potential_winnings)
          })
          |> Repo.update!()

          bet
          |> Bet.changeset(%{status: "won"})
          |> Repo.update!()

        true ->
          # Losing bet - already deducted initial amount
          updated_bet = bet
          |> Bet.changeset(%{status: "lost"})
          |> Repo.update!()

          # Queue email notification
          %{bet_id: updated_bet.id}
          |> BetNotificationWorker.new()
          |> Oban.insert()

          updated_bet
      end
    end)
  end
end
