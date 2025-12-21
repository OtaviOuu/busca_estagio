defmodule BuscaEstagio.Vagas.ListEstagios do
  alias BuscaEstagio.Repo
  alias BuscaEstagio.Vagas.Estagio
  import Ecto.Query, warn: false

  def call(offset \\ 0) do
    from(e in Estagio,
      order_by: [desc: e.inserted_at],
      limit: 50,
      offset: ^offset,
      select: %{
        id: e.id,
        titulo: e.titulo,
        universidade: e.universidade,
        inserted_at: e.inserted_at,
        # sla pq funciona
        capturado_hoje?:
          fragment(
            "(? AT TIME ZONE 'UTC')::date = CURRENT_DATE",
            e.inserted_at
          )
      }
    )
    |> Repo.all()
  end
end
