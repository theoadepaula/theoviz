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
#' @param x   Vetor numerico.
#' @param dec Casas decimais.
#' @return Vetor de texto do mesmo comprimento de `x`.
#' @examples
#' num_br(1234567)          # "1.234.567"
#' num_br(33.126, dec = 2)  # "33,13"
#' @export
num_br <- function(x, dec = 0) {
  formatC(x, format = "f", digits = dec, big.mark = ".", decimal.mark = ",")
}

#' Percentual em pt-BR
#'
#' @param x   Vetor numerico ja em escala de 0 a 100 (nao de 0 a 1).
#' @param dec Casas decimais.
#' @return Vetor de texto, com o sinal de porcento colado.
#' @examples
#' pct_br(33.126)  # "33,1%"
#' @export
pct_br <- function(x, dec = 1) {
  paste0(num_br(x, dec), "%")
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
