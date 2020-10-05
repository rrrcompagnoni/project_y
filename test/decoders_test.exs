defmodule ProjectY.DecodersTest do
  use ExUnit.Case, async: true

  alias ProjectY.{
    Decoders,
    Decoders.MorseSignal
  }

  test "a Morse Code decode session" do
    session = Decoders.cast_session(:morse, UUID.uuid4())

    {:ok, signal_1} = Decoders.decode_raw_signal(session, "....")
    {:ok, signal_2} = Decoders.decode_raw_signal(session, ".")
    {:ok, signal_3} = Decoders.decode_raw_signal(session, ".-..")
    {:ok, signal_4} = Decoders.decode_raw_signal(session, ".--.")

    :ok = Decoders.start_session(session)

    :ok = Decoders.send_signal(session, signal_1)
    :ok = Decoders.send_signal(session, signal_2)
    :ok = Decoders.send_signal(session, signal_3)
    :ok = Decoders.send_signal(session, signal_4)

    assert "HELP" = Decoders.decode_session_message!(session)

    :ok = Decoders.stop_session(session)

    assert :session_not_found = Decoders.send_signal(session, signal_1)
    assert :session_not_found = Decoders.decode_session_message!(session)
  end

  describe "start_session/1" do
    test "the attempt to duplicate a Morse decode session" do
      session = Decoders.cast_session(:morse, UUID.uuid4())

      assert :ok = Decoders.start_session(session)

      assert :already_started = Decoders.start_session(session)

      :ok = Decoders.stop_session(session)
    end
  end

  describe "stop_session/1" do
    test "the attempt to stop a Morse decode session already closed" do
      session = Decoders.cast_session(:morse, UUID.uuid4())

      :ok = Decoders.start_session(session)

      :ok = Decoders.stop_session(session)

      assert :session_not_found = Decoders.stop_session(session)
    end
  end

  describe "decode_raw_signal/2" do
    test "with a valid Morse signal" do
      session = Decoders.cast_session(:morse, "")

      assert {:ok, %MorseSignal{encoded: ".", decoded: "E"}} =
               Decoders.decode_raw_signal(session, ".")
    end

    test "with an invalid Morse signal" do
      session = Decoders.cast_session(:morse, "")

      assert {:error, :invalid_signal} = Decoders.decode_raw_signal(session, "X")
    end
  end

  describe "decode_message!/1" do
    test "signals responding to decoded field" do
      session = Decoders.cast_session(:morse, "")
      {:ok, signal_1} = Decoders.decode_raw_signal(session, "....")
      {:ok, signal_2} = Decoders.decode_raw_signal(session, ".")
      {:ok, signal_3} = Decoders.decode_raw_signal(session, ".-..")
      {:ok, signal_4} = Decoders.decode_raw_signal(session, ".--.")
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
