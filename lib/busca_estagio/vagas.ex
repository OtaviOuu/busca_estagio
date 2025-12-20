defmodule BuscaEstagio.Vagas do
  alias BuscaEstagio.Vagas.Usp.GetAllEescVagas

  defdelegate crawl_usp_eesc_vagas, to: GetAllEescVagas, as: :call
end
