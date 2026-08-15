#' @keywords internal
#'
#' @section O que este pacote decide, e o que nao decide:
#'
#' `theoviz` guarda a identidade visual **compartilhada** dos projetos de dados
#' abertos publicados em <https://theoalbuquerque.com.br>: os tokens do sistema
#' visual do site, a paleta, o tema das tabelas [gt::gt()] e a formatacao
#' numerica em pt-BR.
#'
#' Existe por um motivo concreto: as mesmas cores, o mesmo estilo de tabela e a
#' mesma formatacao estavam copiados em tres projetos sob tres nomes diferentes,
#' identicos byte a byte. Tres copias divergem; um pacote, nao.
#'
#' Ele **nao** traz tema de ggplot nem helpers de interatividade — esses
#' codificam decisoes de cada projeto, e unificar exigiria parametrizar ate o
#' ponto de nao decidir mais nada. Tambem nao traz tipografia, espacamento nem
#' regras de forma: isso vive no CSS do site, onde e aplicavel. A fronteira e
#' essa: o que era identico entre projetos entra; o que diverge por razao
#' legitima, ou nao tem uso do lado do R, fica fora.
#'
#' @section As quatro familias:
#'
#' \describe{
#'   \item{Sistema do site}{[site()], [acento()] — os tokens de cor da direcao
#'     "Boletim Tecnico", para que um grafico feito em R pouse na pagina sem
#'     que ninguem redigite um hexadecimal.}
#'   \item{Paleta}{[paleta()], [tinta()], [grade_rgba()] — cores validadas para
#'     daltonismo, nos modos claro e escuro.}
#'   \item{Tabelas}{[tabela_gt()], [fmt_br()], [fmt_pct_br()] — o tema canonico
#'     das tabelas dos artigos.}
#'   \item{Numeros}{[num_br()], [pct_br()], [mil()] — milhar com ponto, decimal
#'     com virgula.}
#' }
#'
#' @section A cor de uma figura sai de onde:
#'
#' Tres funcoes devolvem cor, e a escolha entre elas nao e de gosto:
#'
#' \describe{
#'   \item{[acento()]}{**uma** serie. O areia unico do site.}
#'   \item{[paleta()]}{**duas ou mais** series, na ordem dos slots. O acento nao
#'     entra aqui.}
#'   \item{[tinta()]}{o que **nao codifica dado** — texto, grade, eixo, fundo.}
#' }
#'
#' [site()] esta abaixo das tres: e de la que as tintas do modo escuro saem.
#'
#' @section A regra que acompanha a paleta:
#'
#' O magenta (`s3`) fica abaixo de 3:1 de contraste sobre fundo claro, e isso
#' nao se conserta trocando o tom — se trocasse, quebraria a separacao para
#' daltonicos. O limite vira regra de desenho: **todo grafico traz rotulo direto
#' na ponta da serie**, alem da legenda. A identidade de uma serie nunca pode
#' depender so da cor.
#'
#' @section O `gt` nao herda a pagina:
#'
#' Sem instrucao de cor o `gt` crava `background-color: #FFFFFF` **inline**, e
#' nenhuma folha de estilo do site derruba estilo inline. Como toda pagina do
#' site e escura, uma tabela sem `modo = "escuro"` la dentro e um retangulo
#' branco no meio do texto — foi exatamente isso que foi ao ar ate a 0.2.0.
#' Escolha o `modo` de [tabela_gt()] pela pagina em que a tabela vai cair.
#'
#' @section Aviso sobre `freeze`:
#'
#' O site renderiza os artigos com `freeze`, entao um artigo ja congelado **nao**
#' re-renderiza quando este pacote muda. Depois de qualquer alteracao que afete
#' layout, suba a versao e rode uma vez, no repo do site: apague
#' `quarto/_freeze/` e rode `npm run build:quarto`. Sem isso o site exibe dois
#' estilos ao mesmo tempo.
#'
#' Nao use `quarto render quarto --no-freeze`: essa opcao nao existe no Quarto
#' 1.9 e o render falha inteiro. Quem invalida o cache e apagar o `_freeze`.
#'
#' @seealso `vignette("theoviz")` para o passo a passo e o raciocinio completo.
"_PACKAGE"
