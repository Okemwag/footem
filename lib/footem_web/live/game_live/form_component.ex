defmodule FootemWeb.GameLive.FormComponent do
  use FootemWeb, :live_component
  alias Footem.Accounts.Bet

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div>
        <.button phx-click="place_bet" phx-value-result="Home"><%= @game.home_team %> (<%= @game.home_team_odds %>)</.button>
        <.button phx-click="place_bet" phx-value-result="Draw">Draw (<%= @game.draw_odds %>)</.button>
        <.button phx-click="place_bet" phx-value-result="Away"><%= @game.away_team %> (<%= @game.away_team_odds %>)</.button>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("place_bet", %{"result" => result}, socket) do
    # Handle the bet placement logic
    game = socket.assigns.game

    bet = %Bet{
      game_id: game.id,
      user_id: socket.assigns.current_user.id,
      result: result
    }

    case Bet.place_bet(bet) do
      {:ok, _bet} ->
        {:noreply,
         socket
         |> put_flash(:info, "Bet placed successfully on #{result}.")
         |> push_patch(to: Routes.live_path(socket, FootemWeb.GameLive.Index))}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> put_flash(:error, "Failed to place the bet.")}
    end
  end
end
