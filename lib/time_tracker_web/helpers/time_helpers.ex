defmodule TimeTrackerWeb.TimeHelpers do
  def format_date(time) do
    time
    |> Timex.local()
    |> Timex.format!("%m/%d", :strftime)
  end

  def format_time(time) do
    time
    |> Timex.local()
    |> Timex.format!("%H:%M %p", :strftime)
  end

  def format_duration(start_time, end_time) do
    mins = Timex.diff(end_time, start_time, :minutes)
    "#{mins / 60.0}h"
  end
end
