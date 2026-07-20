test_that("num_br usa ponto no milhar e virgula no decimal", {
  expect_identical(num_br(1234567), "1.234.567")
  expect_identical(num_br(33.126, dec = 2), "33,13")
  expect_identical(num_br(0), "0")
})

test_that("num_br nao vaza espaco de padding num vetor desigual", {
  # este e o motivo de usar formatC() e nao format(): com format(), o vetor
  # inteiro e alinhado a uma largura comum e o numero curto vem com espaco na
  # frente -- que aparece calado no meio de uma frase do artigo.
  saida <- num_br(c(7, 1234567))
  expect_identical(saida, c("7", "1.234.567"))
  expect_false(any(grepl("^\\s", saida)))
})

test_that("num_br preserva o comprimento do vetor", {
  expect_length(num_br(c(1, 22, 333, 4444)), 4L)
})

test_that("pct_br cola o sinal de porcento", {
  expect_identical(pct_br(33.126), "33,1%")
  expect_identical(pct_br(5, dec = 0), "5%")
})

test_that("mil divide por mil e arredonda", {
  expect_identical(mil(137063), "137")
  expect_identical(mil(1500), "2")          # arredondamento do formatC
  expect_identical(mil(137063, dec = 1), "137,1")
})
