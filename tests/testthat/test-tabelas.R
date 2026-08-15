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
