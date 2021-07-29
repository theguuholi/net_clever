defmodule NetClever.Repo do
  use Ecto.Repo,
    otp_app: :net_clever,
    adapter: Ecto.Adapters.Postgres
end
