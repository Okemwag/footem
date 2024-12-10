defmodule FootemWeb.AdminLive.Index do
  use FootemWeb, :live_view
  alias Footem.Accounts
  alias Footem.Sports

  @impl true
  def mount(_params, %{"user_token" => user_token} = _session, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)

    if current_user && (current_user.role in ["admin", "superadmin"]) do
      users = Accounts.list_users()
      games = Sports.list_games()
      profits = Footem.Accounts.Profits.calculate_user_profit(current_user.id)

      {:ok,
      socket
      |> assign(:current_user, current_user)
      |> assign(:users, users)
      |> assign(:games, games)
      |> assign(:profits, profits)  # Assign the calculated profits
      |> assign(:page_title, "Admin Dashboard")
      |> assign(:selected_tab, "games")
      |> assign(:show_new_game_form, false)}
    else
      {:ok,
      socket
      |> put_flash(:error, "Unauthorized access")
      |> redirect(to: "/")}
    end
  end


  @impl true
  def handle_event("switch-tab", %{"tab" => tab}, socket) do
    new_socket =
      case tab do
        "games" ->
          assign(socket, :show_new_game_form, false)
        _ ->
          socket
      end

    {:noreply, assign(new_socket, :selected_tab, tab)}
  end

  @impl true
  def handle_event("new-game", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_new_game_form, true)}
  end

  @impl true
  def handle_event("create-game", %{"game" => game_params}, socket) do
    current_user = socket.assigns[:current_user]

    case Sports.create_game_as_admin(game_params, current_user) do
      {:ok, _game} ->
        {:noreply,
         socket
         |> put_flash(:info, "Game created successfully!")
         |> assign(:games, Sports.list_games())
         |> assign(:show_new_game_form, false)}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to create game")
         |> assign(:games, Sports.list_games())}
    end
  end

  @impl true
  def handle_event("update-game", %{"game-id" => game_id, "game" => game_params}, socket) do
    current_user = socket.assigns[:current_user]
    game = Sports.get_game!(game_id)

    case Sports.update_game_as_admin(game, game_params, current_user) do
      {:ok, _game} ->
        {:noreply,
         socket
         |> put_flash(:info, "Game updated successfully!")
         |> assign(:games, Sports.list_games())}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to update game")
         |> assign(:games, Sports.list_games())}
    end
  end

  @impl true
  def handle_event("delete-game", %{"game-id" => game_id}, socket) do
    current_user = socket.assigns[:current_user]
    game = Sports.get_game!(game_id)

    case Sports.delete_game_as_admin(game, current_user) do
      {:ok, _game} ->
        {:noreply,
         socket
         |> put_flash(:info, "Game deleted successfully!")
         |> assign(:games, Sports.list_games())}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to delete game")
         |> assign(:games, Sports.list_games())}
    end
  end
end
