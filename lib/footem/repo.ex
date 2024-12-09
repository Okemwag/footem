defmodule Footem.Repo do
  use Ecto.Repo,
    otp_app: :footem,
    adapter: Ecto.Adapters.Postgres
end
