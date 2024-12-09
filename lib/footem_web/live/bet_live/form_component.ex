defmodule FootemWeb.BetLive.FormComponent do
  use FootemWeb, :live_component

  alias Footem.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage bet records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="bet-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:bet_type]} type="text" label="Bet type" />
        <.input field={@form[:bet_amount]} type="number" label="Bet amount" step="any" />
        <.input field={@form[:potential_winnings]} type="number" label="Potential winnings" step="any" />
        <.input field={@form[:odds]} type="number" label="Odds" step="any" />
        <.input field={@form[:status]} type="text" label="Status" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Bet</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{bet: bet} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Accounts.change_bet(bet))
     end)}
  end

  @impl true
  def handle_event("validate", %{"bet" => bet_params}, socket) do
    changeset = Accounts.change_bet(socket.assigns.bet, bet_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"bet" => bet_params}, socket) do
    save_bet(socket, socket.assigns.action, bet_params)
  end

  defp save_bet(socket, :edit, bet_params) do
    case Accounts.update_bet(socket.assigns.bet, bet_params) do
      {:ok, bet} ->
        notify_parent({:saved, bet})

        {:noreply,
         socket
         |> put_flash(:info, "Bet updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_bet(socket, :new, bet_params) do
    case Accounts.create_bet(bet_params) do
      {:ok, bet} ->
        notify_parent({:saved, bet})

        {:noreply,
         socket
         |> put_flash(:info, "Bet created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
