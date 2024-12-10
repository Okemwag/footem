defmodule FootemWeb.GameLive.Show do
  use FootemWeb, :live_view

  alias Footem.Sports

  @impl true
  def mount(_params, session, socket) do
    current_user = get_current_user(session)
    {:ok, assign(socket, :current_user, current_user)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    game = Sports.get_game!(id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:game, game)}
  end

  defp page_title(:bet), do: "Place Bet"
  defp page_title(:show), do: "Show Game"
  defp page_title(:edit), do: "Edit Game"

  defp get_current_user(session) do
    case session do
      %{"user_token" => user_token} ->
        Footem.Accounts.get_user_by_session_token(user_token)
      _ ->
        nil
    end
  end
end
