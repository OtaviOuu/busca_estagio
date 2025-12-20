defmodule BuscaEstagio.Vagas.Usp.GetAllFearpVagas do
  @base_url "https://www.fearp.usp.br/"
  @all_posts_url "#{@base_url}estagio/item/1116-vagas-online.html"
  @max_concurrency 20
  @retry_attempts 2

  require Logger
  alias BuscaEstagio.Vagas.CreateEstagio

  def call() do
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
    |> Floki.find("a[href*='images/estagio/Vagas']")
    |> Floki.attribute("href")
    |> Enum.map(&build_full_url/1)
  end

  defp crawl_vaga_page(url) do
    Logger.info("Crawling USP FEARP vaga page: #{url}")

    %{
      titulo: build_title_from_url(url),
      descricao: build_description(url),
      link: url,
      universidade: :usp_fearp,
      empresa: "sei não"
    }
  end

  defp build_description(pdf_url) do
    "<iframe src='#{pdf_url}' width='100%' height='600px'></iframe>"
  end

  def build_title_from_url(pdf_url) do
    # err
    pdf_url
    |> String.split("/")
    |> List.last()
    |> String.replace("_", " ")
    |> String.replace(".pdf", "")
  end

  defp build_full_url(href) do
    URI.merge(@base_url, href) |> to_string()
  end
end
