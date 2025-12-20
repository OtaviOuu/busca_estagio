defmodule BuscaEstagio.Vagas.CreateEstagio do
  alias BuscaEstagio.Repo
  alias BuscaEstagio.Vagas.Estagio

  def call(attrs) do
    attrs
    |> Estagio.changeset()
    |> Repo.insert(
      on_conflict: {:replace_all_except, [:id, :inserted_at]},
      conflict_target: :link
    )
  end
end
