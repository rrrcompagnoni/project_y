defmodule ProjectY.Decoders.MorseSession do
  defstruct [:code]

  @type t :: %__MODULE__{
          code: String.t()
        }
end
