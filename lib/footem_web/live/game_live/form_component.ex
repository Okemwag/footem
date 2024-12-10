# lib/footem_web/live/game_live/form_component.ex
defmodule FootemWeb.GameLive.FormComponent do
  use FootemWeb, :live_component

  alias Footem.Sports

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage game records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="game-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:sport_type]} type="text" label="Sport type" />
        <.input field={@form[:home_team]} type="text" label="Home team" />
        <.input field={@form[:away_team]} type="text" label="Away team" />
        <.input field={@form[:start_time]} type="datetime-local" label="Start time" />
        <.input field={@form[:status]} type="text" label="Status" />
        <.input field={@form[:home_team_odds]} type="number" label="Home team odds" step="any" />
        <.input field={@form[:away_team_odds]} type="number" label="Away team odds" step="any" />
        <.input field={@form[:draw_odds]} type="number" label="Draw odds" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Game</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{game: game} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Sports.change_game(game))
     end)}
  end

  @impl true
  def handle_event("validate", %{"game" => game_params}, socket) do
    changeset = Sports.change_game(socket.assigns.game, game_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"game" => game_params}, socket) do
    save_game(socket, socket.assigns.action, game_params)
  end

  defp save_game(socket, :edit, game_params) do
    case Sports.update_game(socket.assigns.game, game_params) do
      {:ok, game} ->
        notify_parent({:saved, game})

        {:noreply,
         socket
         |> put_flash(:info, "Game updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_game(socket, :new, game_params) do
    case Sports.create_game(game_params) do
      {:ok, game} ->
        notify_parent({:saved, game})

        {:noreply,
         socket
         |> put_flash(:info, "Game created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
