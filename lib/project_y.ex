defmodule ProjectY do
  @spec new_morse_session(String.t()) :: :already_started | :ok
  def new_morse_session(session_code) when is_binary(session_code) do
    ProjectY.Decoders.new_session(:morse, session_code)
  end

  @spec close_morse_session(String.t()) :: :ok | :session_not_found
  def close_morse_session(session_code) when is_binary(session_code) do
    ProjectY.Decoders.close_session(:morse, session_code)
  end

  @spec send_morse_signal(String.t(), String.t()) :: :invalid_signal | :ok | :session_not_found
  def send_morse_signal(session_code, raw_signal)
      when is_binary(session_code) and is_binary(raw_signal) do
    with {:ok, signal} <- ProjectY.Decoders.decode_morse_signal(raw_signal),
         :ok <- ProjectY.Decoders.send_signal_to_session(session_code, signal) do
      :ok
    else
      :session_not_found -> :session_not_found
      {:error, :invalid_signal} -> :invalid_signal
    end
  end

  @spec decode_morse_session_message!(String.t()) :: :session_not_found | String.t()
  def decode_morse_session_message!(session_code) when is_binary(session_code) do
    ProjectY.Decoders.decode_session_message!(:morse, session_code)
  end
end
