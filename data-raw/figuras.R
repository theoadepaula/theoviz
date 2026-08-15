# Gera as figuras do README --------------------------------------------------
#
#   Rscript data-raw/figuras.R
#
# Por que HTML + Chrome, e nao ggplot + ragg:
#
#   1. As figuras ilustram decisoes do sistema visual do SITE, e duas delas sao
#      tipograficas -- a Regra das Duas Vozes (sans para prosa, mono para
#      medida) e o rotulo mono do eixo. Uma imagem dessas feita com a fonte
#      generica do sistema ilustraria a decisao errada.
#   2. Uma das figuras e a propria tabela `gt`, que so existe como HTML.
#
# As fontes IBM Plex nao estao instaladas nesta maquina; sao lidas dos arquivos
# .woff2 que o repo do site ja tem em node_modules e embutidas como data: URI.
# Sem elas, o Chrome cai no fallback e a figura sai com a tipografia errada --
# por isso o script AVISA em vez de seguir calado.
#
# Saida: man/figures/*.png (versionados, porque README nao roda script).

suppressPackageStartupMessages({
  library(theoviz)
})

# Rode a partir da raiz do pacote; se rodar de data-raw/, sobe um nivel.
raiz <- normalizePath(if (dir.exists("R") && file.exists("DESCRIPTION")) "." else "..",
                      mustWork = TRUE)
if (!file.exists(file.path(raiz, "DESCRIPTION"))) {
  stop("rode este script da raiz do pacote theoviz", call. = FALSE)
}
destino <- file.path(raiz, "man", "figures")
dir.create(destino, recursive = TRUE, showWarnings = FALSE)

# No Windows `~` costuma resolver para Documentos (e, com OneDrive, para dentro
# do OneDrive), nao para a pasta do usuario -- por isso a busca tenta candidatos
# em vez de confiar num caminho so.
candidatos <- c(
  Sys.getenv("THEOVIZ_SITE_REPO"),
  "~/dev/theoalbuquerque-site",
  file.path(Sys.getenv("USERPROFILE"), "dev", "theoalbuquerque-site"),
  file.path(Sys.getenv("HOME"), "dev", "theoalbuquerque-site")
)
candidatos <- path.expand(candidatos[nzchar(candidatos)])
site_repo <- c(candidatos[dir.exists(candidatos)], candidatos[1])[1]
fontes_em <- file.path(site_repo, "node_modules", "@fontsource")

# --- fontes -----------------------------------------------------------------

fonte_embutida <- function(familia, arquivo, peso) {
  caminho <- file.path(fontes_em, familia, "files", arquivo)
  if (!file.exists(caminho)) return(NA_character_)
  bruto <- readBin(caminho, "raw", file.size(caminho))
  sprintf(
    "@font-face{font-family:'%s';font-style:normal;font-weight:%s;src:url(data:font/woff2;base64,%s) format('woff2');}",
    if (familia == "ibm-plex-sans") "IBM Plex Sans" else "IBM Plex Mono",
    peso, jsonlite::base64_enc(bruto)
  )
}

css_fontes <- c(
  fonte_embutida("ibm-plex-sans", "ibm-plex-sans-latin-400-normal.woff2", 400),
  fonte_embutida("ibm-plex-sans", "ibm-plex-sans-latin-600-normal.woff2", 600),
  fonte_embutida("ibm-plex-mono", "ibm-plex-mono-latin-400-normal.woff2", 400)
)
if (anyNA(css_fontes)) {
  warning("IBM Plex nao encontrado em ", fontes_em,
          ".\n  As figuras vao sair com a fonte de fallback, o que contradiz a ",
          "propria decisao\n  que elas ilustram. Defina THEOVIZ_SITE_REPO.",
          call. = FALSE, immediate. = TRUE)
  css_fontes <- css_fontes[!is.na(css_fontes)]
}

# --- contraste, para a figura poder afirmar o numero -------------------------

luminancia <- function(hex) {
  v <- grDevices::col2rgb(hex)[, 1] / 255
  v <- ifelse(v <= 0.03928, v / 12.92, ((v + 0.055) / 1.055)^2.4)
  sum(c(0.2126, 0.7152, 0.0722) * v)
}
contraste <- function(a, b) {
  l <- sort(c(luminancia(a), luminancia(b)), decreasing = TRUE)
  round((l[1] + 0.05) / (l[2] + 0.05), 2)
}
br <- function(x) formatC(x, format = "f", digits = 2, decimal.mark = ",")

# --- helpers de HTML --------------------------------------------------------

`%||%` <- function(a, b) if (is.null(a)) b else a

CHAO   <- site("noite")
CHAPA  <- site("chapa")
FILETE <- site("filete")
ROTULO <- site("rotulo")
LEITURA <- site("leitura")
TITULO <- site("titulo")

base_css <- sprintf('
%s
*{margin:0;padding:0;box-sizing:border-box}
body{background:%s;color:%s;font-family:"IBM Plex Sans",system-ui,sans-serif;
     -webkit-font-smoothing:antialiased}
/* O recorte por seletor mira a *content box* do elemento: se o padding
   estivesse no .painel, ele seria descartado e a figura sairia com o conteudo
   colado na borda. Por isso o padding mora no .painel e o recorte mira o
   .quadro, cuja content box e o painel inteiro. */
.quadro{display:inline-block;background:%s}
.painel{background:%s;padding:30px 34px;width:900px}
.rotulo{font-family:"IBM Plex Mono",monospace;font-size:10.5px;
        text-transform:uppercase;letter-spacing:.14em;color:%s}
.trave{border-bottom:1px solid %s;padding-bottom:.75rem;margin-bottom:1.25rem}
.tit{font-size:17px;font-weight:600;color:%s;margin-top:.35rem}
.leg{font-size:13px;color:%s;line-height:1.5;margin-top:.9rem;max-width:62ch}
.mono{font-family:"IBM Plex Mono",monospace;font-variant-numeric:tabular-nums}
', paste(css_fontes, collapse = "\n"), CHAO, LEITURA, CHAO, CHAO, ROTULO,
   site("divisa"), TITULO, site("apoio"))

pagina <- function(corpo, extra = "") {
  paste0('<!doctype html><html lang="pt-BR"><head><meta charset="utf-8">',
         '<style>', base_css, extra, '</style></head><body>',
         '<div class="quadro">', corpo, '</div></body></html>')
}

cabeca <- function(rotulo, titulo) {
  sprintf('<div class="trave"><div class="rotulo">%s</div><div class="tit">%s</div></div>',
          rotulo, titulo)
}

captura <- function(html, arquivo, seletor = ".quadro") {
  tmp <- tempfile(fileext = ".html")
  con <- file(tmp, open = "wb")
  writeBin(charToRaw(enc2utf8(html)), con)
  close(con)
  saida <- file.path(destino, arquivo)
  webshot2::webshot(paste0("file:///", normalizePath(tmp, "/")),
                    file = saida, selector = seletor,
                    zoom = 2, delay = 0.6, quiet = TRUE)
  message("  escrito: man/figures/", arquivo)
  invisible(saida)
}

# =============================================================================
# 1. A paleta sobre o chao do site, e como ela sobrevive ao daltonismo
# =============================================================================

# Matrizes classicas de simulacao (Brettel/Vienot), aplicadas como feColorMatrix.
# Sao ILUSTRATIVAS: a validacao que vale e a de DeltaE em espaco perceptual,
# registrada em R/paleta.R com data e ferramenta.
cvd <- list(
  protanopia   = "0.567 0.433 0 0 0  0.558 0.442 0 0 0  0 0.242 0.758 0 0  0 0 0 1 0",
  deuteranopia = "0.625 0.375 0 0 0  0.700 0.300 0 0 0  0 0.300 0.700 0 0  0 0 0 1 0",
  tritanopia   = "0.950 0.050 0 0 0  0 0.433 0.567 0 0  0 0.475 0.525 0 0  0 0 0 1 0"
)

filtros <- paste0(
  '<svg width="0" height="0" style="position:absolute">',
  paste0(sprintf('<filter id="%s"><feColorMatrix type="matrix" values="%s"/></filter>',
                 names(cvd), unlist(cvd)), collapse = ""),
  '</svg>'
)

p  <- paleta(modo = "escuro")
papeis <- c(s1 = "1&ordf; s&eacute;rie", s2 = "2&ordf; s&eacute;rie",
            s3 = "3&ordf; s&eacute;rie", s4 = "4&ordf; s&eacute;rie")

amostra <- function(cor, nome, papel, filtro = NULL) {
  sprintf(
    '<div style="flex:1">
       <div style="height:56px;background:%s;%s"></div>
       <div class="rotulo" style="margin-top:.5rem">%s</div>
       <div class="mono" style="font-size:12.5px;color:%s;margin-top:.15rem">%s</div>
       <div class="mono" style="font-size:12.5px;color:%s">%s:1</div>
     </div>',
    cor, if (is.null(filtro)) "" else sprintf("filter:url(#%s)", filtro),
    papel, TITULO, cor, ROTULO, br(contraste(cor, CHAO)))
}

linha_cvd <- function(rotulo, filtro) {
  sprintf(
    '<div style="display:flex;align-items:center;gap:16px;margin-top:14px">
       <div class="rotulo" style="width:110px;flex:none">%s</div>
       <div style="display:flex;gap:10px;flex:1">%s</div>
     </div>',
    rotulo,
    paste0(sprintf('<div style="flex:1;height:26px;background:%s;%s"></div>',
                   p, if (is.null(filtro)) "" else sprintf("filter:url(#%s)", filtro)),
           collapse = ""))
}

html1 <- pagina(paste0(
  filtros,
  '<div class="painel">',
  cabeca("Paleta &middot; modo escuro", "Quatro slots, numa ordem que faz parte da valida&ccedil;&atilde;o"),
  '<div style="display:flex;gap:10px">',
  paste0(mapply(amostra, p, names(p), papeis[names(p)]), collapse = ""),
  '</div>',

  sprintf('<div style="margin-top:26px;padding-top:20px;border-top:1px solid %s">', site("divisa")),
  '<div class="rotulo">A mesma faixa, simulada</div>',
  linha_cvd("vis&atilde;o normal", NULL),
  linha_cvd("protanopia",   "protanopia"),
  linha_cvd("deuteranopia", "deuteranopia"),
  linha_cvd("tritanopia",   "tritanopia"),
  '</div>',

  sprintf('<div class="leg">Os quatro passam de 3:1 contra o ch&atilde;o do site (<span class="mono">%s</span>).
     A separa&ccedil;&atilde;o entre eles n&atilde;o depende do fundo, e por isso a troca do sistema visual do site,
     em 2026-08-09, n&atilde;o mexeu em nenhum destes valores &mdash; s&oacute; nas tintas neutras.
     <br><br>Sob protanopia e deuteranopia o matiz colapsa e o que separa os slots &eacute; sobretudo a
     <b>luminosidade</b>: por isso a ordem acima faz parte da valida&ccedil;&atilde;o &mdash; um gr&aacute;fico de duas
     s&eacute;ries usa <span class="mono">s1</span> e <span class="mono">s2</span>, o par mais afastado. A simula&ccedil;&atilde;o
     &eacute; ilustrativa; o que vale &eacute; o &Delta;E medido em espa&ccedil;o perceptual, registrado com data em
     <span class="mono">R/paleta.R</span>. E cor nunca vem sozinha: ver a figura seguinte.</div>', CHAO),
  '</div>'
))

# =============================================================================
# 2. Um grafico: acento para uma serie, paleta para duas ou mais
# =============================================================================

grafico_svg <- function(series, cores, largura = 400, altura = 150) {
  n <- length(series[[1]])
  vmax <- max(unlist(series)) * 1.08
  x <- function(i) round(28 + (i - 1) / (n - 1) * (largura - 78), 1)
  y <- function(v) round(altura - 22 - v / vmax * (altura - 40), 1)

  grade <- paste0(sprintf(
    '<line x1="28" y1="%s" x2="%s" y2="%s" stroke="%s" stroke-width="1"/>',
    round(seq(y(vmax * .92), y(0), length.out = 4), 1), largura - 42,
    round(seq(y(vmax * .92), y(0), length.out = 4), 1), FILETE), collapse = "")

  linhas <- paste0(vapply(seq_along(series), function(k) {
    pts <- paste(vapply(seq_len(n), function(i)
      sprintf("%s,%s", x(i), y(series[[k]][i])), character(1)), collapse = " ")
    ponta <- sprintf(
      '<circle cx="%s" cy="%s" r="3.5" fill="%s"/>
       <text x="%s" y="%s" fill="%s" font-family="IBM Plex Mono, monospace"
             font-size="10.5" dominant-baseline="middle">%s</text>',
      x(n), y(series[[k]][n]), cores[k],
      x(n) + 8, y(series[[k]][n]), cores[k], names(series)[k])
    sprintf('<polyline points="%s" fill="none" stroke="%s" stroke-width="1.75"
             stroke-linejoin="round" stroke-linecap="round"/>%s',
            pts, cores[k], ponta)
  }, character(1)), collapse = "")

  anos <- paste0(vapply(seq_len(n), function(i) sprintf(
    '<text x="%s" y="%s" fill="%s" font-family="IBM Plex Mono, monospace"
           font-size="10.5" text-anchor="middle">%s</text>',
    x(i), altura - 6, ROTULO, 2019 + i), character(1)), collapse = "")

  sprintf('<svg viewBox="0 0 %s %s" width="%s" height="%s">%s%s%s
            <line x1="28" y1="%s" x2="%s" y2="%s" stroke="%s" stroke-width="1"/></svg>',
          largura, altura, largura, altura, grade, linhas, anos,
          y(0), largura - 42, y(0), FILETE)
}

uma  <- list(total = c(31, 34, 39, 45, 49, 54))
tres <- list(coleta  = c(31, 34, 39, 45, 49, 54),
             triagem = c(22, 24, 23, 27, 30, 33),
             rejeito = c(14, 13, 16, 15, 18, 19))

p3 <- unname(paleta(3, modo = "escuro"))
chips <- paste0(sprintf('<span style="color:%s">s%s</span>', p3, 1:3),
                collapse = " ")

html2 <- pagina(paste0(
  '<div class="painel">',
  cabeca("Gr&aacute;fico", "O n&uacute;mero de s&eacute;ries decide a cor &mdash; n&atilde;o o gosto"),
  '<div style="display:flex;gap:30px">',
  sprintf('<div><div class="rotulo">Uma s&eacute;rie &middot; acento</div>
            <div class="mono" style="font-size:12.5px;color:%s;margin:.2rem 0 .6rem">%s</div>%s</div>',
          site("areia"), site("areia"), grafico_svg(uma, site("areia"))),
  sprintf('<div><div class="rotulo">Tr&ecirc;s s&eacute;ries &middot; paleta</div>
            <div class="mono" style="font-size:12.5px;margin:.2rem 0 .6rem">%s</div>%s</div>',
          chips, grafico_svg(tres, p3)),
  '</div>',
  '<div class="leg">Uma s&eacute;rie usa o <b>acento</b> do site; duas ou mais usam a <b>paleta</b>, na ordem dos slots.
    N&atilde;o h&aacute; meio-termo: um gr&aacute;fico de tr&ecirc;s s&eacute;ries com uma delas em areia mistura dois vocabul&aacute;rios.
    Em todos os casos, o r&oacute;tulo vai <b>direto na ponta</b> da s&eacute;rie &mdash; a identidade de uma s&eacute;rie nunca
    depende s&oacute; de cor. Grade e base de eixo no filete frio do site; todo n&uacute;mero em mono.</div>',
  '</div>'
))

# =============================================================================
# 3. A tabela: o que ia ao ar, e o que vai agora
# =============================================================================

d <- data.frame(
  ano       = 2021:2025,
  `coletado (t)` = c(21548.4, 27310.9, 38122.6, 47905.0, 54549.0),
  `varia,cao`    = c(0.176, 0.267, 0.396, 0.256, 0.139),
  check.names = FALSE
)
names(d)[3] <- "variação"

tab <- function(modo) {
  as.character(gt::as_raw_html(
    fmt_pct_br(
      fmt_br(
        tabela_gt(d, titulo = "Coleta seletiva",
                  nota = "Fonte: *relatórios anuais*. Dados ilustrativos.",
                  modo = modo),
        `coletado (t)`, decimais = 1),
      `variação`)
  ))
}

html3 <- pagina(paste0(
  '<div class="painel">',
  cabeca("Tabela gt", "O <span style=\"font-family:\'IBM Plex Mono\',monospace\">gt</span> n&atilde;o herda a p&aacute;gina: ou voc&ecirc; diz a cor, ou ele diz"),
  '<div style="display:flex;gap:30px;align-items:flex-start">',
  sprintf('<div style="flex:1"><div class="rotulo" style="color:%s">at&eacute; a 0.2.0 &middot; modo claro</div>
            <div style="margin-top:.7rem">%s</div></div>', site("err"), tab("claro")),
  sprintf('<div style="flex:1"><div class="rotulo" style="color:%s">0.3.0 &middot; modo escuro</div>
            <div style="margin-top:.7rem">%s</div></div>', site("ok"), tab("escuro")),
  '</div>',
  '<div class="leg">Sem instru&ccedil;&atilde;o de cor, o <span class="mono">gt</span> escreve
    <span class="mono">background-color: #FFFFFF</span> <i>inline</i> &mdash; e nenhuma folha de estilo do site
    derruba isso. Era assim que toda tabela de todo artigo ia ao ar. No modo escuro a tabela &eacute;
    <b>transparente</b>: pousa na p&aacute;gina em vez de recortar uma chapa dentro dela, que &eacute; a mesma
    escolha j&aacute; feita nos gr&aacute;ficos. E a coluna num&eacute;rica sai em <b>mono</b>: sans &eacute; discurso, mono &eacute; medida.</div>',
  '</div>'
))

# --- gera -------------------------------------------------------------------

message("gerando figuras em man/figures/ ...")
captura(html1, "paleta.png")
captura(html2, "grafico.png")
captura(html3, "tabela.png")
message("pronto.")
