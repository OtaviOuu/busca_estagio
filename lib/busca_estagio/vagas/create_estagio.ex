defmodule BuscaEstagio.Vagas.CreateEstagio do
  alias BuscaEstagio.Repo
  alias BuscaEstagio.Vagas.Estagio

  def call(attrs) do
    attrs
    |> Estagio.changeset()
    |> Repo.insert()
  end
end
