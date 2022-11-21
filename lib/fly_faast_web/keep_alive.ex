defmodule FlyFaastWeb.KeepAlive do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    FlyFaast.Janitor.boop()
    conn
  end
end
