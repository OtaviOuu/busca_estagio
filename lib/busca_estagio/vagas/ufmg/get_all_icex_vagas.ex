defmodule BuscaEstagio.Vagas.Ufmg.GetAllIcexVagas do
  require Logger

  @base_url "https://www.icex.ufmg.br"
  @all_posts_url "#{@base_url}/icex_novo/oportunidades/"

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
    |> Floki.find(".eael-timeline-post")
    |> Floki.find("a.eael-timeline-post-link")
    |> Floki.attribute("href")
  end

  defp crawl_vaga_page(url) do
    Logger.info("Crawling UFMG ICEX vaga page: #{url}")

    with {:ok, response} <- Req.get(url),
         {:ok, html_tree} <- Floki.parse_document(response.body) do
      descricao =
        html_tree
        |> Floki.find(".post.type-post.format-standard.hentry")

      titulo =
        descricao
        |> Floki.find(".entry-title")
        |> Floki.text()
        |> String.trim()

      %{
        descricao: descricao |> Floki.raw_html(),
        link: url,
        universidade: :ufmg_icex,
        empresa: "to sem crédito pra llm",
        titulo: titulo
      }
    end
  end
end
