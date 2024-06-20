defmodule Axi.Repo do
  use Ecto.Repo,
    otp_app: :axi,
    adapter: Ecto.Adapters.Postgres
end
