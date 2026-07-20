# A paleta e um mecanismo de seguranca validado para daltonismo, nao uma
# escolha estetica. Este teste existe para que trocar uma cor exija trocar
# tambem o teste -- ou seja, para que a troca seja deliberada e revalidada,
# nunca um deslize de refatoracao.

test_that("as cores de serie sao exatamente as validadas", {
  expect_identical(
    paleta(),
    c(s1 = "#2a78d6", s2 = "#008300", s3 = "#e87ba4", s4 = "#eda100")
  )
})

test_that("paleta(n) devolve os n primeiros slots, na ordem", {
  expect_identical(paleta(1), c(s1 = "#2a78d6"))
  expect_identical(paleta(2), c(s1 = "#2a78d6", s2 = "#008300"))
  expect_length(paleta(4), 4)
})

test_that("paleta rejeita n fora da faixa", {
  expect_error(paleta(0), "de 1 a 4")
  expect_error(paleta(5), "de 1 a 4")
  expect_error(paleta("dois"), "de 1 a 4")
})

test_that("as tintas neutras sao as validadas", {
  expect_identical(
    tinta(),
    c(forte = "#0b0b0b", media = "#52514e", fraca = "#898781",
      grade = "#e1e0d9", eixo = "#c3c2b7", fundo = "#fcfcfb")
  )
  expect_identical(tinta("grade"), "#e1e0d9")
})

test_that("tinta rejeita nome desconhecido", {
  expect_error(tinta("azul"), "tinta desconhecida")
})

test_that("grade_rgba monta rgba valido para o plotly", {
  expect_identical(grade_rgba(0.22), "rgba(138,138,133,0.22)")
  expect_identical(grade_rgba(1), "rgba(138,138,133,1)")
  expect_error(grade_rgba(2), "entre 0 e 1")
})

test_that("nenhuma cor de serie colide com outra", {
  expect_length(unique(paleta()), 4L)
})
