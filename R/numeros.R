# Formatacao numerica em pt-BR ----------------------------------------------
#
# Separador de milhar ponto, decimal virgula. Parece trivial, mas estava
# implementado tres vezes -- `num_br()` no tema canonico, `pt()` no Cargos e
# `n_br()` no Anuario -- e as tres NAO eram equivalentes: duas usavam
# `format()`, que alinha o vetor inteiro a uma largura comum e obriga a passar
# `trim = TRUE` para nao vazar espaco no meio da frase; uma usava `formatC()`,
# que formata elemento a elemento.
#
# Aqui vale `formatC()`, que e o comportamento correto para texto corrido.
#
# ATENCAO ao adotar: se um projeto trocar o helper local por este, confira o
# HTML renderizado antes de commitar. Diferenca de padding nao quebra o build --
# ela aparece calada no meio de uma frase.

#' Numero em pt-BR
#'
#' Milhar com ponto, decimal com virgula. Serve tanto dentro de uma tabela
#' quanto colado no texto de um artigo.
#'
#' Valores nao finitos saem sem espaco: `NA` vira `"NA"` com qualquer numero
#' de casas, assim como `NaN`, `Inf` e `-Inf`. Um `NA` logico solto (o `NA` de
#' `c(NA, NA)` ou de uma coluna vazia) e tratado como `NA` numerico.
#'
#' @param x   Vetor numerico.
#' @param dec Casas decimais.
#' @return Vetor de texto do mesmo comprimento de `x`.
#' @examples
#' num_br(1234567)          # "1.234.567"
#' num_br(33.126, dec = 2)  # "33,13"
#' num_br(NA, dec = 2)      # "NA"
#' @export
num_br <- function(x, dec = 0) {
  if (is.logical(x) && all(is.na(x))) x <- as.numeric(x)
  saida <- formatC(x, format = "f", digits = dec,
                   big.mark = ".", decimal.mark = ",")
  # formatC() usa largura minima `digits + 1` quando `width` nao e dado, e a
  # aplica so aos valores nao finitos: com 2 casas, NA saia " NA"; com 3,
  # "  NA". Num vetor, o NA era ainda alinhado ao NaN/Inf vizinho. Os numeros
  # finitos nao sao afetados -- so os nao finitos perdem o padding.
  nao_finito <- !is.finite(x)
  saida[nao_finito] <- trimws(saida[nao_finito])
  saida
}

#' Percentual em pt-BR
#'
#' @param x   Vetor numerico ja em escala de 0 a 100 (nao de 0 a 1).
#' @param dec Casas decimais.
#' @return Vetor de texto, com o sinal de porcento colado. `NA` sai `"NA"`,
#'   sem o sinal, como em [num_br()].
#' @examples
#' pct_br(33.126)  # "33,1%"
#' pct_br(NA)      # "NA"
#' @export
pct_br <- function(x, dec = 1) {
  saida <- paste0(num_br(x, dec), "%")
  saida[is.na(x)] <- "NA"
  saida
}

#' Numero em milhares
#'
#' Para eixos e rotulos onde a unidade inteira polui. `mil(137063)` devolve
#' "137", nao "137.063".
#'
#' @param x   Vetor numerico.
#' @param dec Casas decimais depois de dividir por mil.
#' @return Vetor de texto.
#' @examples
#' mil(137063)  # "137"
#' @export
mil <- function(x, dec = 0) {
  num_br(x / 1000, dec)
}
