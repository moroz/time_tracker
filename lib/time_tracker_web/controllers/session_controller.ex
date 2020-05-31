defmodule TimeTrackerWeb.SessionController do
  use TimeTrackerWeb, :controller
  alias TimeTracker.Users

  def new(conn, _) do
    render(conn, "new.html")
  end

  def delete(conn, _) do
    conn
    |> clear_session()
    |> redirect(to: "/sign-in")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Users.authenticate_user_by_email_password(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:notice, "Welcome back, #{user.display_name}!")
        |> redirect(to: "/")

      _ ->
        conn
        |> put_flash(:error, "Wrong email or password.")
        |> redirect(to: Routes.sign_in_path(conn, :new))
    end
  end
end
