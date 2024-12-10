defmodule Footem.Emails do
  import Swoosh.Email

  def bet_lost_notification(user, bet) do
    new()
    |> to({user.name, user.email})
    |> from({"Footem Betting", "notifications@footem.com"})
    |> subject("Bet Result Notification")
    |> html_body("""
    <h2>Hello #{user.name},</h2>
    <p>Unfortunately, your bet on #{bet.game.home_team} vs #{bet.game.away_team} was not successful.</p>
    <p>Bet Details:</p>
    <ul>
      <li>Amount: #{bet.bet_amount}</li>
      <li>Type: #{bet.bet_type}</li>
      <li>Odds: #{bet.odds}</li>
    </ul>
    <p>Better luck next time!</p>
    """)
  end
end
