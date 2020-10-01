defmodule ProjectY.Decoders.MorseSignalTest do
  use ExUnit.Case, async: true

  alias ProjectY.Decoders.MorseSignal

  describe "decode/1" do
    test "the decoding of letter A" do
      signal = MorseSignal.decode(%MorseSignal{encoded: ".-"})

      assert signal.decoded == "A"
    end

    test "the decoding of letter B" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "-..."})

      assert signal.decoded == "B"
    end

    test "the decoding of letter C" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "-.-."})

      assert signal.decoded == "C"
    end

    test "the decoding of letter D" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "-.."})

      assert signal.decoded == "D"
    end

    test "the decoding of letter E" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "."})

      assert signal.decoded == "E"
    end

    test "the decoding of letter F" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "..-."})

      assert signal.decoded == "F"
    end

    test "the decoding of letter G" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "--."})

      assert signal.decoded == "G"
    end

    test "the decoding of letter H" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "...."})

      assert signal.decoded == "H"
    end

    test "the decoding of letter I" do
      signal = MorseSignal.decode(%MorseSignal{encoded: ".."})

      assert signal.decoded == "I"
    end

    test "the decoding of letter J" do
      signal = MorseSignal.decode(%MorseSignal{encoded: ".---"})

      assert signal.decoded == "J"
    end

    test "the decoding of letter K" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "-.-"})

      assert signal.decoded == "K"
    end

    test "the decoding of letter L" do
      signal = MorseSignal.decode(%MorseSignal{encoded: ".-.."})

      assert signal.decoded == "L"
    end

    test "the decoding of letter M" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "--"})

      assert signal.decoded == "M"
    end

    test "the decoding of letter N" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "-."})

      assert signal.decoded == "N"
    end

    test "the decoding of letter O" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "---"})

      assert signal.decoded == "O"
    end

    test "the decoding of letter P" do
      signal = MorseSignal.decode(%MorseSignal{encoded: ".--."})

      assert signal.decoded == "P"
    end

    test "the decoding of letter Q" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "--.-"})

      assert signal.decoded == "Q"
    end

    test "the decoding of letter R" do
      signal = MorseSignal.decode(%MorseSignal{encoded: ".-."})

      assert signal.decoded == "R"
    end

    test "the decoding of letter S" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "..."})

      assert signal.decoded == "S"
    end

    test "the decoding of letter T" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "-"})

      assert signal.decoded == "T"
    end

    test "the decoding of letter U" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "..-"})

      assert signal.decoded == "U"
    end

    test "the decoding of letter V" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "...-"})

      assert signal.decoded == "V"
    end

    test "the decoding of letter W" do
      signal = MorseSignal.decode(%MorseSignal{encoded: ".--"})

      assert signal.decoded == "W"
    end

    test "the decoding of letter X" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "-..-"})

      assert signal.decoded == "X"
    end

    test "the decoding of letter Y" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "-.--"})

      assert signal.decoded == "Y"
    end

    test "the decoding of letter Z" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "--.."})

      assert signal.decoded == "Z"
    end

    test "the decoding of number 0" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "-----"})

      assert signal.decoded == "0"
    end

    test "the decoding of number 1" do
      signal = MorseSignal.decode(%MorseSignal{encoded: ".----"})

      assert signal.decoded == "1"
    end

    test "the decoding of number 2" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "..---"})

      assert signal.decoded == "2"
    end

    test "the decoding of number 3" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "...--"})

      assert signal.decoded == "3"
    end

    test "the decoding of number 4" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "....-"})

      assert signal.decoded == "4"
    end

    test "the decoding of number 5" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "....."})

      assert signal.decoded == "5"
    end

    test "the decoding of number 6" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "-...."})

      assert signal.decoded == "6"
    end

    test "the decoding of number 7" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "--..."})

      assert signal.decoded == "7"
    end

    test "the decoding of number 8" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "---.."})

      assert signal.decoded == "8"
    end

    test "the decoding of number 9" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "----."})

      assert signal.decoded == "9"
    end

    test "a period" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "·-·-·-"})

      assert signal.decoded == "."
    end

    test "a semicolon" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "-·-·-·"})

      assert signal.decoded == ";"
    end

    test "a colon" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "---···"})

      assert signal.decoded == ":"
    end

    test "a comma" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "--··--"})

      assert signal.decoded == ","
    end

    test "a slash" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "-··-·"})

      assert signal.decoded == "/"
    end

    test "the equals sign" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "-···-"})

      assert signal.decoded == "="
    end

    test "the exclamation mark" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "-·-·--"})

      assert signal.decoded == "!"
    end

    test "the question mark" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "··--··"})

      assert signal.decoded == "?"
    end

    test "the at sign" do
      signal = MorseSignal.decode(%MorseSignal{encoded: "·--·-·"})

      assert signal.decoded == "@"
    end

    test "a space character" do
      signal = MorseSignal.decode(%MorseSignal{encoded: " "})

      assert signal.decoded == " "
    end
  end
end
