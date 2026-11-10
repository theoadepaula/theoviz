test_that("tabela_gt devolve um gt_tbl", {
  g <- tabela_gt(head(mtcars[, 1:3]))
  expect_s3_class(g, "gt_tbl")
})

test_that("titulo, subtitulo e nota entram quando informados", {
  g <- tabela_gt(head(mtcars[, 1:2]),
                 titulo = "Um titulo",
                 subtitulo = "Uma linha de apoio",
                 nota = "Fonte: *exemplo*.")
  html <- as.character(gt::as_raw_html(g))
  expect_match(html, "Um titulo")
  expect_match(html, "Uma linha de apoio")
  expect_match(html, "exemplo")
})

test_that("sem titulo nao ha cabecalho", {
  html <- as.character(gt::as_raw_html(tabela_gt(head(mtcars[, 1:2]))))
  expect_false(grepl("gt_heading", html))
})

test_that("o tabular-nums entra no CSS -- e o que alinha as casas decimais", {
  html <- as.character(gt::as_raw_html(tabela_gt(head(mtcars[, 1:2]))))
  expect_match(html, "tabular-nums")
})

test_that("fmt_br e fmt_pct_br devolvem gt_tbl encadeavel", {
  d <- data.frame(n = c(1234.5, 6789.1), p = c(0.331, 0.379))
  expect_s3_class(fmt_br(tabela_gt(d), n, decimais = 1), "gt_tbl")
  expect_s3_class(fmt_pct_br(tabela_gt(d), p), "gt_tbl")
})

# --- a caixa branca, e o fim dela -------------------------------------------
#
# Ate a 0.2.0 esta funcao nao dizia uma cor sequer, e o gt preenchia o silencio
# com `background-color: #FFFFFF` e texto `#333333`, inline. Como as paginas do
# site sao escuras, TODA tabela de TODO artigo ia ao ar como um retangulo branco
# no meio do texto. Estes testes existem para que isso nao volte calado.

.html <- function(...) as.character(gt::as_raw_html(tabela_gt(...)))

test_that("o modo escuro nao crava fundo branco", {
  h <- .html(head(mtcars[, 1:2]), titulo = "T", modo = "escuro")
  expect_false(grepl("background-color: #FFFFFF", h, fixed = TRUE))
  expect_false(grepl("color: #333333", h, fixed = TRUE))
})

test_that("no escuro a tabela e transparente: pousa na pagina", {
  # Mesma escolha ja feita nos graficos plotly (paper_bgcolor rgba(0,0,0,0)).
  h <- .html(head(mtcars[, 1:2]), titulo = "T", modo = "escuro")
  expect_match(h, "background-color: rgba(255, 255, 255, 0)", fixed = TRUE)
})

test_that("no claro a tabela assume ser uma superficie clara", {
  # NAO e transparente de proposito: tinta escura sobre transparente seria
  # ilegivel justamente na pagina escura em que os artigos vivem.
  h <- .html(head(mtcars[, 1:2]), titulo = "T")
  expect_match(h, toupper(tinta("fundo")), fixed = TRUE)
})

test_that("as tintas do modo escolhido chegam ao HTML", {
  h <- .html(head(mtcars[, 1:2]), titulo = "T", nota = "n", modo = "escuro")
  expect_match(h, toupper(tinta("media", modo = "escuro")), fixed = TRUE)  # corpo
  expect_match(h, toupper(tinta("forte", modo = "escuro")), fixed = TRUE)  # titulo
  expect_match(h, toupper(tinta("grade", modo = "escuro")), fixed = TRUE)  # regua
})

test_that("modo desconhecido e rejeitado", {
  expect_error(tabela_gt(head(mtcars[, 1:2]), modo = "sepia"))
})

test_that("o modo claro segue sendo o padrao", {
  # o gt sorteia um id de div a cada chamada; ele nao faz parte do estilo
  sem_id <- function(h) sub("id=\"[a-z]+\"", "id=\"x\"", h)
  expect_identical(
    sem_id(.html(head(mtcars[, 1:2]), titulo = "T")),
    sem_id(.html(head(mtcars[, 1:2]), titulo = "T", modo = "claro"))
  )
})

# --- headers que apontam para cabecalhos de verdade (0.4.1) ----------------
#
# Ate o gt 1.3.0, a coluna `2025` saia com <th id="a2025"> e <td
# headers="2025">, e a coluna `Garrafa plastica` com <th id="Garrafa-plastica">
# e <td headers="Garrafa plastica">. O leitor de tela perdia o cabecalho e o
# Lighthouse acusava `td-headers-attr` nos artigos da agua mineral. Este teste
# le o HTML como o Lighthouse le: todo id citado em `headers` tem de ser o id de
# um <th> da mesma tabela, e nunca o da propria celula.

.ids_orfaos <- function(html) {
  ths <- regmatches(html, gregexpr("<th\\b[^>]*>", html, perl = TRUE))[[1]]
  ths <- ths[grepl("\\sid=\"", ths)]
  ids_th <- sub(".*\\sid=\"([^\"]*)\".*", "\\1", ths)

  tds <- regmatches(html, gregexpr("<td\\b[^>]*\\sheaders=\"[^\"]*\"[^>]*>",
                                   html, perl = TRUE))[[1]]
  orfaos <- unlist(lapply(tds, function(td) {
    citados <- strsplit(sub(".*\\sheaders=\"([^\"]*)\".*", "\\1", td), "\\s+")[[1]]
    citados <- citados[nzchar(citados)]
    proprio <- if (grepl("\\sid=\"", td)) sub(".*\\sid=\"([^\"]*)\".*", "\\1", td)
    c(setdiff(citados, ids_th), intersect(citados, proprio))
  }))
  list(n_td = length(tds), orfaos = unique(orfaos))
}

test_that("todo id citado em headers= e de um <th> da tabela", {
  # os nomes que quebravam: algarismo na frente, espaco, parentese, acento
  d <- data.frame(
    Embalagem          = c("Garrafao", "Copo", "Lata"),
    `2010`             = c(1.2, 0.8, 2.1),
    `2025`             = c(1.8, 1.1, 2.9),
    `Garrafa plastica` = c(10, 20, 30),
    `Valor de venda (R$)` = c(1000, 2000, 3000),
    variacao           = c(0.1, 0.2, 0.3),
    check.names = FALSE
  )
  # acento escrito em escape: o arquivo de teste fica ASCII
  names(d)[6] <- "In\u00edcio da varia\u00e7\u00e3o"

  g <- tabela_gt(d, titulo = "T", subtitulo = "s", nota = "n", modo = "escuro")
  g <- fmt_br(g, `Valor de venda (R$)`)
  g <- fmt_pct_br(g, 6)
  r <- .ids_orfaos(as.character(gt::as_raw_html(g)))
  expect_gt(r$n_td, 0)            # o teste nao passa por nao achar celula
  expect_identical(r$orfaos, character(0))

  # com grupo de linhas de nome composto (todas as linhas num grupo -- ver a
  # secao "Cabecalhos para o leitor de tela" de ?tabela_gt)
  g <- gt::tab_row_group(g, label = "Grupo B", rows = 3)
  g <- gt::tab_row_group(g, label = "Grupo A", rows = 1:2)
  r <- .ids_orfaos(as.character(gt::as_raw_html(g)))
  expect_gt(r$n_td, 0)
  expect_identical(r$orfaos, character(0))

  # e no modo claro, que passa pelo mesmo gt
  r <- .ids_orfaos(as.character(gt::as_raw_html(tabela_gt(d))))
  expect_identical(r$orfaos, character(0))
})

# --- a Regra das Duas Vozes -------------------------------------------------

test_that("coluna numerica sai em mono; o resto, em sans", {
  d <- data.frame(rotulo = c("a", "b"), valor = c(1, 2),
                  stringsAsFactors = FALSE)
  h <- as.character(gt::as_raw_html(tabela_gt(d)))
  expect_match(h, "IBM Plex Mono")
  expect_match(h, "IBM Plex Sans")
})

test_that("tabela sem coluna numerica nao pede a mono", {
  d <- data.frame(a = c("x", "y"), b = c("z", "w"), stringsAsFactors = FALSE)
  h <- as.character(gt::as_raw_html(tabela_gt(d)))
  expect_false(grepl("IBM Plex Mono", h, fixed = TRUE))
})
