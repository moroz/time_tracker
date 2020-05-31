defmodule TimeTrackerWeb.FetchUser do
  import Plug.Conn
  alias TimeTracker.Users

  def init(default), do: default

  def call(conn, _) do
    user =
      case get_session(conn, :user_id) do
        id when is_binary(id) or is_integer(id) ->
          Users.get_user_by_id!(id)

        _ ->
          nil
      end

    assign(conn, :current_user, user)
  end
end
