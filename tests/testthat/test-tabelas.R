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
