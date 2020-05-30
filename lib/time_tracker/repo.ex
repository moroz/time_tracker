defmodule TimeTracker.Repo do
  use Ecto.Repo,
    otp_app: :time_tracker,
    adapter: Ecto.Adapters.Postgres
end
