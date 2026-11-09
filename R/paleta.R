# Paleta compartilhada -------------------------------------------------------
#
# Estas cores NAO sao escolha estetica -- sao um mecanismo de seguranca.
# A separacao foi validada para daltonismo (protanopia, deuteranopia,
# tritanopia): pior par adjacente com DeltaE 17,6 em protanopia, contra um piso
# de 8. O piso de visao normal e 29,0.
#
# A ORDEM DOS SLOTS FAZ PARTE DA VALIDACAO. Usar s1 e s3 num grafico de duas
# series e seguro; trocar s2 por uma cor "parecida" nao e.
#
# Limite conhecido: o magenta (s3) fica abaixo de 3:1 de contraste sobre fundo
# branco. Por isso a regra que acompanha esta paleta em todo projeto:
# **todo grafico traz rotulo direto na ponta da serie**, alem da legenda. A
# identidade de uma serie nunca pode depender so da cor.
#
# Antes deste pacote, estas mesmas cores estavam copiadas em tres projetos sob
# tres nomes diferentes (COR$s1, PAL["slot1"], CORES["s1"]). Eram identicas byte
# a byte -- o que so se descobriu ao compara-las em 2026-07-19.
#
# MODO ESCURO (desde 0.2.0) ---------------------------------------------------
#
# O modo escuro NAO e um clareamento automatico do claro: sao passos proprios,
# validados contra a superficie escura, como manda o metodo. Medidos em
# 2026-07-19 com o validador do skill `dataviz`:
#
#   claro  (superficie #fcfcfb)  pior par adjacente DeltaE 16,3 (deutan)
#                                contraste: s3 2,62 e s4 2,11 -- ABAIXO de 3:1
#   escuro                       pior par adjacente DeltaE 13,0 (deutan)
#                                contraste: os quatro ACIMA de 3:1
#
# Ou seja: no escuro a paleta e mais segura em contraste que no claro. A regra do
# rotulo direto nasce do modo CLARO, e vale nos dois por consistencia.
#
# LIMITE DO MODO ESCURO: no conjunto de TODOS os pares (nao so os adjacentes), o
# par s2 (verde) x s4 (ambar) cai para DeltaE 6,9 em protanopia -- dentro da
# faixa 6-8, que so e legal com codificacao secundaria. Um grafico escuro que use
# **somente s2 e s4** precisa de rotulo direto ou textura. Usando os slots na
# ordem (s1, s2, s3...) o problema nao aparece.
#
# O CHAO MUDOU (0.3.0) --------------------------------------------------------
#
# A validacao acima foi feita contra #1a1a19, que era a superficie escura do
# site ate 2026-08-09. Naquele dia o site trocou de direcao visual e o chao
# passou a ser #0d1014 -- mais escuro e mais frio. Isso obrigava a remedir tudo.
#
# As DUAS metades da paleta responderam de forma diferente, e a diferenca e o
# achado:
#
#   1. As CORES DE SERIE nao mudaram, e nao precisavam mudar. A separacao entre
#      elas (DeltaE sob simulacao de daltonismo) nao depende do fundo, e o
#      contraste contra o fundo so MELHOROU, porque #0d1014 e mais escuro que
#      #1a1a19. Medido em 2026-08-13, contra #0d1014:
#
#        s1 5,24   s2 3,86   s3 4,83   s4 6,21     (piso 3:1)
#
#      e ate contra a chapa elevada (#141920), o pior caso de um grafico dentro
#      de cartao, os quatro seguem passando: 4,85 / 3,57 / 4,47 / 5,75.
#
#   2. As TINTAS NEUTRAS mudaram todas. Elas eram cinzas QUENTES (#898781,
#      #2c2c2a, #c3c2b7) herdados do sistema antigo, e o Boletim e um sistema
#      FRIO (#7d858e, #2c333c, #a9b0b8). Cinza quente sobre pagina fria nao le
#      como "neutro discreto": le como figura de outro documento. Agora as
#      tintas escuras SAO os tokens do site -- ver R/site.R.
#
# Uma consequencia que vale escrever: o `forte` do modo escuro era #ffffff, e
# deixou de ser. O site proibe branco puro sobre este fundo com uma razao
# especifica -- ele vibra. O titulo do site e #dde1e6, e o de um grafico tambem.
#
# O VERDE COMO TEXTO (0.4.0) --------------------------------------------------
#
# O s2 (#008300) mede 3,86:1 sobre #0d1014. Para MARCA (linha, ponto, barra) o
# piso e 3:1 e ele passa. Para TEXTO o piso e 4,5:1, e ele nao passa -- e virava
# texto em dois lugares, ambos no codigo dos artigos, nao neste pacote: celula
# de tabela gt pintada com a cor da serie (`cell_text(color = s2)`) e rotulo
# direto de grafico (`geom_text`, anotacao plotly). O Lighthouse acusou
# `color-contrast` em 2026-11 e segurou quatro artigos em 96 de acessibilidade.
#
# A correcao NAO troca o s2. Grafico nao e texto; trocar o slot obrigaria
# re-renderizar todo grafico do site e revalidar a paleta inteira por uma falha
# que so existe no texto. Em vez disso, `paleta(uso = "texto")` devolve uma
# variante so para texto. Medido em 2026-11-09 com o validador do skill
# `dataviz`, contra #0d1014:
#
#   s2 texto = #008f56   4,60:1 sobre noite (4,26 sobre chapa)
#                        DeltaE 7,3 do s2 em visao normal: le como o mesmo verde
#
# O caminho obvio -- so clarear o #008300, mantendo matiz e croma -- foi medido
# e DESCARTADO: #269622 (4,96:1) leva o verde para a luminosidade do ambar, e
# sob protanopia os dois viram a mesma cor (DeltaE 0,8 contra o s4). O #008f56
# sobe a luminosidade e gira o matiz para o azulado (OKLCH h 142,5 -> 157,0),
# e o pior par sob daltonismo fica em DeltaE 6,5 (deutan, contra o s3) e 6,6
# (protan, contra o s4) -- a mesma faixa 6-8 em que o s2 x s4 da paleta escura
# ja vive. Nenhum verde com 4,5:1 sobre este chao passa de 6,9 contra os tres
# outros slots; buscou-se numa grade de ~17 mil candidatos.
#
# A faixa 6-8 so e legal com codificacao secundaria. Texto TEM codificacao
# secundaria: o proprio conteudo -- o nome da serie, o sinal do numero. A cor do
# texto reforca a identidade, nunca e a identidade.
#
# Os outros tres slots ja passam 4,5:1 sobre noite (5,24 / 4,83 / 6,21) e
# saem iguais nas duas variantes.

# O SITE NAO TEM MODO CLARO ---------------------------------------------------
#
# "Don't propor tema claro ou alternador de tema: o site e escuro por definicao
# e nunca teve um modo claro."  -- DESIGN.md do site, lista de Don'ts
#
# O padrao deste pacote continua sendo `modo = "claro"`, e isso NAO e descuido.
# Trocar o padrao restilizaria, de uma vez, artigos que ja estao congelados por
# `freeze` -- e o site passaria a exibir dois estilos ao mesmo tempo, que e
# justamente o risco descrito em ?theoviz. A troca do padrao e uma decisao de
# publicacao, nao de pacote: ela se faz em cada projeto, junto com um re-render
# completo do site -- apagar `quarto/_freeze/` e rodar `npm run build:quarto`.
# (E `--no-freeze`, nao: essa opcao nao existe no Quarto 1.9.)
#
# O que o pacote faz e deixar o caminho certo curto: `modo = "escuro"` devolve
# os tokens do site, sem que ninguem precise redigitar um hexadecimal.

#' Cores de serie
#'
#' Os quatro slots categoricos da paleta, na ordem validada.
#'
#' @section Uma serie so nao usa a paleta:
#'
#' Grafico de **uma** serie usa [acento()], o areia do site. A paleta comeca a
#' valer em **duas**. Ver a regra inteira em [acento()].
#'
#' @section A ordem dos slots faz parte da validacao:
#'
#' Usar `s1` e `s3` num grafico de duas series e seguro; trocar `s2` por uma cor
#' "parecida" nao e. Ha teste travando os valores exatos -- mudar um exige mudar
#' o teste tambem, para que a troca seja deliberada e revalidada.
#'
#' Nunca cicle a paleta. Uma quinta serie vira facetas ou "outros", nao uma cor
#' nova.
#'
#' @section Contraste contra o fundo:
#'
#' No modo **escuro**, os quatro passam de 3:1 contra o chao do site
#' (`#0d1014`): 5,24 / 3,86 / 4,83 / 6,21. E tambem contra a chapa elevada
#' (`#141920`), que e o pior caso de um grafico dentro de cartao: 4,85 / 3,57 /
#' 4,47 / 5,75. Medido em 2026-08-13.
#'
#' No modo **claro** dois slots ficam abaixo do piso -- `s3` em 2,62 e `s4` em
#' 2,11 sobre `#fcfcfb`. E dessa falha que nasce a regra do rotulo direto, e por
#' isso ela vale nos dois modos: identidade de serie nunca depende so de cor.
#'
#' @section Marca nao e texto:
#'
#' Os slots acima sao cores de **marca** -- linha, ponto, barra --, e o piso de
#' marca e 3:1. Texto tem piso de **4,5:1** (WCAG AA), e o verde `s2`, com
#' 3,86:1 sobre `#0d1014`, nao chega la. Por isso, quando a cor da serie vira
#' **texto** -- celula de tabela `gt` pintada pela serie, rotulo direto na ponta
#' da linha, anotacao plotly --, peca `uso = "texto"`:
#'
#' \preformatted{
#' verde <- paleta(2, "escuro", uso = "texto")[["s2"]]
#' gt::tab_style(g, gt::cell_text(color = verde),
#'               gt::cells_body(columns = variacao))
#' }
#'
#' A variante de texto troca **so o verde**: `#008f56`, 4,60:1 sobre `noite`, a
#' DeltaE 7,3 do `s2` em visao normal -- le como o mesmo verde. Os outros tres
#' slots ja passam 4,5:1 (5,24 / 4,83 / 6,21) e saem iguais. A linha do grafico
#' segue em `s2`; so o rotulo dela muda.
#'
#' Sob daltonismo, o pior par da variante de texto fica em DeltaE 6,5 -- a faixa
#' 6-8, legal so com codificacao secundaria. Texto sempre a tem: o proprio
#' conteudo (o nome da serie, o sinal do numero). A cor reforca, nunca decide.
#'
#' A garantia e sobre `noite`, o chao em que tabelas e graficos pousam. Sobre a
#' `chapa` o verde de texto cai para 4,26 e o magenta para 4,47: texto colorido
#' dentro de cartao nao esta coberto.
#'
#' So existe no modo escuro. No claro, tres dos quatro slots ficam abaixo de
#' 4,5:1 sobre `#fcfcfb` (4,30 / 2,62 / 2,11), e o site nao tem superficie clara
#' contra a qual validar uma alternativa -- pedir `uso = "texto"` no claro e
#' erro, nao silencio.
#'
#' @param n Quantos slots devolver (1 a 4). Sem argumento, devolve os quatro.
#' @param modo `"claro"` (padrao) ou `"escuro"`. O modo escuro tem passos
#'   proprios, validados contra a superficie escura -- nao e um clareamento
#'   automatico do claro.
#' @param uso `"marca"` (padrao) para linha, ponto e barra -- piso de 3:1 -- ou
#'   `"texto"` quando a cor da serie pinta texto -- piso de 4,5:1. Ver a secao
#'   *Marca nao e texto*. `"texto"` so existe com `modo = "escuro"`.
#' @return Vetor nomeado de cores em hexadecimal.
#' @seealso [acento()] para o caso de uma serie so; [tinta()] para os neutros.
#' @examples
#' paleta()                    # os quatro, modo claro
#' paleta(2)                   # so os dois primeiros: azul e verde
#' paleta(modo = "escuro")     # os quatro passos do modo escuro
#'
#' # a cor da serie como TEXTO (celula de tabela, rotulo direto):
#' paleta(modo = "escuro", uso = "texto")
#' @export
paleta <- function(n = 4, modo = c("claro", "escuro"),
                   uso = c("marca", "texto")) {
  modo <- match.arg(modo)
  uso  <- match.arg(uso)
  if (uso == "texto" && modo == "claro") {
    stop("`uso = \"texto\"` so existe no modo escuro: no claro, s1, s3 e s4 ",
         "ficam abaixo de 4,5:1 sobre o fundo e nao ha alternativa validada. ",
         "Use `modo = \"escuro\"` -- e o modo do site.", call. = FALSE)
  }
  cores <- if (modo == "claro") c(
    s1 = "#2a78d6",  # azul
    s2 = "#008300",  # verde
    s3 = "#e87ba4",  # magenta -- exige rotulo direto (contraste < 3:1)
    s4 = "#eda100"   # ambar   -- tambem usado para destacar linha em tabela
  ) else c(
    s1 = "#3987e5",  # azul    -- clareado para o fundo escuro
    s2 = "#008300",  # verde   -- unico slot igual nos dois modos
    s3 = "#d55181",  # magenta -- escurecido: no fundo escuro o claro estourava
    s4 = "#c98500"   # ambar   -- ver limite s2 x s4 no cabecalho deste arquivo
  )
  # So o verde muda como texto. Clarear sem girar o matiz colapsava com o ambar
  # sob protanopia -- ver "O verde como texto" no cabecalho deste arquivo.
  if (uso == "texto") cores[["s2"]] <- "#008f56"
  if (!is.numeric(n) || length(n) != 1 || n < 1 || n > length(cores)) {
    stop("`n` deve ser um numero de 1 a ", length(cores), ".", call. = FALSE)
  }
  cores[seq_len(n)]
}

#' Tintas neutras
#'
#' Cinzas de texto, grade e fundo. Separados das cores de serie porque nunca
#' codificam dado -- so estrutura.
#'
#' @section O site nao tem modo claro:
#'
#' O padrao continua sendo `"claro"`, e isso e deliberado: trocar o padrao
#' restilizaria de uma vez artigos ja congelados por `freeze`, e o site passaria
#' a exibir dois estilos ao mesmo tempo. **Mas o site e escuro por definicao** --
#' um grafico que vai ao ar quer `modo = "escuro"`.
#'
#' A troca e uma decisao de publicacao, tomada em cada projeto junto com um
#' re-render completo do site (apagar `quarto/_freeze/` e rodar
#' `npm run build:quarto`). O modo claro segue util fora do site: impressao,
#' slide, PDF.
#'
#' @section De onde vem cada modo:
#'
#' No **modo escuro**, desde a 0.3.0, as tintas *sao* os tokens do site -- ver
#' [site()]. Antes eram cinzas quentes herdados do sistema visual anterior, e o
#' Boletim e um sistema frio; cinza quente sobre pagina fria nao le como neutro
#' discreto, le como figura recortada de outro documento.
#'
#' \tabular{llll}{
#'   **tinta** \tab **0.2.0** \tab **0.3.0** \tab **token do site** \cr
#'   `forte`   \tab `#ffffff` \tab `#dde1e6` \tab `titulo`   \cr
#'   `media`   \tab `#c3c2b7` \tab `#a9b0b8` \tab `leitura`  \cr
#'   `fraca`   \tab `#898781` \tab `#7d858e` \tab `rotulo`   \cr
#'   `grade`   \tab `#2c2c2a` \tab `#2c333c` \tab `filete`   \cr
#'   `eixo`    \tab `#383835` \tab `#2c333c` \tab `filete`   \cr
#'   `fundo`   \tab `#1a1a19` \tab `#0d1014` \tab `noite`
#' }
#'
#' Duas notas sobre a tabela. O `forte` deixou de ser branco puro porque o site
#' o proibe sobre este fundo, com razao especifica: ele vibra. E `grade` e `eixo`
#' passaram a ser **o mesmo valor**, porque o site usa um filete so para as duas
#' coisas -- os dois nomes seguem existindo para nao quebrar quem ja os chama.
#'
#' O **modo claro nao foi rebaseado**, e nao havia como: o site nao tem
#' superficie clara contra a qual validar. Ele guarda a referencia `#fcfcfb`.
#'
#' @param qual Nome de uma tinta. Sem argumento, devolve todas.
#' @param modo `"claro"` (padrao) ou `"escuro"`.
#' @return Vetor nomeado de cores em hexadecimal.
#' @seealso [site()] para o conjunto completo de tokens do site.
#' @examples
#' tinta()
#' tinta("grade")
#' tinta("fundo", modo = "escuro")   # o chao do site
#' @export
tinta <- function(qual = NULL, modo = c("claro", "escuro")) {
  modo <- match.arg(modo)
  tintas <- if (modo == "claro") c(
    forte  = "#0b0b0b",  # titulo
    media  = "#52514e",  # corpo de texto
    fraca  = "#898781",  # eixo, legenda, fonte
    grade  = "#e1e0d9",  # linhas de grade
    eixo   = "#c3c2b7",  # linha do eixo
    fundo  = "#fcfcfb"   # superficie do grafico
  ) else c(
    # Desde 0.3.0 estes valores SAO os tokens do site (ver R/site.R). Nao os
    # edite aqui: o teste em test-site.R confere um contra o outro.
    forte  = site("titulo"),   # #dde1e6 -- nao #ffffff: branco puro vibra
    media  = site("leitura"),  # #a9b0b8
    fraca  = site("rotulo"),   # #7d858e -- o piso do sistema
    grade  = site("filete"),   # #2c333c
    eixo   = site("filete"),   # o site usa o mesmo filete para grade e eixo
    fundo  = site("noite")     # #0d1014 -- o chao da pagina
  )
  if (is.null(qual)) return(tintas)
  if (!qual %in% names(tintas)) {
    stop("tinta desconhecida: '", qual, "'. Use uma de: ",
         paste(names(tintas), collapse = ", "), ".", call. = FALSE)
  }
  tintas[[qual]]
}

#' Grade em rgba, para quando o fundo da pagina e desconhecido
#'
#' O plotly precisa de fundo transparente para o widget herdar a cor da pagina
#' em vez de cravar um branco dentro do tema escuro do site. A grade entao
#' precisa de alfa, que hexadecimal de 6 digitos nao carrega.
#'
#' @section Prefira a grade solida quando souber onde o grafico pousa:
#'
#' Este cinza -- `rgb(138,138,133)`, quente -- e um **acordo**: um valor que
#' sobrevive tanto sobre fundo claro quanto sobre escuro, porque em 2026-07 nao
#' se sabia em qual dos dois o grafico ia cair.
#'
#' Hoje se sabe: o site e escuro por definicao. Um grafico que vai ao ar deve
#' usar a grade solida do sistema, `tinta("grade", modo = "escuro")`
#' (= `site("filete")`), que e fria como o resto da pagina. Esta funcao fica
#' para o caso em que o fundo e mesmo desconhecido -- um widget embutido fora do
#' site, por exemplo.
#'
#' @param alfa Opacidade, de 0 a 1.
#' @return String no formato "rgba(r,g,b,a)".
#' @seealso [tinta()], [site()].
#' @examples
#' grade_rgba()
#' @export
grade_rgba <- function(alfa = 0.22) {
  if (!is.numeric(alfa) || length(alfa) != 1 || alfa < 0 || alfa > 1) {
    stop("`alfa` deve ser um numero entre 0 e 1.", call. = FALSE)
  }
  sprintf("rgba(138,138,133,%s)", format(alfa, trim = TRUE))
}
