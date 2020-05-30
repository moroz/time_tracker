defmodule TimeTrackerWeb.PageController do
  use TimeTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
