defmodule NetCleverWeb.RegisterLive do
  use NetCleverWeb, :live_view

  alias NetClever.Accounts
  alias NetClever.Accounts.User
  alias NetCleverWeb.UserAuth

  def mount(_p, _s, socket) do
    changeset = Accounts.change_user_registration(%User{})
    {:ok, assign(socket, changeset: changeset, trigger_submit: false)}
  end

  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.UserRegistrationView, "new.html", assigns)
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset = registration_changeset(params)
    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"user" => params}, socket) do
    changeset = registration_changeset(params)
    {:noreply, assign(socket, changeset: changeset, trigger_submit: changeset.valid?)}
  end

  defp registration_changeset(params) do
    %User{}
    |> Accounts.change_user_registration(params)
    |> Map.put(:action, :insert)
  end
end
