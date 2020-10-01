defmodule ProjectY.Decoders.MorseDecodeTableTest do
  use ExUnit.Case, async: true

  alias ProjectY.Decoders.MorseDecodeTable

  describe "decode_signal/1" do
    test "the success decode contract" do
      assert {:ok, "E"} = MorseDecodeTable.decode_signal(".")
    end

    test "the error decode contract" do
      assert :error = MorseDecodeTable.decode_signal("X")
    end

    test "the decoding of letter A" do
      assert {:ok, "A"} = MorseDecodeTable.decode_signal(".-")
    end

    test "the decoding of letter B" do
      assert {:ok, "B"} = MorseDecodeTable.decode_signal("-...")
    end

    test "the decoding of letter C" do
      assert {:ok, "C"} = MorseDecodeTable.decode_signal("-.-.")
    end

    test "the decoding of letter D" do
      assert {:ok, "D"} = MorseDecodeTable.decode_signal("-..")
    end

    test "the decoding of letter E" do
      assert {:ok, "E"} = MorseDecodeTable.decode_signal(".")
    end

    test "the decoding of letter F" do
      assert {:ok, "F"} = MorseDecodeTable.decode_signal("..-.")
    end

    test "the decoding of letter G" do
      assert {:ok, "G"} = MorseDecodeTable.decode_signal("--.")
    end

    test "the decoding of letter H" do
      assert {:ok, "H"} = MorseDecodeTable.decode_signal("....")
    end

    test "the decoding of letter I" do
      assert {:ok, "I"} = MorseDecodeTable.decode_signal("..")
    end

    test "the decoding of letter J" do
      assert {:ok, "J"} = MorseDecodeTable.decode_signal(".---")
    end

    test "the decoding of letter K" do
      assert {:ok, "K"} = MorseDecodeTable.decode_signal("-.-")
    end

    test "the decoding of letter L" do
      assert {:ok, "L"} = MorseDecodeTable.decode_signal(".-..")
    end

    test "the decoding of letter M" do
      assert {:ok, "M"} = MorseDecodeTable.decode_signal("--")
    end

    test "the decoding of letter N" do
      assert {:ok, "N"} = MorseDecodeTable.decode_signal("-.")
    end

    test "the decoding of letter O" do
      assert {:ok, "O"} = MorseDecodeTable.decode_signal("---")
    end

    test "the decoding of letter P" do
      assert {:ok, "P"} = MorseDecodeTable.decode_signal(".--.")
    end

    test "the decoding of letter Q" do
      assert {:ok, "Q"} = MorseDecodeTable.decode_signal("--.-")
    end

    test "the decoding of letter R" do
      assert {:ok, "R"} = MorseDecodeTable.decode_signal(".-.")
    end

    test "the decoding of letter S" do
      assert {:ok, "S"} = MorseDecodeTable.decode_signal("...")
    end

    test "the decoding of letter T" do
      assert {:ok, "T"} = MorseDecodeTable.decode_signal("-")
    end

    test "the decoding of letter U" do
      assert {:ok, "U"} = MorseDecodeTable.decode_signal("..-")
    end

    test "the decoding of letter V" do
      assert {:ok, "V"} = MorseDecodeTable.decode_signal("...-")
    end

    test "the decoding of letter W" do
      assert {:ok, "W"} = MorseDecodeTable.decode_signal(".--")
    end

    test "the decoding of letter X" do
      assert {:ok, "X"} = MorseDecodeTable.decode_signal("-..-")
    end

    test "the decoding of letter Y" do
      assert {:ok, "Y"} = MorseDecodeTable.decode_signal("-.--")
    end

    test "the decoding of letter Z" do
      assert {:ok, "Z"} = MorseDecodeTable.decode_signal("--..")
    end

    test "the decoding of number 0" do
      assert {:ok, "0"} = MorseDecodeTable.decode_signal("-----")
    end

    test "the decoding of number 1" do
      assert {:ok, "1"} = MorseDecodeTable.decode_signal(".----")
    end

    test "the decoding of number 2" do
      assert {:ok, "2"} = MorseDecodeTable.decode_signal("..---")
    end

    test "the decoding of number 3" do
      assert {:ok, "3"} = MorseDecodeTable.decode_signal("...--")
    end

    test "the decoding of number 4" do
      assert {:ok, "4"} = MorseDecodeTable.decode_signal("....-")
    end

    test "the decoding of number 5" do
      assert {:ok, "5"} = MorseDecodeTable.decode_signal(".....")
    end

    test "the decoding of number 6" do
      assert {:ok, "6"} = MorseDecodeTable.decode_signal("-....")
    end

    test "the decoding of number 7" do
      assert {:ok, "7"} = MorseDecodeTable.decode_signal("--...")
    end

    test "the decoding of number 8" do
      assert {:ok, "8"} = MorseDecodeTable.decode_signal("---..")
    end

    test "the decoding of number 9" do
      assert {:ok, "9"} = MorseDecodeTable.decode_signal("----.")
    end

    test "a period" do
      assert {:ok, "."} = MorseDecodeTable.decode_signal("·-·-·-")
    end

    test "a semicolon" do
      assert {:ok, ";"} = MorseDecodeTable.decode_signal("-·-·-·")
    end

    test "a colon" do
      assert {:ok, ":"} = MorseDecodeTable.decode_signal("---···")
    end

    test "a comma" do
      assert {:ok, ","} = MorseDecodeTable.decode_signal("--··--")
    end

    test "a slash" do
      assert {:ok, "/"} = MorseDecodeTable.decode_signal("-··-·")
    end

    test "the equals sign" do
      assert {:ok, "="} = MorseDecodeTable.decode_signal("-···-")
    end

    test "the exclamation mark" do
      assert {:ok, "!"} = MorseDecodeTable.decode_signal("-·-·--")
    end

    test "the question mark" do
      assert {:ok, "?"} = MorseDecodeTable.decode_signal("··--··")
    end

    test "the at sign" do
      assert {:ok, "@"} = MorseDecodeTable.decode_signal("·--·-·")
    end

    test "a space character" do
      assert {:ok, " "} = MorseDecodeTable.decode_signal(" ")
    end
  end
end
