defmodule BuscaEstagio.Vagas.Usp.GetAllEescVagas do
  require Logger

  @base_url "https://eesc.usp.br/estagios"
  @all_posts_url "#{@base_url}/posts.php"

  @max_concurrency 20
  @retry_attempts 2

  alias BuscaEstagio.Vagas.CreateEstagio

  def call do
    with {:ok, response} <- Req.get(@all_posts_url),
         {:ok, html_tree} <- Floki.parse_document(response.body) do
      result =
        html_tree
        |> get_all_vagas_hrefs()
        |> Task.async_stream(&crawl_vaga_page/1,
          ordered: false,
          max_concurrency: @max_concurrency,
          timeout: :infinity,
          retry: @retry_attempts
        )
        |> Stream.map(fn {:ok, vaga_attrs} -> vaga_attrs end)
        |> Enum.to_list()
        |> Enum.map(&CreateEstagio.call(&1))

      {:ok, result}
    else
      {:error, _reason} -> {:error, :failed_to_fetch_vagas}
    end
  end

  defp get_all_vagas_hrefs(html_tree) do
    html_tree
    |> Floki.find("#v-pills-tabContent")
    |> Floki.find("h5 a")
    |> Floki.attribute("href")
    |> Enum.map(&build_full_url/1)
  end

  defp crawl_vaga_page(url) do
    Logger.info("Crawling USP EESC vaga page: #{url}")
    {:ok, response} = Req.get(url)
    {:ok, html_tree} = Floki.parse_document(response.body)

    titulo =
      html_tree
      |> Floki.find("h5.title-not")
      |> Floki.text()
      |> String.trim()

    descricao =
      html_tree
      |> Floki.find(".tab-content .mt-4")
      |> Floki.text()
      |> String.trim()

    %{
      titulo: titulo,
      descricao: descricao,
      link: url,
      universidade: :usp_eesc,
      empresa: "sei não pae"
    }
  end

  defp build_full_url(href) do
    URI.merge(@all_posts_url, href) |> to_string()
  end
end
