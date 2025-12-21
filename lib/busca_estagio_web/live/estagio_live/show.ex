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
      <div class="mx-4 my-8 card w-full bg-base-100 p-4 shadow-xl">
        <h2 class="text-2xl font-bold mb-4">Estágio Back-office</h2>
        <p><strong>Universidade:</strong> USP-ICMC</p>
        <p>
          <strong>Descrição:</strong>
          Este estágio envolve atividades de suporte administrativo e operacional no setor de back-office.
        </p>
        <p><strong>Data de Captura:</strong> {Date.utc_today()}</p>
      </div>
    </Layouts.app>
    """
  end
end
