defmodule TimeTracker.Entries do
  @moduledoc """
  The Entries context.
  """

  import Ecto.Query, warn: false
  alias TimeTracker.Repo
  alias TimeTracker.Users.User

  alias TimeTracker.Entries.Entry

  @doc """
  Returns the list of entries.

  ## Examples

      iex> list_entries()
      [%Entry{}, ...]

  """
  def list_entries do
    Repo.all(Entry)
  end

  def list_user_entries(%User{id: user_id}) do
    from(e in Entry, where: e.user_id == ^user_id)
    |> order_by([e], desc: e.start_time)
    |> Repo.all()
  end

  def user_total_time(%User{id: user_id}) do
    secs =
      from(e in Entry, where: e.user_id == ^user_id)
      |> select([e], sum(e.end_time - e.start_time))
      |> Repo.one()
      |> Map.get(:secs)

    secs / 3600.0
  end

  def list_user_entries_for_period(%User{id: id}, beginning_of_month) do
    from(e in Entry, where: e.user_id == ^id)
    |> order_by([e], desc: e.start_time)
    |> where(
      [e],
      fragment(
        "? between ? and ?",
        e.start_time,
        ^beginning_of_month,
        ^Timex.end_of_month(beginning_of_month)
      )
    )
    |> Repo.all()
  end

  def user_total_time_for_period(%User{id: id}, beginning_of_month) do
    secs =
      from(e in Entry, where: e.user_id == ^id)
      |> where(
        [e],
        fragment(
          "? between ? and ?",
          e.start_time,
          ^beginning_of_month,
          ^Timex.end_of_month(beginning_of_month)
        )
      )
      |> select([e], sum(e.end_time - e.start_time))
      |> Repo.one()
      |> Map.get(:secs)

    secs / 3600.0
  end

  @doc """
  Gets a single entry.

  Raises `Ecto.NoResultsError` if the Entry does not exist.

  ## Examples

      iex> get_entry!(123)
      %Entry{}

      iex> get_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_entry!(id), do: Repo.get!(Entry, id)

  @doc """
  Creates a entry.

  ## Examples

      iex> create_entry(%{field: value})
      {:ok, %Entry{}}

      iex> create_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_entry(attrs \\ %{}) do
    %Entry{}
    |> Entry.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_entry(%User{} = user, attrs \\ %{}) do
    %Entry{user_id: user.id}
    |> Entry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a entry.

  ## Examples

      iex> update_entry(entry, %{field: new_value})
      {:ok, %Entry{}}

      iex> update_entry(entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_entry(%Entry{} = entry, attrs) do
    entry
    |> Entry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a entry.

  ## Examples

      iex> delete_entry(entry)
      {:ok, %Entry{}}

      iex> delete_entry(entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_entry(%Entry{} = entry) do
    Repo.delete(entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking entry changes.

  ## Examples

      iex> change_entry(entry)
      %Ecto.Changeset{data: %Entry{}}

  """
  def change_entry(%Entry{} = entry, attrs \\ %{}) do
    Entry.changeset(entry, attrs)
  end
end
