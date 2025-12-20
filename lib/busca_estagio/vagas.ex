defmodule BuscaEstagio.Vagas do
  alias BuscaEstagio.Vagas.Usp

  defdelegate crawl_usp_eesc_vagas, to: Usp.GetAllEescVagas, as: :call

  defdelegate crawl_usp_fearp_vagas, to: Usp.GetAllFearpVagas, as: :call
end
