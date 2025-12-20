defmodule BuscaEstagio.Vagas.Universidades do
  @universidades %{
    usp_icmc: "USP - Instituto de Ciências Matemáticas e de Computação",
    usp_fearp: "USP - Faculdade de Economia, Administração e Contabilidade de Ribeirão Preto",
    usp_eesc: "USP - Escola de Engenharia de São Carlos"
  }

  def labels, do: Map.keys(@universidades)
end
