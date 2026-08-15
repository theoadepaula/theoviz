# Formata colunas numericas em pt-BR

Atalho para
[`gt::fmt_number()`](https://gt.rstudio.com/reference/fmt_number.html)
com separador de milhar ponto e decimal virgula, que e o que os artigos
usam em toda tabela.

## Usage

``` r
fmt_br(g, colunas, decimais = 0)
```

## Arguments

- g:

  Objeto `gt_tbl`.

- colunas:

  Colunas a formatar (tidyselect).

- decimais:

  Casas decimais.

## Value

O `gt_tbl` com as colunas formatadas.

## See also

[`tabela_gt()`](https://theoadepaula.github.io/theoviz/reference/tabela_gt.md),
[`num_br()`](https://theoadepaula.github.io/theoviz/reference/num_br.md).

## Examples

``` r
fmt_br(tabela_gt(head(mtcars[, 1:3])), disp, decimais = 1)


  

mpg
```
