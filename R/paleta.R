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
#
# MODO ESCURO (desde 0.2.0) ---------------------------------------------------
#
# O modo escuro NAO e um clareamento automatico do claro: sao passos proprios,
# validados contra a superficie escura (#1a1a19), como manda o metodo. Foram
# medidos em 2026-07-19 com o validador do skill `dataviz`:
#
#   claro  (superficie #fcfcfb)  pior par adjacente DeltaE 16,3 (deutan)
#                                contraste: s3 2,62 e s4 2,11 -- ABAIXO de 3:1
#   escuro (superficie #1a1a19)  pior par adjacente DeltaE 13,0 (deutan)
#                                contraste: os quatro ACIMA de 3:1
#
# Ou seja: no escuro a paleta e mais segura em contraste que no claro. A regra do
# rotulo direto nasce do modo CLARO, e vale nos dois por consistencia.
#
# LIMITE DO MODO ESCURO: no conjunto de TODOS os pares (nao so os adjacentes), o
# par s2 (verde) x s4 (ambar) cai para DeltaE 6,9 em protanopia -- dentro da
# faixa 6-8, que so e legal com codificacao secundaria. Um grafico escuro que use
# **somente s2 e s4** precisa de rotulo direto ou textura. Usando os slots na
# ordem (s1, s2, s3...) o problema nao aparece.

#' Cores de serie
#'
#' Os quatro slots categoricos da paleta, na ordem validada.
#'
#' @param n Quantos slots devolver (1 a 4). Sem argumento, devolve os quatro.
#' @param modo `"claro"` (padrao) ou `"escuro"`. O modo escuro tem passos
#'   proprios, validados contra a superficie escura -- nao e um clareamento
#'   automatico do claro.
#' @return Vetor nomeado de cores em hexadecimal.
#' @examples
#' paleta()                    # os quatro, modo claro
#' paleta(2)                   # so os dois primeiros: azul e verde
#' paleta(modo = "escuro")     # os quatro passos do modo escuro
#' @export
paleta <- function(n = 4, modo = c("claro", "escuro")) {
  modo <- match.arg(modo)
  cores <- if (modo == "claro") c(
    s1 = "#2a78d6",  # azul
    s2 = "#008300",  # verde
    s3 = "#e87ba4",  # magenta -- exige rotulo direto (contraste < 3:1)
    s4 = "#eda100"   # ambar   -- tambem usado para destacar linha em tabela
  ) else c(
    s1 = "#3987e5",  # azul    -- clareado para o fundo escuro
    s2 = "#008300",  # verde   -- unico slot igual nos dois modos
    s3 = "#d55181",  # magenta -- escurecido: no fundo escuro o claro estourava
    s4 = "#c98500"   # ambar   -- ver limite s2 x s4 no cabecalho deste arquivo
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
#' @param modo `"claro"` (padrao) ou `"escuro"`.
#' @return Vetor nomeado de cores em hexadecimal.
#' @examples
#' tinta()
#' tinta("grade")
#' tinta("fundo", modo = "escuro")
#' @export
tinta <- function(qual = NULL, modo = c("claro", "escuro")) {
  modo <- match.arg(modo)
  tintas <- if (modo == "claro") c(
    forte  = "#0b0b0b",  # titulo
    media  = "#52514e",  # corpo de texto
    fraca  = "#898781",  # eixo, legenda, fonte
    grade  = "#e1e0d9",  # linhas de grade
    eixo   = "#c3c2b7",  # linha do eixo
    fundo  = "#fcfcfb"   # superficie do grafico
  ) else c(
    forte  = "#ffffff",
    media  = "#c3c2b7",
    fraca  = "#898781",  # a tinta fraca e a mesma nos dois modos, de proposito:
                         # e o cinza que fica legivel sobre claro e sobre escuro
    grade  = "#2c2c2a",
    eixo   = "#383835",
    fundo  = "#1a1a19"   # superficie usada na validacao do modo escuro
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
