# theoviz: Identidade Visual dos Artigos de Dados Abertos

Paleta validada para daltonismo, tokens do sistema visual do site, tema
canonico das tabelas 'gt' e formatacao numerica em portugues do Brasil,
compartilhados pelos projetos de dados abertos publicados em
theoalbuquerque.com.br. Existe para que os artigos de projetos
diferentes leiam como um sistema so, em vez de divergirem por copia.

## O que este pacote decide, e o que nao decide

`theoviz` guarda a identidade visual **compartilhada** dos projetos de
dados abertos publicados em <https://theoalbuquerque.com.br>: os tokens
do sistema visual do site, a paleta, o tema das tabelas
[`gt::gt()`](https://gt.rstudio.com/reference/gt.html) e a formatacao
numerica em pt-BR.

Existe por um motivo concreto: as mesmas cores, o mesmo estilo de tabela
e a mesma formatacao estavam copiados em tres projetos sob tres nomes
diferentes, identicos byte a byte. Tres copias divergem; um pacote, nao.

Ele **nao** traz tema de ggplot nem helpers de interatividade — esses
codificam decisoes de cada projeto, e unificar exigiria parametrizar ate
o ponto de nao decidir mais nada. Tambem nao traz tipografia,
espacamento nem regras de forma: isso vive no CSS do site, onde e
aplicavel. A fronteira e essa: o que era identico entre projetos entra;
o que diverge por razao legitima, ou nao tem uso do lado do R, fica
fora.

## As quatro familias

- Sistema do site:

  [`site()`](https://theoadepaula.github.io/theoviz/reference/site.md),
  [`acento()`](https://theoadepaula.github.io/theoviz/reference/acento.md)
  — os tokens de cor da direcao "Boletim Tecnico", para que um grafico
  feito em R pouse na pagina sem que ninguem redigite um hexadecimal.

- Paleta:

  [`paleta()`](https://theoadepaula.github.io/theoviz/reference/paleta.md),
  [`tinta()`](https://theoadepaula.github.io/theoviz/reference/tinta.md),
  [`grade_rgba()`](https://theoadepaula.github.io/theoviz/reference/grade_rgba.md)
  — cores validadas para daltonismo, nos modos claro e escuro.

- Tabelas:

  [`tabela_gt()`](https://theoadepaula.github.io/theoviz/reference/tabela_gt.md),
  [`fmt_br()`](https://theoadepaula.github.io/theoviz/reference/fmt_br.md),
  [`fmt_pct_br()`](https://theoadepaula.github.io/theoviz/reference/fmt_pct_br.md)
  — o tema canonico das tabelas dos artigos.

- Numeros:

  [`num_br()`](https://theoadepaula.github.io/theoviz/reference/num_br.md),
  [`pct_br()`](https://theoadepaula.github.io/theoviz/reference/pct_br.md),
  [`mil()`](https://theoadepaula.github.io/theoviz/reference/mil.md) —
  milhar com ponto, decimal com virgula.

## A cor de uma figura sai de onde

Tres funcoes devolvem cor, e a escolha entre elas nao e de gosto:

- [`acento()`](https://theoadepaula.github.io/theoviz/reference/acento.md):

  **uma** serie. O areia unico do site.

- [`paleta()`](https://theoadepaula.github.io/theoviz/reference/paleta.md):

  **duas ou mais** series, na ordem dos slots. O acento nao entra aqui.

- [`tinta()`](https://theoadepaula.github.io/theoviz/reference/tinta.md):

  o que **nao codifica dado** — texto, grade, eixo, fundo.

[`site()`](https://theoadepaula.github.io/theoviz/reference/site.md)
esta abaixo das tres: e de la que as tintas do modo escuro saem.

## A regra que acompanha a paleta

O magenta (`s3`) fica abaixo de 3:1 de contraste sobre fundo claro, e
isso nao se conserta trocando o tom — se trocasse, quebraria a separacao
para daltonicos. O limite vira regra de desenho: **todo grafico traz
rotulo direto na ponta da serie**, alem da legenda. A identidade de uma
serie nunca pode depender so da cor.

## O `gt` nao herda a pagina

Sem instrucao de cor o `gt` crava `background-color: #FFFFFF`
**inline**, e nenhuma folha de estilo do site derruba estilo inline.
Como toda pagina do site e escura, uma tabela sem `modo = "escuro"` la
dentro e um retangulo branco no meio do texto — foi exatamente isso que
foi ao ar ate a 0.2.0. Escolha o `modo` de
[`tabela_gt()`](https://theoadepaula.github.io/theoviz/reference/tabela_gt.md)
pela pagina em que a tabela vai cair.

## Aviso sobre `freeze`

O site renderiza os artigos com `freeze`, entao um artigo ja congelado
**nao** re-renderiza quando este pacote muda. Depois de qualquer
alteracao que afete layout, suba a versao e rode uma vez, no repo do
site: apague `quarto/_freeze/` e rode `npm run build:quarto`. Sem isso o
site exibe dois estilos ao mesmo tempo.

Nao use `quarto render quarto --no-freeze`: essa opcao nao existe no
Quarto 1.9 e o render falha inteiro. Quem invalida o cache e apagar o
`_freeze`.

## See also

[`vignette("theoviz")`](https://theoadepaula.github.io/theoviz/articles/theoviz.md)
para o passo a passo e o raciocinio completo.

## Author

**Maintainer**: Theo Albuquerque de Paula <theophd@gmail.com>
