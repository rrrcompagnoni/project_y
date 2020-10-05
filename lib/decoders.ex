defmodule ProjectY.Decoders do
  alias ProjectY.{
    Decoders.MorseDecodeTable,
    Decoders.MorseSignal,
    Decoders.MorseSession,
    GenServers,
    Supervisors
  }

  @spec cast_session(:morse, String.t()) :: MorseSession.t()
  def cast_session(:morse, session_code) when is_binary(session_code) do
    %MorseSession{code: session_code}
  end

  @spec start_session(MorseSession.t()) :: :already_started | :ok
  def start_session(%MorseSession{code: code}) do
    case DynamicSupervisor.start_child(
           Supervisors.DecodeSession,
           {GenServers.MorseSession, name: {:via, :swarm, code}, session_code: code}
         ) do
      {:ok, _} -> :ok
      {:error, {:already_started, _}} -> :already_started
    end
  end

  @spec stop_session(MorseSession.t()) :: :ok | :session_not_found
  def stop_session(%MorseSession{code: code}) do
    with session when is_pid(session) <- Swarm.whereis_name(code),
         :ok <- DynamicSupervisor.terminate_child(Supervisors.DecodeSession, session),
         :ok <- Swarm.unregister_name(code) do
      :ok
    else
      {:error, :not_found} -> :session_not_found
      :undefined -> :session_not_found
    end
  end

  @spec send_signal(MorseSession.t(), MorseSignal.t()) ::
          :ok | :session_not_found
  def send_signal(%MorseSession{code: code}, %MorseSignal{} = signal) do
    with session when is_pid(session) <- Swarm.whereis_name(code),
         :ok <- GenServers.MorseSession.send_signal(session, signal) do
      :ok
    else
      :undefined -> :session_not_found
    end
  end

  @spec decode_session_message!(MorseSession.t()) :: :session_not_found | String.t()
  def decode_session_message!(%MorseSession{code: code}) do
    with session when is_pid(session) <- Swarm.whereis_name(code),
         message when is_binary(message) <- GenServers.MorseSession.decode_message!(session) do
      message
    else
      :undefined -> :session_not_found
    end
  end

  @spec decode_raw_signal(MorseSession.t(), String.t()) ::
          {:error, :invalid_signal} | {:ok, MorseSignal.t()}
  def decode_raw_signal(%MorseSession{}, signal) do
    with {:ok, decoded_signal} <- MorseDecodeTable.decode_signal(signal),
         %MorseSignal{} = morse_signal <- MorseSignal.cast(signal, decoded_signal) do
      {:ok, morse_signal}
    else
      :error -> {:error, :invalid_signal}
    end
  end

  @spec decode_message!(list()) :: String.t()
  def decode_message!(signals \\ []) do
    Enum.map_join(signals, "", & &1.decoded)
  end
end
