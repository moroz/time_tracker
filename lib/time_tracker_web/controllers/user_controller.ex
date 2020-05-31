defmodule TimeTrackerWeb.UserController do
  use TimeTrackerWeb, :controller
  alias TimeTracker.Users

  def new(conn, _) do
    changeset = Users.change_user(%Users.User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:notice, "You have been successfully registered.")
        |> redirect(to: "/")

      {:error, changeset = %Ecto.Changeset{}} ->
        conn
        |> put_flash(:alert, "Please review the errors in the form below and try again.")
        |> render("new.html", changeset: changeset)
    end
  end
end
