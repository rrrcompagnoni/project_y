defmodule ProjectY.DecodersTest do
  use ExUnit.Case, async: true

  alias ProjectY.{
    Decoders,
    Decoders.MorseSignal
  }

  test "a Morse Code decode session" do
    session_code = UUID.uuid4()

    {:ok, signal_1} = Decoders.decode_morse_signal("....")
    {:ok, signal_2} = Decoders.decode_morse_signal(".")
    {:ok, signal_3} = Decoders.decode_morse_signal(".-..")
    {:ok, signal_4} = Decoders.decode_morse_signal(".--.")

    :ok = Decoders.new_session(:morse, session_code)

    :ok = Decoders.send_signal_to_session(session_code, signal_1)
    :ok = Decoders.send_signal_to_session(session_code, signal_2)
    :ok = Decoders.send_signal_to_session(session_code, signal_3)
    :ok = Decoders.send_signal_to_session(session_code, signal_4)

    assert "HELP" = Decoders.decode_session_message!(:morse, session_code)

    :ok = Decoders.close_session(:morse, session_code)

    assert :session_not_found = Decoders.send_signal_to_session(session_code, signal_1)
    assert :session_not_found = Decoders.decode_session_message!(:morse, session_code)
  end

  describe "new_session/2" do
    test "the attempt to duplicate a Morse decode session" do
      session_code = UUID.uuid4()

      assert :ok = Decoders.new_session(:morse, session_code)

      assert :already_started = Decoders.new_session(:morse, session_code)

      :ok = Decoders.close_session(:morse, session_code)
    end
  end

  describe "close_session/2" do
    test "the attempt to close a Morse decode session already closed" do
      session_code = UUID.uuid4()

      :ok = Decoders.new_session(:morse, session_code)

      :ok = Decoders.close_session(:morse, session_code)

      assert :session_not_found = Decoders.close_session(:morse, session_code)
    end
  end

  describe "decode_morse_signal/1" do
    test "with a valid Morse signal" do
      assert {:ok, %MorseSignal{encoded: ".", decoded: "E"}} = Decoders.decode_morse_signal(".")
    end

    test "with an invalid Morse signal" do
      assert {:error, :invalid_signal} = Decoders.decode_morse_signal("X")
    end
  end

  describe "decode_message!/1" do
    test "signals responding to decoded field" do
      {:ok, signal_1} = Decoders.decode_morse_signal("....")
      {:ok, signal_2} = Decoders.decode_morse_signal(".")
      {:ok, signal_3} = Decoders.decode_morse_signal(".-..")
      {:ok, signal_4} = Decoders.decode_morse_signal(".--.")
      signals = [signal_1, signal_2, signal_3, signal_4]

      assert Decoders.decode_message!(signals) == "HELP"
    end

    test "zero signals" do
      assert "" = Decoders.decode_message!()
    end

    test "signals missing decoded field" do
      assert_raise ArgumentError, fn ->
        Decoders.decode_message!(["x"])
      end
    end
  end
end
