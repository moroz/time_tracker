defmodule TimeTrackerWeb.RestrictAccess do
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]
  alias TimeTrackerWeb.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, _) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> put_flash(:alert, "Please sign in to continue.")
        |> redirect(to: Routes.sign_in_path(conn, :new))

      %TimeTracker.Users.User{} ->
        conn
    end
  end
end
