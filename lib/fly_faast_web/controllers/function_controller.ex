defmodule FlyFaastWeb.FunctionController do
  use FlyFaastWeb, :controller

  def hello(conn, _params) do
    json(conn, %{hello: :world})
  end
end
