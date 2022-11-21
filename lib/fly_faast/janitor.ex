defmodule FlyFaast.Janitor do
  use GenServer

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def boop() do
    GenServer.cast(__MODULE__, :boop)
  end

  def boop(timeout) do
    GenServer.cast(__MODULE__, {:boop, timeout})
  end

  @impl true
  def init(opts) do
    timeout = Application.get_env(:fly_faast, FlyFaast.Janitor)[:shutdown_timeout]
    Logger.info("Initializing FlyFaast.Janitor with a default timeout of #{timeout}")
    state = %{ref: nil, timeout: timeout}
    state = delay_inevitable(state)
    {:ok, state}
  end

  @impl true
  def handle_cast(:boop, state) do
    state = delay_inevitable(state)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:boop, timeout}, state) do
    state = delay_inevitable(state, timeout)
    {:noreply, state}
  end


  @impl true
  def handle_info({:idle_timeout, ref}, %{ref: ref} = state) do
    shutdown_elixir(state)
    {:noreply, state}
  end

  def handle_info({:idle_timeout, _ref}, state), do: {:noreply, state}

  defp delay_inevitable(state) do
    delay_inevitable(state, state.timeout)
  end

  defp delay_inevitable(state, timeout) do
    ref = make_ref()

    _= Process.send_after(self(), {:idle_timeout, ref}, timeout)
    %{state | ref: ref}
  end

  defp shutdown_elixir(state) do
    Logger.info("Going down after wrapping up work.")
    # TODO consider figuring out how to check Phoenix doesn't have any
    # outstanding requests
    System.stop()
  end
end
