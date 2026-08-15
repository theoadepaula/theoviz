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
  expect_length(unique(paleta(modo = "escuro")), 4L)
})

# --- modo escuro -----------------------------------------------------------
# Mesma logica dos testes acima: os valores ficam travados para que troca-los
# exija tocar no teste, e portanto revalidar. Medidos em 2026-07-19 com o
# validador do skill `dataviz`: pior par adjacente DeltaE 13,0 (deutan).
#
# O chao mudou em 2026-08-09 (#1a1a19 -> #0d1014) e as cores de serie NAO
# mudaram junto, porque nao precisavam: DeltaE entre elas nao depende do fundo, e
# o contraste contra o fundo so melhorou. Quem confere isso e o test-site.R, que
# recalcula os contrastes contra o chao novo em vez de confiar no comentario.

test_that("as cores de serie do modo escuro sao exatamente as validadas", {
  expect_identical(
    paleta(modo = "escuro"),
    c(s1 = "#3987e5", s2 = "#008300", s3 = "#d55181", s4 = "#c98500")
  )
})

test_that("o modo claro segue sendo o padrao", {
  expect_identical(paleta(), paleta(modo = "claro"))
  expect_identical(tinta(),  tinta(modo = "claro"))
})

test_that("o verde e o unico slot igual nos dois modos", {
  iguais <- paleta() == paleta(modo = "escuro")
  expect_identical(names(paleta())[iguais], "s2")
})

test_that("modo escuro respeita n, na ordem", {
  expect_identical(paleta(1, modo = "escuro"), c(s1 = "#3987e5"))
  expect_identical(paleta(2, modo = "escuro"), c(s1 = "#3987e5", s2 = "#008300"))
})

test_that("as tintas do modo escuro sao os tokens do site", {
  # Rebaseadas na 0.3.0. Eram cinzas QUENTES herdados do sistema visual anterior
  # do site (#c3c2b7, #898781, #2c2c2a); o Boletim e um sistema FRIO. Cinza
  # quente sobre pagina fria nao le como neutro discreto -- le como figura
  # recortada de outro documento.
  expect_identical(
    tinta(modo = "escuro"),
    c(forte = "#dde1e6", media = "#a9b0b8", fraca = "#7d858e",
      grade = "#2c333c", eixo = "#2c333c", fundo = "#0d1014")
  )
  expect_identical(tinta("fundo", modo = "escuro"), site("noite"))
})

test_that("cada tinta escura aponta para o token do site correspondente", {
  # Se alguem redigitar um hexadecimal aqui em vez de consumir o site(), este
  # teste quebra -- que e o unico jeito de a fonte unica continuar unica.
  expect_identical(tinta("forte", modo = "escuro"), site("titulo"))
  expect_identical(tinta("media", modo = "escuro"), site("leitura"))
  expect_identical(tinta("fraca", modo = "escuro"), site("rotulo"))
  expect_identical(tinta("grade", modo = "escuro"), site("filete"))
  expect_identical(tinta("eixo",  modo = "escuro"), site("filete"))
})

test_that("no modo escuro o site usa o mesmo filete para grade e eixo", {
  expect_identical(tinta("grade", modo = "escuro"),
                   tinta("eixo",  modo = "escuro"))
  # no claro eles seguem distintos -- o modo claro nao foi rebaseado
  expect_false(identical(tinta("grade"), tinta("eixo")))
})

test_that("a tinta fraca deixou de ser a mesma nos dois modos", {
  # Era, ate a 0.2.0: #898781 servia claro e escuro. O Boletim tem um piso
  # proprio (#7d858e, o `rotulo`), medido contra o fundo E contra a chapa, e
  # seguir com o cinza quente era ignorar essa medicao.
  expect_false(identical(tinta("fraca"), tinta("fraca", modo = "escuro")))
})

test_that("modo desconhecido e rejeitado", {
  expect_error(paleta(modo = "sepia"))
  expect_error(tinta(modo = "sepia"))
})

test_that("os dois modos tem os mesmos nomes de slot e de tinta", {
  expect_identical(names(paleta()), names(paleta(modo = "escuro")))
  expect_identical(names(tinta()),  names(tinta(modo = "escuro")))
})
