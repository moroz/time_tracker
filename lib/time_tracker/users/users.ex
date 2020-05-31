defmodule TimeTracker.Users do
  import Ecto.Query, warn: false
  alias TimeTracker.Repo

  alias TimeTracker.Users.User

  def get_user_by_id!(id), do: Repo.get!(User, id)

  def authenticate_user_by_email_password(email, password)
      when is_binary(email) and is_binary(password) do
    User
    |> Repo.get_by(email: email)
    |> Argon2.check_pass(password)
  end

  def create_user(params) do
    %User{}
    |> User.registration_changeset(params)
    |> Repo.insert()
  end

  def change_user(user) do
    User.changeset(user, %{})
  end
end
