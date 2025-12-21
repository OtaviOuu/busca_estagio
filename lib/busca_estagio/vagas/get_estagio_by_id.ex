defmodule BuscaEstagio.Vagas.GetEstagioById do
  alias BuscaEstagio.Repo
  alias BuscaEstagio.Vagas.Estagio

  def call(id) do
    Repo.get_by(Estagio, id: id)
  end
end
