defmodule ProjectY.Decoders do
  alias ProjectY.{
    Decoders.MorseDecodeTable,
    Decoders.MorseSignal,
    GenServers,
    Supervisors
  }

  @spec new_session(:morse, String.t()) :: :already_started | :ok
  def new_session(:morse, session_code) when is_binary(session_code) do
    case DynamicSupervisor.start_child(
           Supervisors.DecodeSession,
           {GenServers.MorseSession,
            name: {:via, :swarm, session_code}, session_code: session_code}
         ) do
      {:ok, _} -> :ok
      {:error, {:already_started, _}} -> :already_started
    end
  end

  @spec close_session(:morse, String.t()) :: :ok | :session_not_found
  def close_session(:morse, session_code) when is_binary(session_code) do
    with session when is_pid(session) <- Swarm.whereis_name(session_code),
         :ok <- DynamicSupervisor.terminate_child(Supervisors.DecodeSession, session),
         :ok <- Swarm.unregister_name(session_code) do
      :ok
    else
      {:error, :not_found} -> :session_not_found
      :undefined -> :session_not_found
    end
  end

  @spec send_signal_to_session(String.t(), MorseSignal.t()) ::
          :ok | :session_not_found
  def send_signal_to_session(session_code, %MorseSignal{} = signal)
      when is_binary(session_code) do
    with session when is_pid(session) <- Swarm.whereis_name(session_code),
         :ok <- GenServers.MorseSession.send_signal(session, signal) do
      :ok
    else
      :undefined -> :session_not_found
    end
  end

  @spec decode_session_message!(:morse, String.t()) :: :session_not_found | String.t()
  def decode_session_message!(:morse, session_code) when is_binary(session_code) do
    with session when is_pid(session) <- Swarm.whereis_name(session_code),
         message when is_binary(message) <- GenServers.MorseSession.decode_message!(session) do
      message
    else
      :undefined -> :session_not_found
    end
  end

  @spec decode_morse_signal(String.t()) ::
          {:error, :invalid_signal} | {:ok, MorseSignal.t()}
  def decode_morse_signal(signal) when is_binary(signal) do
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
