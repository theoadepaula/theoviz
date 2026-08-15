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

## See also

[`fmt_br()`](https://theoadepaula.github.io/theoviz/reference/fmt_br.md)
e
[`fmt_pct_br()`](https://theoadepaula.github.io/theoviz/reference/fmt_pct_br.md)
para a formatacao pt-BR das colunas;
[`tinta()`](https://theoadepaula.github.io/theoviz/reference/tinta.md)
para as tintas que este tema consome.

## Examples

``` r
tabela_gt(head(mtcars[, 1:3]), titulo = "Exemplo")


  


Exemplo
```
