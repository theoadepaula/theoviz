# Os tokens do site ----------------------------------------------------------
#
# Mesma logica dos testes da paleta: os valores ficam travados para que troca-los
# exija tocar no teste. Aqui ha um motivo a mais -- estes valores sao COPIA do
# `@theme` de `src/styles/global.css`, no repo do site, e copia envelhece calada.
# O ultimo teste deste arquivo confere a copia contra a fonte quando o repo do
# site esta na maquina.

test_that("os tokens do site sao os do sistema Boletim", {
  expect_identical(
    site(),
    c(noite = "#0d1014", chapa = "#141920", divisa = "#1e242c",
      filete = "#2c333c", controle = "#616a75",
      titulo = "#dde1e6", leitura = "#a9b0b8", apoio = "#828a93",
      rotulo = "#7d858e",
      areia = "#cfae72", areia_clara = "#e3c88d",
      areia_pressionada = "#bd9a5b",
      ok = "#7fb08a", err = "#d08a7a")
  )
  expect_identical(site("noite"), "#0d1014")
})

test_that("site rejeita token desconhecido", {
  expect_error(site("azul"), "token desconhecido")
})

test_that("acento devolve os tres estados do areia", {
  expect_identical(acento(),              "#cfae72")
  expect_identical(acento("hover"),       "#e3c88d")
  expect_identical(acento("pressionado"), "#bd9a5b")
  expect_error(acento("sumido"))
})

test_that("o acento nao entra na paleta categorica", {
  # Se um dia o areia virar slot de serie, esta linha quebra -- e deve, porque
  # ele nao foi validado para daltonismo contra os quatro slots.
  expect_false(acento() %in% paleta(modo = "escuro"))
  expect_false(acento() %in% paleta(modo = "claro"))
})

# --- contraste, recalculado --------------------------------------------------

test_that("o acento passa nos dois sentidos sobre o fundo do site", {
  # A propriedade que separa este acento do azul anterior: contraste e simetrico,
  # entao o mesmo par serve texto E superficie. E por isso que o site nao tem um
  # "areia de botao" a parte.
  expect_equal(contraste_r(acento(), site("noite")), 9.03)
  expect_gte(contraste(acento(), site("noite")), 4.5)
})

test_that("os quatro degraus de texto passam sobre o fundo e sobre a chapa", {
  texto <- c("titulo", "leitura", "apoio", "rotulo")
  for (t in texto) {
    expect_gte(contraste(site(t), site("noite")), 4.5)
    # o pior caso: texto dentro de cartao ou campo enxerga a chapa, nao o chao
    expect_gte(contraste(site(t), site("chapa")), 4.5)
  }
})

test_that("o rotulo e mesmo o piso do sistema, e a folga e a documentada", {
  # 4,72 sobre a chapa, contra um limite de 4,5: folga de 0,22. Escurecer a chapa
  # ou clarear o rotulo um degrau derruba o par -- por isso o teste existe.
  expect_equal(contraste_r(site("rotulo"), site("chapa")), 4.72)
  piso <- vapply(c("titulo", "leitura", "apoio", "rotulo"),
                 function(t) contraste(site(t), site("chapa")), numeric(1))
  expect_identical(names(which.min(piso)), "rotulo")
})

test_that("o contorno de controle alcanca os 3:1 que uma divisoria nao alcanca", {
  # WCAG 1.4.11: limite de componente interativo precisa de 3:1. Este foi o
  # defeito que chegou no pacote de redesenho do site em 2026-08-09 -- o contorno
  # veio valendo o mesmo que o filete de dado, 1,49:1, e a borda do botao
  # secundario ficou praticamente invisivel.
  expect_gte(contraste(site("controle"), site("noite")), 3)
  expect_gte(contraste(site("controle"), site("chapa")), 3)
  expect_lt(contraste(site("filete"), site("noite")), 3)  # filete NAO delimita
})

test_that("as cores de serie do modo escuro passam sobre o chao do site", {
  # O chao mudou de #1a1a19 para #0d1014 em 2026-08-09. Este teste e o que
  # sustenta a afirmacao de que a paleta sobreviveu a troca sem mudar.
  for (cor in paleta(modo = "escuro")) {
    expect_gte(contraste(cor, site("noite")), 3)
    expect_gte(contraste(cor, site("chapa")), 3)   # grafico dentro de cartao
  }
})

test_that("o titulo do modo escuro nao e branco puro", {
  # O site proibe branco puro sobre este fundo com razao especifica: ele vibra.
  expect_false(tolower(tinta("forte", modo = "escuro")) %in% c("#ffffff", "#fff"))
})

# --- a copia confere com a fonte? -------------------------------------------

test_that("os tokens batem com o CSS do site, quando o repo esta por perto", {
  # No Windows `~` resolve para Documentos, nao para a pasta do usuario -- e com
  # OneDrive resolve para dentro do OneDrive. Um caminho so nao acha o repo, e o
  # teste passaria pulado, que e o pior desfecho possivel para um teste de
  # deriva: ele so serve se rodar.
  rel <- file.path("src", "styles", "global.css")
  candidatos <- c(
    Sys.getenv("THEOVIZ_SITE_CSS"),
    file.path(Sys.getenv("THEOVIZ_SITE_REPO"), rel),
    file.path("~/dev/theoalbuquerque-site", rel),
    file.path(Sys.getenv("USERPROFILE"), "dev", "theoalbuquerque-site", rel),
    file.path(Sys.getenv("HOME"), "dev", "theoalbuquerque-site", rel)
  )
  candidatos <- path.expand(candidatos[nzchar(candidatos)])
  css <- candidatos[file.exists(candidatos)][1]
  skip_if(is.na(css), "repo do site nao esta nesta maquina")

  texto <- paste(readLines(css, warn = FALSE, encoding = "UTF-8"), collapse = "\n")

  # nome do token no pacote -> nome da variavel CSS no bloco @theme
  de_para <- c(
    noite = "night", chapa = "panel", divisa = "line", filete = "rule",
    controle = "control",
    titulo = "fg", leitura = "soft", apoio = "mid", rotulo = "muted",
    areia = "brand-600", areia_clara = "brand-500",
    areia_pressionada = "brand-700",
    ok = "ok", err = "err"
  )

  for (nome in names(de_para)) {
    padrao <- paste0("--color-", de_para[[nome]], ":\\s*(#[0-9a-fA-F]{6})")
    achado <- regmatches(texto, regexpr(padrao, texto))
    expect_length(achado, 1L)
    valor <- tolower(sub(paste0(".*(#[0-9a-fA-F]{6}).*"), "\\1", achado))
    expect_identical(
      valor, site(nome),
      info = paste0("token '", nome, "' divergiu do CSS do site")
    )
  }
})
