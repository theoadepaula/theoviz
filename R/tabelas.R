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
#
# A CAIXA BRANCA (corrigido na 0.3.0) ----------------------------------------
#
# Ate a 0.2.0 esta funcao nao dizia UMA cor. Parecia elegancia -- "a tabela
# herda a pagina" -- e era o oposto: o gt nao herda nada. Sem instrucao, ele
# crava `background-color: #FFFFFF` com texto `#333333`, e era exatamente isso
# que ia ao ar. Toda tabela de todo artigo era um retangulo branco no meio de
# uma pagina escura, e nenhum `custom.scss` derrubava aquilo, porque o gt
# escreve estilo inline.
#
# Dai o argumento `modo`. E dai, tambem, a decisao de o modo escuro pintar
# `transparent` em vez de #0d1014: e a mesma escolha ja feita nos graficos
# plotly do SLU (`paper_bgcolor = "rgba(0,0,0,0)"`), pelo mesmo motivo -- a
# tabela pousa na pagina em vez de recortar uma chapa dentro dela. O modo claro
# NAO e transparente, de proposito: transparente com tinta escura por cima seria
# ilegivel justamente na pagina escura em que os artigos vivem hoje. No claro, a
# tabela assume ser uma superficie clara.
#
# A VOZ DA MEDIDA (0.3.0) ----------------------------------------------------
#
# "Sans e discurso, Mono e medida. A fronteira e semantica, nao estetica: um
# numero que existe para ser comparado vai em mono mesmo dentro de um paragrafo
# em sans."   -- A Regra das Duas Vozes, DESIGN.md do site
#
# As colunas numericas passaram a sair em IBM Plex Mono. Nao e enfeite de
# codigo: e o sinal de que aquilo e medida. O `tabular-nums` ja estava aqui
# desde a 0.1.0 e resolvia metade do problema -- alinhava os algarismos, mas
# deixava o numero na voz da prosa.

# Aplica o par de fontes do site. Sao as mesmas duas familias do CSS, com a
# cadeia de fallback do gt atras, para o caso de a fonte nao carregar.
.fonte_sans <- function() {
  list(gt::google_font("IBM Plex Sans"), gt::default_fonts())
}
.fonte_mono <- function() {
  list(gt::google_font("IBM Plex Mono"), "ui-monospace", "SFMono-Regular",
       "Menlo", "Consolas", "monospace")
}

#' Tabela no estilo padrao dos artigos
#'
#' O tema canonico das tabelas `gt`: regua horizontal apenas, cabecalho discreto
#' alinhado a esquerda, nenhuma linha vertical. Coluna se separa por espaco, nao
#' por tinta.
#'
#' @section A tabela e o par acessivel do grafico:
#'
#' Quando a cor falha -- daltonismo, impressao em preto e branco, tela ruim --
#' e a tabela que responde. Por isso ela nao e opcional num artigo com figura, e
#' por isso saida crua de tibble em `<pre>` nao vai ao ar.
#'
#' @section Escolha o modo pela pagina em que a tabela vai cair:
#'
#' O `gt` **nao herda** a cor da pagina: sem instrucao ele crava fundo branco com
#' texto cinza-escuro, inline, e nenhuma folha de estilo do site derruba isso.
#' Como as paginas do site sao escuras, uma tabela em `modo = "claro"` la dentro
#' e um retangulo branco no meio do texto.
#'
#' \describe{
#'   \item{`"escuro"`}{fundo **transparente** e tintas do site. A tabela pousa na
#'     pagina em vez de recortar uma chapa dentro dela -- a mesma escolha ja
#'     feita nos graficos plotly. E o modo do que vai ao ar.}
#'   \item{`"claro"` (padrao)}{superficie clara explicita. Serve impressao, slide
#'     e PDF. Nao e transparente de proposito: transparente com tinta escura por
#'     cima seria ilegivel na pagina escura.}
#' }
#'
#' O padrao segue `"claro"` pela razao descrita em [tinta()]: trocar o padrao
#' restilizaria de uma vez artigos ja congelados por `freeze`.
#'
#' @section As duas vozes:
#'
#' Colunas numericas saem em **IBM Plex Mono**, o resto em **IBM Plex Sans**.
#' E a Regra das Duas Vozes do site: sans e discurso, mono e medida. A fronteira
#' e semantica, nao estetica -- um numero existe para ser comparado com outro, e
#' a mono e o que diz isso.
#'
#' @param dados     data.frame ou tibble.
#' @param titulo    Titulo da tabela (opcional).
#' @param subtitulo Linha de apoio abaixo do titulo (opcional).
#' @param nota      Nota de rodape; aceita markdown (opcional).
#' @param modo      `"claro"` (padrao) ou `"escuro"`. Ver a secao acima.
#' @return Um objeto `gt_tbl`, encadeavel com as funcoes do pacote gt.
#' @seealso [fmt_br()] e [fmt_pct_br()] para a formatacao pt-BR das colunas;
#'   [tinta()] para as tintas que este tema consome.
#' @examples
#' tabela_gt(head(mtcars[, 1:3]), titulo = "Exemplo")
#'
#' # o que vai ao ar, porque o site e escuro:
#' tabela_gt(head(mtcars[, 1:3]), titulo = "Exemplo", modo = "escuro")
#' @export
tabela_gt <- function(dados, titulo = NULL, subtitulo = NULL, nota = NULL,
                      modo = c("claro", "escuro")) {
  modo <- match.arg(modo)

  forte <- tinta("forte", modo = modo)
  media <- tinta("media", modo = modo)
  fraca <- tinta("fraca", modo = modo)
  regua <- tinta("grade", modo = modo)
  # transparente so no escuro -- ver o cabecalho deste arquivo
  chao  <- if (modo == "escuro") "transparent" else tinta("fundo", modo = modo)

  g <- gt::gt(dados)

  if (!is.null(titulo)) {
    g <- gt::tab_header(g, title = titulo, subtitle = subtitulo)
  }

  g <- gt::tab_options(
    gt::opt_table_font(g, font = .fonte_sans()),
    table.font.size            = gt::px(14),
    table.font.color           = media,
    table.background.color     = chao,
    # sem moldura: a tabela flutua no texto em vez de virar caixa
    table.border.top.style     = "none",
    table.border.bottom.style  = "none",
    heading.background.color   = chao,
    heading.title.font.size    = gt::px(15),
    heading.title.font.weight  = "600",
    heading.subtitle.font.size = gt::px(13),
    heading.border.bottom.width = gt::px(1),
    heading.border.bottom.color = regua,
    column_labels.background.color    = chao,
    column_labels.font.weight         = "600",
    column_labels.border.top.style    = "none",
    column_labels.border.bottom.width = gt::px(1),
    column_labels.border.bottom.color = regua,
    # sem regua entre linhas: em tabela curta, a linha e ruido
    table_body.hlines.style    = "none",
    table_body.border.bottom.width = gt::px(1),
    table_body.border.bottom.color = regua,
    data_row.padding           = gt::px(5),
    source_notes.background.color = chao,
    source_notes.font.size     = gt::px(12),
    source_notes.border.lr.style = "none"
  )

  g <- gt::opt_align_table_header(g, align = "left")

  # Titulo e rotulo de coluna na tinta forte; nota de rodape na fraca. Sem isso
  # os tres saem na mesma cor e a hierarquia se perde -- que e o unico trabalho
  # que uma tabela sem regua vertical tem para fazer.
  g <- gt::tab_style(
    g,
    style = gt::cell_text(color = forte),
    locations = list(gt::cells_title(groups = "title"), gt::cells_column_labels())
  )
  g <- gt::tab_style(
    g,
    style = gt::cell_text(color = fraca),
    locations = list(gt::cells_title(groups = "subtitle"),
                     gt::cells_source_notes())
  )

  # A Regra das Duas Vozes: numero e medida, e medida vai em mono.
  colunas_num <- names(dados)[vapply(dados, is.numeric, logical(1))]
  if (length(colunas_num)) {
    g <- gt::tab_style(
      g,
      style = gt::cell_text(font = .fonte_mono()),
      locations = gt::cells_body(columns = gt::all_of(colunas_num))
    )
  }

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
#' @seealso [tabela_gt()], [num_br()].
#' @examples
#' fmt_br(tabela_gt(head(mtcars[, 1:3])), disp, decimais = 1)
#' @export
fmt_br <- function(g, colunas, decimais = 0) {
  gt::fmt_number(g, columns = {{ colunas }}, decimals = decimais,
                 sep_mark = ".", dec_mark = ",")
}

#' Formata colunas de percentual em pt-BR
#'
#' @inheritParams fmt_br
#' @return O `gt_tbl` com as colunas formatadas como percentual.
#' @seealso [tabela_gt()], [pct_br()].
#' @examples
#' d <- data.frame(faixa = c("a", "b"), parte = c(0.331, 0.669))
#' fmt_pct_br(tabela_gt(d), parte)
#' @export
fmt_pct_br <- function(g, colunas, decimais = 1) {
  gt::fmt_percent(g, columns = {{ colunas }}, decimals = decimais,
                  sep_mark = ".", dec_mark = ",")
}
