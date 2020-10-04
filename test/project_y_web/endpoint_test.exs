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

      :ok = ProjectY.close_morse_session(session_code)
    end
  end

  describe "PUT /decode/:session_code" do
    test "a signal being sent to an alive Morse session" do
      session_code = UUID.uuid4()

      :ok = ProjectY.new_morse_session(session_code)

      conn =
        conn(:put, "/decode/#{session_code}", Jason.encode!(%{code: "...."}))
        |> put_req_header("content-type", "application/json")

      conn = ProjectYWeb.Endpoint.call(conn, @opts)

      assert conn.status == 202

      :ok = ProjectY.close_morse_session(session_code)
    end

    test "missing the code param" do
      session_code = UUID.uuid4()

      :ok = ProjectY.new_morse_session(session_code)

      conn =
        conn(:put, "/decode/#{session_code}")
        |> put_req_header("content-type", "application/json")

      conn = ProjectYWeb.Endpoint.call(conn, @opts)

      assert conn.status == 400

      :ok = ProjectY.close_morse_session(session_code)
    end

    test "invalid Morse signal" do
      session_code = UUID.uuid4()

      :ok = ProjectY.new_morse_session(session_code)

      conn =
        conn(:put, "/decode/#{session_code}", Jason.encode!(%{code: "E"}))
        |> put_req_header("content-type", "application/json")

      conn = ProjectYWeb.Endpoint.call(conn, @opts)

      assert conn.status == 400

      :ok = ProjectY.close_morse_session(session_code)
    end

    test "a dead Morse session" do
      session_code = UUID.uuid4()

      :session_not_found = ProjectY.close_morse_session(session_code)

      conn =
        conn(:put, "/decode/#{session_code}", Jason.encode!(%{code: "...."}))
        |> put_req_header("content-type", "application/json")

      conn = ProjectYWeb.Endpoint.call(conn, @opts)

      assert conn.status == 404
    end
  end

  describe "GET /decode/:session_code" do
    test "a request to an alive Morse session" do
      session_code = UUID.uuid4()

      :ok = ProjectY.new_morse_session(session_code)

      :ok = ProjectY.send_morse_signal(session_code, "....")
      :ok = ProjectY.send_morse_signal(session_code, ".")
      :ok = ProjectY.send_morse_signal(session_code, ".-..")
      :ok = ProjectY.send_morse_signal(session_code, ".--.")

      conn =
        conn(:get, "/decode/#{session_code}")
        |> put_req_header("content-type", "application/json")

      conn = ProjectYWeb.Endpoint.call(conn, @opts)

      assert conn.status == 200
      assert %{"text" => "HELP"} = Jason.decode!(conn.resp_body)

      :ok = ProjectY.close_morse_session(session_code)
    end

    test "a Morse session without signals" do
      session_code = UUID.uuid4()

      :ok = ProjectY.new_morse_session(session_code)

      conn =
        conn(:get, "/decode/#{session_code}")
        |> put_req_header("content-type", "application/json")

      conn = ProjectYWeb.Endpoint.call(conn, @opts)

      assert conn.status == 200
      assert %{"text" => ""} = Jason.decode!(conn.resp_body)

      :ok = ProjectY.close_morse_session(session_code)
    end

    test "a dead Morse session" do
      session_code = UUID.uuid4()

      :session_not_found = ProjectY.close_morse_session(session_code)

      conn =
        conn(:get, "/decode/#{session_code}")
        |> put_req_header("content-type", "application/json")

      conn = ProjectYWeb.Endpoint.call(conn, @opts)

      assert conn.status == 404
    end
  end
end
