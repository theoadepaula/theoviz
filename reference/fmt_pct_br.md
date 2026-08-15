# Formata colunas de percentual em pt-BR

Formata colunas de percentual em pt-BR

## Usage

``` r
fmt_pct_br(g, colunas, decimais = 1)
```

## Arguments

- g:

  Objeto `gt_tbl`.

- colunas:

  Colunas a formatar (tidyselect).

- decimais:

  Casas decimais.

## Value

O `gt_tbl` com as colunas formatadas como percentual.

## See also

[`tabela_gt()`](https://theoadepaula.github.io/theoviz/reference/tabela_gt.md),
[`pct_br()`](https://theoadepaula.github.io/theoviz/reference/pct_br.md).

## Examples

``` r
d <- data.frame(faixa = c("a", "b"), parte = c(0.331, 0.669))
fmt_pct_br(tabela_gt(d), parte)


  

faixa
```
