defmodule RiseShop.Repo do
  use Ecto.Repo,
    otp_app: :rise_shop,
    adapter: Ecto.Adapters.Postgres
end
