defmodule Footem.Workers.BetNotificationWorker do
  use Oban.Worker, queue: :emails, priority: 10

  alias Footem.{Repo, Accounts, Emails, Mailer}

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"bet_id" => bet_id}}) do
    bet =
      Accounts.get_bet!(bet_id)
      |> Repo.preload([:user, :game])

    # Only send the email if the bet status is "lost"
    if bet.status == "lost" do
      bet.user
      |> Emails.bet_lost_notification(bet)
      |> Mailer.deliver()
    end

    :ok
  end
end
