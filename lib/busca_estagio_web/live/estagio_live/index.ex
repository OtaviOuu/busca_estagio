defmodule BuscaEstagioWeb.EstagioLive.Index do
  use BuscaEstagioWeb, :live_view

  alias BuscaEstagio.Vagas

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:offset, 0)
      |> assign_estagios()

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Welcome to Busca Estágio!
      </.header>

      <.super_power_table estagios={@estagios} offset={@offset} />
    </Layouts.app>
    """
  end

  def super_power_table(assigns) do
    ~H"""
    <div class="mx-4 my-8 card w-full bg-base-100 p-4 shadow-xl">
      <table class="table w-full">
        <thead class=" bg-base-100 z-10 sticky top-0">
          <tr>
            <th>Titulo</th>
            <th>Universidade</th>
            <th>Capturado</th>
          </tr>
        </thead>

        <tbody>
          <tr
            :for={estagio <- @estagios}
            phx-click={JS.navigate("/estagios/#{estagio.id}")}
          >
            <td>
              {estagio.titulo} <.capturado_hoje_badge :if={estagio.capturado_hoje?} />
            </td>
            <td>{estagio.universidade}</td>
            <td>{estagio.inserted_at}</td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  defp assign_estagios(socket) do
    offset = socket.assigns.offset

    estagios = Vagas.list_estagios(offset)
    assign(socket, :estagios, estagios)
  end

  def capturado_hoje_badge(assigns) do
    ~H"""
    <span class="badge badge-success">Capturado Hoje</span>
    """
  end
end
