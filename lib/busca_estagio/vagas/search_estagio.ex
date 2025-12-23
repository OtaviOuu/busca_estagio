defmodule BuscaEstagio.Vagas.SearchEstagio do
  alias BuscaEstagio.Repo
  alias BuscaEstagio.Vagas.Estagio
  import Ecto.Query

  def call(search_term) do
    query =
      from e in Estagio,
        where: ilike(e.titulo, ^"%#{search_term}%") or ilike(e.empresa, ^"%#{search_term}%"),
        order_by: [desc: e.inserted_at],
        select: %{
          capturado_hoje?:
            fragment(
              "(? AT TIME ZONE 'UTC')::date = CURRENT_DATE",
              e.inserted_at
            ),
          id: e.id,
          titulo: e.titulo,
          universidade: e.universidade,
          inserted_at: e.inserted_at
        }

    query
    |> limit(5)
    |> Repo.all()
  end
end
