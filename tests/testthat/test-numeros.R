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

test_that("NA sai \"NA\", sem padding, com qualquer numero de casas", {
  # formatC() aplicava largura minima `digits + 1` aos valores nao finitos:
  # ate a 0.4.1, num_br(NA, 2) devolvia " NA" e num_br(NA, 3), "  NA".
  for (dec in 0:3) {
    expect_identical(num_br(NA_real_, dec), "NA", info = paste("dec =", dec))
    expect_identical(num_br(NA, dec), "NA", info = paste("dec =", dec))
    expect_identical(num_br(NA_integer_, dec), "NA", info = paste("dec =", dec))
    expect_identical(mil(NA, dec), "NA", info = paste("dec =", dec))
    expect_identical(pct_br(NA, dec), "NA", info = paste("dec =", dec))
  }
})

test_that("NA no meio de um vetor nao herda largura dos vizinhos", {
  expect_identical(num_br(c(NA, 1, NaN, Inf, -Inf), 2),
                   c("NA", "1,00", "NaN", "Inf", "-Inf"))
  expect_identical(pct_br(c(12.34, NA), 1), c("12,3%", "NA"))
})

test_that("a correcao do NA nao muda a saida de numero valido", {
  # valores travados com a saida da 0.4.1, antes da correcao
  x <- c(0, -2.25, 1234.567, 1e6)
  expect_identical(num_br(x, 0), c("0", "-2", "1.235", "1.000.000"))
  expect_identical(num_br(x, 1), c("0,0", "-2,2", "1.234,6", "1.000.000,0"))
  expect_identical(num_br(x, 2), c("0,00", "-2,25", "1.234,57", "1.000.000,00"))
  expect_identical(num_br(x, 3),
                   c("0,000", "-2,250", "1.234,567", "1.000.000,000"))
  expect_identical(num_br(c(x, NA), 2),
                   c("0,00", "-2,25", "1.234,57", "1.000.000,00", "NA"))
})
