defmodule BuscaEstagio.Vagas.Estagio do
  use Ecto.Schema
  import Ecto.Changeset

  alias BuscaEstagio.Vagas.Universidades

  @optional_fields [:descricao]
  @required_fields [:titulo, :empresa, :link, :universidade]

  @fields @optional_fields ++ @required_fields

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "estagios" do
    field :titulo, :string
    field :descricao, :string
    field :empresa, :string
    field :link, :string
    field :universidade, Ecto.Enum, values: Universidades.labels()
    timestamps()
  end

  def changeset(estagio \\ %__MODULE__{}, attrs) do
    estagio
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:link, name: :estagios_link_index)
  end
end
