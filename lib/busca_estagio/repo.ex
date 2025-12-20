defmodule BuscaEstagio.Repo do
  use Ecto.Repo,
    otp_app: :busca_estagio,
    adapter: Ecto.Adapters.Postgres
end
