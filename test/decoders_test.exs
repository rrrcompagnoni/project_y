defmodule ProjectY.DecodersTest do
  use ExUnit.Case, async: true

  alias ProjectY.{
    Decoders,
    Decoders.MorseSignal
  }

  describe "decode_morse_signal/1" do
    test "with a valid Morse signal" do
      assert {:ok, %MorseSignal{encoded: ".", decoded: "E"}} = Decoders.decode_morse_signal(".")
    end

    test "with an invalid Morse signal" do
      assert {:error, :the_signal_is_not_valid} = Decoders.decode_morse_signal("X")
    end
  end
end
