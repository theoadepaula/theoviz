#' @keywords internal
#'
#' @section O que este pacote decide, e o que nao decide:
#'
#' `theoviz` guarda a identidade visual **compartilhada** dos projetos de dados
#' abertos publicados em <https://theoalbuquerque.com.br>: a paleta, o tema das
#' tabelas [gt::gt()] e a formatacao numerica em pt-BR.
#'
#' Existe por um motivo concreto: as mesmas cores, o mesmo estilo de tabela e a
#' mesma formatacao estavam copiados em tres projetos sob tres nomes diferentes,
#' identicos byte a byte. Tres copias divergem; um pacote, nao.
#'
#' Ele **nao** traz tema de ggplot nem helpers de interatividade — esses
#' codificam decisoes de cada projeto, e unificar exigiria parametrizar ate o
#' ponto de nao decidir mais nada. A fronteira e essa: o que era identico entre
#' projetos entra; o que diverge por razao legitima fica fora.
#'
#' @section As tres familias:
#'
#' \describe{
#'   \item{Paleta}{[paleta()], [tinta()], [grade_rgba()] — cores validadas para
#'     daltonismo, nos modos claro e escuro.}
#'   \item{Tabelas}{[tabela_gt()], [fmt_br()], [fmt_pct_br()] — o tema canonico
#'     das tabelas dos artigos.}
#'   \item{Numeros}{[num_br()], [pct_br()], [mil()] — milhar com ponto, decimal
#'     com virgula.}
#' }
#'
#' @section A regra que acompanha a paleta:
#'
#' O magenta (`s3`) fica abaixo de 3:1 de contraste sobre fundo claro, e isso
#' nao se conserta trocando o tom — se trocasse, quebraria a separacao para
#' daltonicos. O limite vira regra de desenho: **todo grafico traz rotulo direto
#' na ponta da serie**, alem da legenda. A identidade de uma serie nunca pode
#' depender so da cor.
#'
#' @section Aviso sobre `freeze`:
#'
#' O site renderiza os artigos com `freeze`, entao um artigo ja congelado **nao**
#' re-renderiza quando este pacote muda. Depois de qualquer alteracao que afete
#' layout, suba a versao e rode uma vez, no repo do site:
#' `quarto render quarto --no-freeze`. Sem isso o site exibe dois estilos ao
#' mesmo tempo.
#'
#' @seealso `vignette("theoviz")` para o passo a passo e o raciocinio completo.
"_PACKAGE"
