# ProjectY
The Project Y is a **Distributed Morse Decoder**

## Installation
1. Install Erlang 23.1 https://www.erlang.org/
2. Install Elixir 1.10.4 https://elixir-lang.org/
3. Clone the repo:
```bash
  git clone git@github.com:rrrcompagnoni/project_y.git
```
4. Compile the application:
```bash
  mix compile
```

## Running
Follow the installation instructions (skip if you have already done)

You can run it in a single node:
```bash
  mix run --no-halt
```

Or you can run it at most in three nodes (you may need to split your console or run it in detached mode)
```bash
  HTTP_PORT=4000 elixir --name a@127.0.0.1 -S mix run --no-halt
  HTTP_PORT=4001 elixir --name b@127.0.0.1 -S mix run --no-halt
  HTTP_PORT=4002 elixir --name c@127.0.0.1 -S mix run --no-halt
```

## API specification
See the `project_y.apib` document.

## Testing
All that you need is only run:
```bash
  mix test
```

## Development notes

- For a production-ready application, we may need a more advanced node boot management tool. Kubernetes may fit our needs.
- The web interface maybe is too simple for a large-scale application. I have tried to be compliant with the original specification. We could adopt the JSON API specification for distribution versions of the interface.
- I had to make a small tweak to accept JSON requests. You may need to make your Curl calls sending the content type.
```bash
  curl -H "Content-Type: application/json" -X PUT -d '{"code": "."}' http://localhost:4000/decode/session_code
```
- Since the ProjectY interface is just a proxy to the Decoders one, I left the tests to the Decoders abstraction and made clear contracts to the ProjectY by the specs of the functions.
