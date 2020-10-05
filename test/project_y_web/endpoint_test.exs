defmodule ProjectYWeb.EndpointTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts ProjectYWeb.Endpoint.init([])

  describe "POST /new" do
    test "the generation of a new Morse session" do
      conn =
        conn(:post, "/new")
        |> put_req_header("content-type", "application/json")

      conn = ProjectYWeb.Endpoint.call(conn, @opts)

      assert conn.status == 201

      assert %{"id" => session_code} = Jason.decode!(conn.resp_body)

      :ok = ProjectY.stop_session(%ProjectY.Decoders.MorseSession{code: session_code})
    end
  end

  describe "PUT /decode/:session_code" do
    test "a signal being sent to an alive Morse session" do
      session = ProjectY.cast_morse_session(UUID.uuid4())

      :ok = ProjectY.start_session(session)

      conn =
        conn(:put, "/decode/#{session.code}", Jason.encode!(%{code: "...."}))
        |> put_req_header("content-type", "application/json")

      conn = ProjectYWeb.Endpoint.call(conn, @opts)

      assert conn.status == 202

      :ok = ProjectY.stop_session(session)
    end

    test "missing the code param" do
      session = ProjectY.cast_morse_session(UUID.uuid4())

      :ok = ProjectY.start_session(session)

      conn =
        conn(:put, "/decode/#{session.code}")
        |> put_req_header("content-type", "application/json")

      conn = ProjectYWeb.Endpoint.call(conn, @opts)

      assert conn.status == 400

      :ok = ProjectY.stop_session(session)
    end

    test "invalid Morse signal" do
      session = ProjectY.cast_morse_session(UUID.uuid4())

      :ok = ProjectY.start_session(session)

      conn =
        conn(:put, "/decode/#{session.code}", Jason.encode!(%{code: "E"}))
        |> put_req_header("content-type", "application/json")

      conn = ProjectYWeb.Endpoint.call(conn, @opts)

      assert conn.status == 400

      :ok = ProjectY.stop_session(session)
    end

    test "a dead Morse session" do
      session = ProjectY.cast_morse_session(UUID.uuid4())

      :session_not_found = ProjectY.stop_session(session)

      conn =
        conn(:put, "/decode/#{session.code}", Jason.encode!(%{code: "...."}))
        |> put_req_header("content-type", "application/json")

      conn = ProjectYWeb.Endpoint.call(conn, @opts)

      assert conn.status == 404
    end
  end

  describe "GET /decode/:session_code" do
    test "a request to an alive Morse session" do
      session = ProjectY.cast_morse_session(UUID.uuid4())

      :ok = ProjectY.start_session(session)

      :ok = ProjectY.send_signal(session, "....")
      :ok = ProjectY.send_signal(session, ".")
      :ok = ProjectY.send_signal(session, ".-..")
      :ok = ProjectY.send_signal(session, ".--.")

      conn =
        conn(:get, "/decode/#{session.code}")
        |> put_req_header("content-type", "application/json")

      conn = ProjectYWeb.Endpoint.call(conn, @opts)

      assert conn.status == 200
      assert %{"text" => "HELP"} = Jason.decode!(conn.resp_body)

      :ok = ProjectY.stop_session(session)
    end

    test "a Morse session without signals" do
      session = ProjectY.cast_morse_session(UUID.uuid4())

      :ok = ProjectY.start_session(session)

      conn =
        conn(:get, "/decode/#{session.code}")
        |> put_req_header("content-type", "application/json")

      conn = ProjectYWeb.Endpoint.call(conn, @opts)

      assert conn.status == 200
      assert %{"text" => ""} = Jason.decode!(conn.resp_body)

      :ok = ProjectY.stop_session(session)
    end

    test "a dead Morse session" do
      session = ProjectY.cast_morse_session(UUID.uuid4())

      :session_not_found = ProjectY.stop_session(session)

      conn =
        conn(:get, "/decode/#{session.code}")
        |> put_req_header("content-type", "application/json")

      conn = ProjectYWeb.Endpoint.call(conn, @opts)

      assert conn.status == 404
    end
  end
end
