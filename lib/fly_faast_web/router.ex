defmodule FlyFaastWeb.Router do
  use FlyFaastWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug FlyFaastWeb.KeepAlive
  end

  scope "/api", FlyFaastWeb do
    pipe_through :api

    get "/hello", FunctionController, :hello
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:fly_faast, :dev_routes) do

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
