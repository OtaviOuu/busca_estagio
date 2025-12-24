defmodule BuscaEstagioWeb.EstagioLive.Index do
  use BuscaEstagioWeb, :live_view

  alias BuscaEstagio.Vagas

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:offset, 0)
      |> assign_estagios()
      |> assign(:search_estagios, [])

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="flex flex-col items-center ">
        <.search_form search_estagios={@search_estagios} />
        <.super_power_table estagios={@estagios} offset={@offset} />
      </div>
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

  def search_form(assigns) do
    ~H"""
    <div class="w-full max-w-2xl mx-4 my-8 relative">
      <form phx-change="search" class="w-full">
        <label class="input input-bordered input-lg w-full flex items-center gap-2">
          <.icon name="hero-magnifying-glass" class="size-5" />
          <input type="search" name="value" placeholder="Search" />
        </label>
      </form>

      <div
        :if={@search_estagios != []}
        class="absolute top-full left-0 w-full z-20 mt-1"
      >
        <ul class="rounded-box bg-base-100 shadow-md">
          <li
            :for={estagio <- @search_estagios}
            phx-click={JS.navigate("/estagios/#{estagio.id}")}
            class="px-4 py-2 hover:bg-base-200 cursor-pointer"
          >
            {estagio.titulo} -
            <div class="badge badge-primary">{estagio.universidade}</div>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("search", %{"value" => search_term}, socket) do
    with true <- String.length(search_term) > 2 do
      estagios = Vagas.search_estagio(search_term)
      {:noreply, assign(socket, :search_estagios, estagios)}
    else
      _ -> {:noreply, assign(socket, :search_estagios, [])}
    end
  end

  defp assign_estagios(socket) do
    offset = socket.assigns.offset

    estagios = Vagas.list_estagios(offset)
    assign(socket, :estagios, estagios)
  end

  def capturado_hoje_badge(assigns) do
    ~H"""
    <span class="badge badge-success">
      Nova
    </span>
    """
  end
end
