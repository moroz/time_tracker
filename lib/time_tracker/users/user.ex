defmodule TimeTracker.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required ~w(email display_name)a
  @cast @required ++ ~w(password_confirmation password)a

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :display_name

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @cast)
    |> validate_required(@required)
    |> EmailTldValidator.Ecto.validate_email()
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  def registration_changeset(user, attrs) do
    changeset(user, attrs)
    |> validate_required([:password, :password_confirmation])
    |> validate_format(
      :password,
      ~r/^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{10,}$/,
      message: "Password too weak."
    )
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
