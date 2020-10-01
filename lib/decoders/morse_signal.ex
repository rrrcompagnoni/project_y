defmodule ProjectY.Decoders.MorseSignal do
  defstruct [:encoded, :decoded]

  @type t :: %__MODULE__{
          encoded: String.t(),
          decoded: String.t()
        }

  @spec cast(String.t(), String.t()) :: __MODULE__.t()
  def cast(encoded, decoded) when is_binary(encoded) and is_binary(decoded) do
    %__MODULE__{encoded: encoded, decoded: decoded}
  end
end
