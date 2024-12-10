defmodule Footem.Workers.BetNotificationWorker do
  use Oban.Worker, queue: :emails

  alias Footem.{Repo, Accounts, Emails, Mailer}

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"bet_id" => bet_id}}) do
    bet =
      Accounts.get_bet!(bet_id)
      |> Repo.preload([:user, :game])

    bet.user
    |> Emails.bet_lost_notification(bet)
    |> Mailer.deliver()

    :ok
  end
end
