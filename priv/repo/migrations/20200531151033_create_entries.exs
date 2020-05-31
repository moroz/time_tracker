defmodule TimeTracker.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :start_time, :utc_datetime, null: false
      add :end_time, :utc_datetime, null: false
      add :description, :string, null: false

      timestamps()
    end
  end
end
