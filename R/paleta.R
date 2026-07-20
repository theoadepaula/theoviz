# Paleta compartilhada -------------------------------------------------------
#
# Estas cores NAO sao escolha estetica -- sao um mecanismo de seguranca.
# A separacao foi validada para daltonismo (protanopia, deuteranopia,
# tritanopia): pior par adjacente com DeltaE 17,6 em protanopia, contra um piso
# de 8. O piso de visao normal e 29,0.
#
# A ORDEM DOS SLOTS FAZ PARTE DA VALIDACAO. Usar s1 e s3 num grafico de duas
# series e seguro; trocar s2 por uma cor "parecida" nao e.
#
# Limite conhecido: o magenta (s3) fica abaixo de 3:1 de contraste sobre fundo
# branco. Por isso a regra que acompanha esta paleta em todo projeto:
# **todo grafico traz rotulo direto na ponta da serie**, alem da legenda. A
# identidade de uma serie nunca pode depender so da cor.
#
# Antes deste pacote, estas mesmas cores estavam copiadas em tres projetos sob
# tres nomes diferentes (COR$s1, PAL["slot1"], CORES["s1"]). Eram identicas byte
# a byte -- o que so se descobriu ao compara-las em 2026-07-19.

#' Cores de serie
#'
#' Os quatro slots categoricos da paleta, na ordem validada.
#'
#' @param n Quantos slots devolver (1 a 4). Sem argumento, devolve os quatro.
#' @return Vetor nomeado de cores em hexadecimal.
#' @examples
#' paleta()      # os quatro
#' paleta(2)     # so os dois primeiros: azul e verde
#' @export
paleta <- function(n = 4) {
  cores <- c(
    s1 = "#2a78d6",  # azul
    s2 = "#008300",  # verde
    s3 = "#e87ba4",  # magenta -- exige rotulo direto (contraste < 3:1)
    s4 = "#eda100"   # ambar   -- tambem usado para destacar linha em tabela
  )
  if (!is.numeric(n) || length(n) != 1 || n < 1 || n > length(cores)) {
    stop("`n` deve ser um numero de 1 a ", length(cores), ".", call. = FALSE)
  }
  cores[seq_len(n)]
}

#' Tintas neutras
#'
#' Cinzas de texto, grade e fundo. Separados das cores de serie porque nunca
#' codificam dado -- so estrutura.
#'
#' @param qual Nome de uma tinta. Sem argumento, devolve todas.
#' @return Vetor nomeado de cores em hexadecimal.
#' @examples
#' tinta()
#' tinta("grade")
#' @export
tinta <- function(qual = NULL) {
  tintas <- c(
    forte  = "#0b0b0b",  # titulo
    media  = "#52514e",  # corpo de texto
    fraca  = "#898781",  # eixo, legenda, fonte
    grade  = "#e1e0d9",  # linhas de grade
    eixo   = "#c3c2b7",  # linha do eixo
    fundo  = "#fcfcfb"   # superficie do grafico
  )
  if (is.null(qual)) return(tintas)
  if (!qual %in% names(tintas)) {
    stop("tinta desconhecida: '", qual, "'. Use uma de: ",
         paste(names(tintas), collapse = ", "), ".", call. = FALSE)
  }
  tintas[[qual]]
}

#' Grade em rgba, para plotly
#'
#' O plotly precisa de fundo transparente para o widget herdar a cor da pagina
#' em vez de cravar um branco dentro do tema escuro do site. A grade entao
#' precisa de alfa, que hexadecimal de 6 digitos nao carrega.
#'
#' @param alfa Opacidade, de 0 a 1.
#' @return String no formato "rgba(r,g,b,a)".
#' @examples
#' grade_rgba()
#' @export
grade_rgba <- function(alfa = 0.22) {
  if (!is.numeric(alfa) || length(alfa) != 1 || alfa < 0 || alfa > 1) {
    stop("`alfa` deve ser um numero entre 0 e 1.", call. = FALSE)
  }
  sprintf("rgba(138,138,133,%s)", format(alfa, trim = TRUE))
}
