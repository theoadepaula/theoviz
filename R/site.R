# Tokens do sistema visual do site -------------------------------------------
#
# O site trocou de direcao visual em 2026-08-09: saiu "A Sala de Leitura
# Noturna" (fundo #0f172a, acento azul #0085ff, Inter, raio 0,5rem, sombra no
# hover) e entrou "O Boletim Tecnico" -- fundo quase preto, acento areia unico,
# duas vozes tipograficas, raio zero e sombra zero.
#
# Este arquivo e o espelho, do lado do R, do bloco `@theme` de
# `src/styles/global.css` no repo do site. Os valores foram copiados de la em
# 2026-08-13, com a documentacao em `DESIGN.md` como referencia.
#
# SIM, ISTO E UMA COPIA -- e copia e exatamente o que este pacote existe para
# eliminar. A diferenca importa: agora ha UMA, datada, com a fonte escrita e um
# teste que a confere contra o CSS do site quando o repo esta por perto (ver
# tests/testthat/test-site.R). Antes havia tres, e cada projeto inventava o seu
# proprio cinza -- o `relatorios-slu` chegou a cravar um `TINTA_2 <- "#8a8a85"`
# com o comentario "nao e o tinta('fraca') do theoviz". Era esse o sintoma.
#
# O QUE NAO ENTRA AQUI: tipografia, espacamento e as regras de forma (raio zero,
# sombra zero, filete que so aparece onde significa dado). Isso e do CSS do site
# e nao tem uso do lado do R. O que este pacote consome sao as cores -- porque
# grafico e tabela precisam delas para pousar na pagina sem parecer recorte de
# outro documento.

#' Tokens de cor do sistema visual do site
#'
#' As cores da direcao **"Boletim Tecnico"**, adotada pelo site em 2026-08-09.
#' Sao o espelho do bloco `@theme` de `src/styles/global.css`, para que um
#' grafico ou painel feito em R pouse na pagina sem que ninguem tenha de
#' redigitar um hexadecimal.
#'
#' O site e **escuro por definicao** e nao tem modo claro -- por isso esta
#' funcao nao tem argumento `modo`. Ver a secao "O site nao tem modo claro" em
#' [tinta()].
#'
#' @section Os tokens:
#'
#' **Superficies**
#' \describe{
#'   \item{`noite`}{`#0d1014` -- o chao de tudo. Fundo da pagina.}
#'   \item{`chapa`}{`#141920` -- a unica superficie acima do chao (cartao,
#'     campo). A 1,08:1 do fundo: e pouco de proposito, e e pouco mesmo.}
#'   \item{`divisa`}{`#1e242c` -- divisoria de 1px.}
#'   \item{`filete`}{`#2c333c` -- o traco que pertence a uma figura: base de
#'     eixo e grade de grafico.}
#'   \item{`controle`}{`#616a75` -- contorno de componente interativo. 3,47:1
#'     sobre o fundo, que e o piso da WCAG 1.4.11. **Nao e cor de divisoria.**}
#' }
#'
#' **Texto** (contraste medido sobre `noite`)
#' \describe{
#'   \item{`titulo`}{`#dde1e6` -- 14,52:1. Titulo e numero em destaque. Nao e
#'     branco puro: o branco puro sobre este fundo vibra.}
#'   \item{`leitura`}{`#a9b0b8` -- 8,71:1. Todo o texto corrido.}
#'   \item{`apoio`}{`#828a93` -- 5,45:1. Legenda de figura, descricao.}
#'   \item{`rotulo`}{`#7d858e` -- 5,10:1. **O piso do sistema**: rotulo mono,
#'     data, rotulo de eixo. Sobre `chapa` cai para 4,72:1, e a folga ate o
#'     limite de 4,5 e de 0,22 -- nao mexa em nenhum dos dois sem remedir.}
#' }
#'
#' **Acento e retorno**
#' \describe{
#'   \item{`areia`, `areia_clara`, `areia_pressionada`}{ver [acento()].}
#'   \item{`ok`}{`#7fb08a` -- 7,70:1. Confirmacao.}
#'   \item{`err`}{`#d08a7a` -- 6,90:1. Falha.}
#' }
#'
#' `ok` e `err` sao dessaturados de proposito: num sistema de acento unico, um
#' verde ou vermelho vivo leria imediatamente como segunda cor de marca. **Nunca
#' aparecem sozinhos** -- cor nao e sinal acessivel, entao todo retorno vem
#' acompanhado de texto.
#'
#' @param qual Nome de um token. Sem argumento, devolve todos.
#' @return Vetor nomeado de cores em hexadecimal; ou uma string, se `qual` for
#'   dado.
#' @seealso [acento()] para o acento unico, [tinta()] para as tintas de
#'   grafico e [paleta()] para as cores de serie.
#' @examples
#' site("noite")
#' site("filete")   # a grade de um grafico
#' names(site())
#' @export
site <- function(qual = NULL) {
  tokens <- c(
    # superficies
    noite             = "#0d1014",
    chapa             = "#141920",
    divisa            = "#1e242c",
    filete            = "#2c333c",
    controle          = "#616a75",
    # texto
    titulo            = "#dde1e6",
    leitura           = "#a9b0b8",
    apoio             = "#828a93",
    rotulo            = "#7d858e",
    # acento
    areia             = "#cfae72",
    areia_clara       = "#e3c88d",
    areia_pressionada = "#bd9a5b",
    # retorno de acao
    ok                = "#7fb08a",
    err               = "#d08a7a"
  )
  if (is.null(qual)) return(tokens)
  if (!qual %in% names(tokens)) {
    stop("token desconhecido: '", qual, "'. Use um de: ",
         paste(names(tokens), collapse = ", "), ".", call. = FALSE)
  }
  tokens[[qual]]
}

#' Acento unico do site
#'
#' O areia (`#cfae72`), unico acento do sistema visual do site.
#'
#' @section Quando usar o acento, e quando usar a paleta:
#'
#' A regra decide pelo **numero de series**, e nao pelo gosto:
#'
#' \describe{
#'   \item{**Uma serie**}{use o acento. E o que a figura da home faz, e e o que
#'     faz o grafico ler como peca do site em vez de saida de biblioteca.}
#'   \item{**Duas ou mais**}{use [paleta()], na ordem dos slots. O acento nao
#'     entra na paleta categorica: ele nao foi validado para daltonismo contra
#'     os quatro slots, e o sistema do site reserva o areia para "acao, estado
#'     ativo ou marcador estrutural".}
#' }
#'
#' Nao ha meio-termo: um grafico de tres series com uma delas em areia mistura
#' dois vocabularios e quebra os dois.
#'
#' @section A propriedade que este valor tem, e que um acento novo nao herda:
#'
#' O areia passa **nos dois sentidos** -- 9,03:1 como texto sobre `noite` e os
#' mesmos 9,03:1 como fundo com rotulo em `noite` por cima, porque contraste e
#' simetrico. E por isso que o site nao tem um "areia de botao" a parte.
#'
#' Isso e propriedade **deste valor**, nao licenca geral. Um acento que passa
#' como texto nao passa automaticamente como superficie -- foi exatamente esse
#' erro que custou uma correcao ao site em 2026-08-04.
#'
#' @param estado `"base"` (padrao), `"hover"` ou `"pressionado"`. O `hover` e o
#'   de **texto**, que acende; o `pressionado` e o de **superficie**, que
#'   afunda. A assimetria e deliberada: fundo que clareia no hover empurra o
#'   rotulo para perto do piso de contraste.
#' @return Uma cor em hexadecimal.
#' @seealso [site()], [paleta()].
#' @examples
#' acento()
#' acento("pressionado")
#' @export
acento <- function(estado = c("base", "hover", "pressionado")) {
  estado <- match.arg(estado)
  switch(estado,
    base        = site("areia"),
    hover       = site("areia_clara"),
    pressionado = site("areia_pressionada")
  )
}
