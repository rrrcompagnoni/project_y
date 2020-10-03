defmodule ProjectY.GenServers.MorseSession do
  use GenServer

  alias ProjectY.{
    Decoders,
    Decoders.MorseSignal
  }

  def start_link(options) do
    GenServer.start_link(__MODULE__, Keyword.fetch!(options, :session_code), options)
  end

  @spec send_signal(
          pid(),
          MorseSignal.t()
        ) :: :ok
  def send_signal(pid, %MorseSignal{} = signal) do
    GenServer.cast(pid, {:push_signal, signal})
  end

  @spec decode_message!(pid()) :: String.t()
  def decode_message!(pid) do
    GenServer.call(pid, :decode_message)
  end

  @impl true
  def init(session_code) do
    Process.send_after(self(), {:close_session, session_code}, 300_000)

    {:ok, []}
  end

  @impl true
  def handle_call(:decode_message, _from, signals) do
    message =
      signals
      |> Enum.reverse()
      |> Decoders.decode_message!()

    {:reply, message, signals}
  end

  @impl true
  def handle_call({:swarm, :begin_handoff}, _from, {name, delay}) do
    {:reply, {:resume, {name, delay}}, {name, delay}}
  end

  @impl true
  def handle_cast({:push_signal, %MorseSignal{} = signal}, signals) do
    {:noreply, [signal | signals]}
  end

  @impl true
  def handle_cast({:swarm, :end_handoff, delay}, {name, _}) do
    {:noreply, {name, delay}}
  end

  @impl true
  def handle_cast({:swarm, :resolve_conflict, _delay}, state) do
    {:noreply, state}
  end

  @impl true
  def handle_info({:swarm, :die}, state) do
    {:stop, :shutdown, state}
  end

  @impl true
  def handle_info({:close_session, session_code}, state) do
    Decoders.close_session(:morse, session_code)

    {:noreply, state}
  end
end
