defmodule BuscaEstagio.Vagas do
  alias BuscaEstagio.Vagas.Usp
  alias BuscaEstagio.Vagas
  defdelegate crawl_usp_eesc_vagas, to: Usp.GetAllEescVagas, as: :call

  defdelegate crawl_usp_fearp_vagas, to: Usp.GetAllFearpVagas, as: :call

  defdelegate get_estagio_by_id(estagio_id), to: Vagas.GetEstagioById, as: :call
  defdelegate list_estagios(offset \\ 0), to: Vagas.ListEstagios, as: :call
end
