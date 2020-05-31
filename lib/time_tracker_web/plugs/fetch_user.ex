defmodule TimeTrackerWeb.FetchUser do
  import Plug.Conn
  alias TimeTracker.Users

  def init(default), do: default

  def call(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn

      id when is_binary(id) or is_integer(id) ->
        user = Users.get_user_by_id!(id)
        assign(conn, :current_user, user)
    end
  end
end
