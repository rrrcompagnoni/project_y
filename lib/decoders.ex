defmodule ProjectY.Decoders do
  alias ProjectY.Decoders.{
    MorseDecodeTable,
    MorseSignal
  }

  @spec decode_morse_signal(String.t()) ::
          {:error, :the_signal_is_not_valid} | {:ok, ProjectY.Decoders.MorseSignal.t()}
  def decode_morse_signal(signal) when is_binary(signal) do
    with {:ok, decoded_signal} <- MorseDecodeTable.decode_signal(signal),
         %MorseSignal{} = morse_signal <- MorseSignal.cast(signal, decoded_signal) do
      {:ok, morse_signal}
    else
      :error -> {:error, :the_signal_is_not_valid}
    end
  end
end
