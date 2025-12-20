defmodule BuscaEstagio.Repo.Migrations.CreateEstagiosTable do
  use Ecto.Migration

  def change do
    create table(:estagios, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :titulo, :string, null: false
      add :descricao, :text, null: true
      add :empresa, :string, null: false
      add :link, :string, null: false
      add :universidade, :string, null: false

      timestamps()
    end

    create unique_index(:estagios, [:link], name: :estagios_link_index)
  end
end
