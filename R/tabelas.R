# Tema canonico das tabelas gt ----------------------------------------------
#
# Aprovado por Theo em 2026-07-19, a partir do estilo dos artigos do projeto
# Relatorios_slu, e valido para todos os projetos.
#
# O layout, em uma frase: regua horizontal apenas, cabecalho discreto alinhado
# a esquerda, nenhuma linha vertical. Coluna se separa por espaco, nao por
# tinta.
#
# Saida crua de tibble em <pre> nao vai ao ar. Se a tabela precisa de um estilo
# diferente, o lugar de mudar e aqui -- foi reimplementar o layout dentro de
# cada projeto que fez os tres divergirem antes.

#' Tabela no estilo padrao dos artigos
#'
#' @param dados     data.frame ou tibble.
#' @param titulo    Titulo da tabela (opcional).
#' @param subtitulo Linha de apoio abaixo do titulo (opcional).
#' @param nota      Nota de rodape; aceita markdown (opcional).
#' @return Um objeto `gt_tbl`, encadeavel com as funcoes do pacote gt.
#' @examples
#' tabela_gt(head(mtcars[, 1:3]), titulo = "Exemplo")
#' @export
tabela_gt <- function(dados, titulo = NULL, subtitulo = NULL, nota = NULL) {
  g <- gt::gt(dados)

  if (!is.null(titulo)) {
    g <- gt::tab_header(g, title = titulo, subtitle = subtitulo)
  }

  g <- gt::tab_options(
    gt::opt_table_font(
      g,
      font = list(gt::google_font("IBM Plex Sans"), gt::default_fonts())
    ),
    table.font.size            = gt::px(14),
    # sem moldura: a tabela flutua no texto em vez de virar caixa
    table.border.top.style     = "none",
    table.border.bottom.style  = "none",
    heading.title.font.size    = gt::px(15),
    heading.title.font.weight  = "600",
    heading.subtitle.font.size = gt::px(13),
    heading.border.bottom.width = gt::px(1),
    column_labels.font.weight  = "600",
    column_labels.border.top.style = "none",
    column_labels.border.bottom.width = gt::px(1),
    # sem regua entre linhas: em tabela curta, a linha e ruido
    table_body.hlines.style    = "none",
    table_body.border.bottom.width = gt::px(1),
    data_row.padding           = gt::px(5),
    source_notes.font.size     = gt::px(12),
    source_notes.border.lr.style = "none"
  )

  g <- gt::opt_align_table_header(g, align = "left")

  # digitos de largura fixa: sem isso as casas decimais nao alinham na vertical
  # e a coluna de numero fica tremida
  g <- gt::opt_css(g, "table td { font-variant-numeric: tabular-nums; }")

  if (!is.null(nota)) g <- gt::tab_source_note(g, gt::md(nota))
  g
}

#' Formata colunas numericas em pt-BR
#'
#' Atalho para `gt::fmt_number()` com separador de milhar ponto e decimal
#' virgula, que e o que os artigos usam em toda tabela.
#'
#' @param g        Objeto `gt_tbl`.
#' @param colunas  Colunas a formatar (tidyselect).
#' @param decimais Casas decimais.
#' @return O `gt_tbl` com as colunas formatadas.
#' @export
fmt_br <- function(g, colunas, decimais = 0) {
  gt::fmt_number(g, columns = {{ colunas }}, decimals = decimais,
                 sep_mark = ".", dec_mark = ",")
}

#' Formata colunas de percentual em pt-BR
#'
#' @inheritParams fmt_br
#' @return O `gt_tbl` com as colunas formatadas como percentual.
#' @export
fmt_pct_br <- function(g, colunas, decimais = 1) {
  gt::fmt_percent(g, columns = {{ colunas }}, decimals = decimais,
                  sep_mark = ".", dec_mark = ",")
}
