defmodule ProjectYWeb.Endpoint do
  use Plug.Router

  plug(Plug.Logger)

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    json_decoder: Jason
  )

  plug(:dispatch)

  post "/new" do
    session_code = UUID.uuid4()

    case ProjectY.new_morse_session(session_code) do
      :ok ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(201, Jason.encode!(%{id: session_code}))
    end
  end

  put "/decode/:session_code" do
    with {:ok, raw_signal} <- Map.fetch(conn.body_params, "code"),
         :ok <- ProjectY.send_morse_signal(session_code, raw_signal) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(202, "")
    else
      :error ->
        send_resp(conn, 400, "")

      :invalid_signal ->
        send_resp(conn, 400, "")

      :session_not_found ->
        send_404(conn)
    end
  end

  get "/decode/:session_code" do
    case ProjectY.decode_morse_session_message!(session_code) do
      message when is_binary(message) ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{"text" => message}))

      :session_not_found ->
        send_404(conn)
    end
  end

  match(_, do: send_404(conn))

  defp send_404(conn), do: send_resp(conn, 404, "")
end
