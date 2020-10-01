defmodule ProjectY.Decoders.MorseSignal do
  defstruct [:encoded, :decoded]

  @type t :: %__MODULE__{
          encoded: String.t(),
          decoded: String.t() | nil
        }

  @conversion_table %{
    ".-" => "A",
    "-..." => "B",
    "-.-." => "C",
    "-.." => "D",
    "." => "E",
    "..-." => "F",
    "--." => "G",
    "...." => "H",
    ".." => "I",
    ".---" => "J",
    "-.-" => "K",
    ".-.." => "L",
    "--" => "M",
    "-." => "N",
    "---" => "O",
    ".--." => "P",
    "--.-" => "Q",
    ".-." => "R",
    "..." => "S",
    "-" => "T",
    "..-" => "U",
    "...-" => "V",
    ".--" => "W",
    "-..-" => "X",
    "-.--" => "Y",
    "--.." => "Z",
    "-----" => "0",
    ".----" => "1",
    "..---" => "2",
    "...--" => "3",
    "....-" => "4",
    "....." => "5",
    "-...." => "6",
    "--..." => "7",
    "---.." => "8",
    "----." => "9",
    "·-·-·-" => ".",
    "-·-·-·" => ";",
    "---···" => ":",
    "--··--" => ",",
    "-··-·" => "/",
    "-···-" => "=",
    "-·-·--" => "!",
    "··--··" => "?",
    "·--·-·" => "@",
    " " => " "
  }

  @spec decode(__MODULE__.t()) :: __MODULE__.t()
  def decode(%__MODULE__{encoded: encoded, decoded: nil} = signal) do
    %{signal | decoded: Map.fetch!(@conversion_table, encoded)}
  end
end
