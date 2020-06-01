defmodule TimeTrackerWeb.EntryController do
  use TimeTrackerWeb, :controller

  alias TimeTracker.Entries
  alias TimeTracker.Entries.Entry

  def index(conn, params) do
    period = period_from_params(params)
    user = conn.assigns.current_user
    entries = Entries.list_user_entries_for_period(user, period)
    total = Entries.user_total_time_for_period(user, period)
    render(conn, "index.html", entries: entries, total: total, user: user, period: period)
  end

  defp period_from_params(%{"month" => month, "year" => year}) do
    {
      String.to_integer(year),
      String.to_integer(month),
      1
    }
    |> Timex.to_datetime()
  end

  defp period_from_params(_) do
    Timex.local() |> Timex.beginning_of_month()
  end

  def new(conn, _params) do
    changeset = Entries.change_entry(%Entry{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"entry" => entry_params}) do
    case Entries.create_user_entry(conn.assigns.current_user, entry_params) do
      {:ok, _entry} ->
        conn
        |> put_flash(:info, "Entry created successfully.")
        |> redirect(to: Routes.entry_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    entry = Entries.get_entry!(id)
    render(conn, "show.html", entry: entry)
  end

  def edit(conn, %{"id" => id}) do
    entry = Entries.get_entry!(id)
    changeset = Entries.change_entry(entry)
    render(conn, "edit.html", entry: entry, changeset: changeset)
  end

  def update(conn, %{"id" => id, "entry" => entry_params}) do
    entry = Entries.get_entry!(id)

    case Entries.update_entry(entry, entry_params) do
      {:ok, entry} ->
        conn
        |> put_flash(:info, "Entry updated successfully.")
        |> redirect(to: Routes.entry_path(conn, :show, entry))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", entry: entry, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    entry = Entries.get_entry!(id)
    {:ok, _entry} = Entries.delete_entry(entry)

    conn
    |> put_flash(:info, "Entry deleted successfully.")
    |> redirect(to: Routes.entry_path(conn, :index))
  end
end
