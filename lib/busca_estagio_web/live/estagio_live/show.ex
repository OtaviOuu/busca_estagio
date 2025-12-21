defmodule BuscaEstagioWeb.EstagioLive.Show do
  use BuscaEstagioWeb, :live_view

  def mount(%{"estagio_id" => estagio_id}, _session, socket) do
    estagio = BuscaEstagio.Vagas.get_estagio_by_id(estagio_id)
    {:ok, assign(socket, estagio: estagio)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Estágio Details
      </.header>
      <h2>{@estagio.titulo}</h2>
      <a class="text-blue-500 underline" href={@estagio.link}>Link da postageem</a>
      {raw(@estagio.descricao)}
    </Layouts.app>
    """
  end
end
