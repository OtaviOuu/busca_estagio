defmodule BuscaEstagio.Scrapers.Scraper do
  @callback get_html(String.t()) :: {:ok, String.t()} | {:error, any()}
end
