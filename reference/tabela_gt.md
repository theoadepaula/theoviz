# Tabela no estilo padrao dos artigos

O tema canonico das tabelas `gt`: regua horizontal apenas, cabecalho
discreto alinhado a esquerda, nenhuma linha vertical. Coluna se separa
por espaco, nao por tinta.

## Usage

``` r
tabela_gt(
  dados,
  titulo = NULL,
  subtitulo = NULL,
  nota = NULL,
  modo = c("claro", "escuro")
)
```

## Arguments

- dados:

  data.frame ou tibble.

- titulo:

  Titulo da tabela (opcional).

- subtitulo:

  Linha de apoio abaixo do titulo (opcional).

- nota:

  Nota de rodape; aceita markdown (opcional).

- modo:

  `"claro"` (padrao) ou `"escuro"`. Ver a secao acima.

## Value

Um objeto `gt_tbl`, encadeavel com as funcoes do pacote gt.

## A tabela e o par acessivel do grafico

Quando a cor falha – daltonismo, impressao em preto e branco, tela ruim
– e a tabela que responde. Por isso ela nao e opcional num artigo com
figura, e por isso saida crua de tibble em `<pre>` nao vai ao ar.

## Escolha o modo pela pagina em que a tabela vai cair

O `gt` **nao herda** a cor da pagina: sem instrucao ele crava fundo
branco com texto cinza-escuro, inline, e nenhuma folha de estilo do site
derruba isso. Como as paginas do site sao escuras, uma tabela em
`modo = "claro"` la dentro e um retangulo branco no meio do texto.

- `"escuro"`:

  fundo **transparente** e tintas do site. A tabela pousa na pagina em
  vez de recortar uma chapa dentro dela – a mesma escolha ja feita nos
  graficos plotly. E o modo do que vai ao ar.

- `"claro"` (padrao):

  superficie clara explicita. Serve impressao, slide e PDF. Nao e
  transparente de proposito: transparente com tinta escura por cima
  seria ilegivel na pagina escura.

O padrao segue `"claro"` pela razao descrita em
[`tinta()`](https://theoadepaula.github.io/theoviz/reference/tinta.md):
trocar o padrao restilizaria de uma vez artigos ja congelados por
`freeze`.

## As duas vozes

Colunas numericas saem em **IBM Plex Mono**, o resto em **IBM Plex
Sans**. E a Regra das Duas Vozes do site: sans e discurso, mono e
medida. A fronteira e semantica, nao estetica – um numero existe para
ser comparado com outro, e a mono e o que diz isso.

## Celula pintada com a cor da serie

Este tema nao pinta nenhuma celula de cor de serie. Quando o artigo
pinta – variacao positiva em verde, por exemplo, com
[`gt::tab_style()`](https://gt.rstudio.com/reference/tab_style.html) –,
a cor e de **texto**, e texto tem piso de 4,5:1. Use
`paleta(modo = "escuro", uso = "texto")`, nao a paleta de marca: o verde
de marca (`#008300`) mede 3,86:1 sobre o chao do site e foi acusado pelo
Lighthouse. Ver
[`paleta()`](https://theoadepaula.github.io/theoviz/reference/paleta.md).

## Cabecalhos para o leitor de tela

Cada celula do corpo leva um atributo `headers` com os ids dos
cabecalhos que a descrevem. Coluna com nome que comeca por algarismo
(`2025`) ou que tem espaco (`Garrafa plastica`) gerava, ate o `gt`
1.3.0, um `headers` que nao batia com o `id` do cabecalho – e o
Lighthouse acusava `td-headers-attr`. Por isso o pacote exige `gt` 1.4.0
ou posterior. Pode nomear as colunas como quiser; nao precisa contornar
com `cols_label()`.

Resta um caso no proprio `gt`: com
[`gt::tab_row_group()`](https://gt.rstudio.com/reference/tab_row_group.html)
cobrindo so parte das linhas, as que ficam de fora citam um grupo `NA`
que nao existe. Ponha todas as linhas em algum grupo.

## See also

[`fmt_br()`](https://theoadepaula.github.io/theoviz/reference/fmt_br.md)
e
[`fmt_pct_br()`](https://theoadepaula.github.io/theoviz/reference/fmt_pct_br.md)
para a formatacao pt-BR das colunas;
[`tinta()`](https://theoadepaula.github.io/theoviz/reference/tinta.md)
para as tintas que este tema consome;
[`paleta()`](https://theoadepaula.github.io/theoviz/reference/paleta.md)
com `uso = "texto"` para pintar celula com a cor de uma serie.

## Examples

``` r
tabela_gt(head(mtcars[, 1:3]), titulo = "Exemplo")


  


Exemplo
```
