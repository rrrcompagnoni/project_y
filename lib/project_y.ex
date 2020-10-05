defmodule ProjectY do
  alias ProjectY.Decoders.MorseSession

  @spec cast_morse_session(String.t()) :: MorseSession.t()
  def cast_morse_session(session_code) when is_binary(session_code) do
    ProjectY.Decoders.cast_session(:morse, session_code)
  end

  @spec start_session(MorseSession.t()) :: :already_started | :ok
  def start_session(%MorseSession{} = session) do
    ProjectY.Decoders.start_session(session)
  end

  @spec stop_session(MorseSession.t()) :: :ok | :session_not_found
  def stop_session(%MorseSession{} = session) do
    ProjectY.Decoders.stop_session(session)
  end

  @spec send_signal(MorseSession.t(), String.t()) ::
          :invalid_signal | :ok | :session_not_found
  def send_signal(%MorseSession{} = session, raw_signal)
      when is_binary(raw_signal) do
    with {:ok, signal} <- ProjectY.Decoders.decode_raw_signal(session, raw_signal),
         :ok <- ProjectY.Decoders.send_signal(session, signal) do
      :ok
    else
      :session_not_found -> :session_not_found
      {:error, :invalid_signal} -> :invalid_signal
    end
  end

  @spec decode_session_message!(MorseSession.t()) ::
          :session_not_found | String.t()
  def decode_session_message!(%MorseSession{} = session) do
    ProjectY.Decoders.decode_session_message!(session)
  end

  @spec decode_message!([any()]) :: String.t()
  def decode_message!(signals \\ []) do
    ProjectY.Decoders.decode_message!(signals)
  end
end
