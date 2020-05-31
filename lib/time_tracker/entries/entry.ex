defmodule TimeTracker.Entries.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  @cast ~w(start_time end_time description date start_time_raw end_time_raw)a
  @required ~w(description end_time start_time)a

  schema "entries" do
    field :description, :string
    field :end_time, :utc_datetime
    field :start_time, :utc_datetime

    field :date, :date, virtual: true, autogenerate: {__MODULE__, :get_today}
    field :start_time_raw, :time, virtual: true
    field :end_time_raw, :time, virtual: true

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, @cast)
    |> make_time()
    |> validate_required(@required)
  end

  def get_today do
    Timex.local() |> Timex.to_date()
  end

  defp combine_date_and_time(%Date{} = date, %Time{} = time) do
    with {:ok, naive} <- NaiveDateTime.new(date, time) do
      naive
      |> Timex.to_datetime(Timex.Timezone.local())
      |> Timex.Timezone.convert("Etc/UTC")
    end
  end

  defp combine_date_and_time(_, _), do: nil

  defp maybe_put_time(changeset, _key, nil), do: changeset

  defp maybe_put_time(changeset, key, time) do
    put_change(changeset, key, time)
  end

  defp make_time(changeset) do
    date = get_field(changeset, :date)
    start_time = get_field(changeset, :start_time_raw)
    end_time = get_field(changeset, :end_time_raw)
    start_time = combine_date_and_time(date, start_time)
    end_time = combine_date_and_time(date, end_time)

    changeset
    |> maybe_put_time(:start_time, start_time)
    |> maybe_put_time(:end_time, end_time)
  end
end
