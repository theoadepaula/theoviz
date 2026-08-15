# Grade em rgba, para quando o fundo da pagina e desconhecido

O plotly precisa de fundo transparente para o widget herdar a cor da
pagina em vez de cravar um branco dentro do tema escuro do site. A grade
entao precisa de alfa, que hexadecimal de 6 digitos nao carrega.

## Usage

``` r
grade_rgba(alfa = 0.22)
```

## Arguments

- alfa:

  Opacidade, de 0 a 1.

## Value

String no formato "rgba(r,g,b,a)".

## Prefira a grade solida quando souber onde o grafico pousa

Este cinza – `rgb(138,138,133)`, quente – e um **acordo**: um valor que
sobrevive tanto sobre fundo claro quanto sobre escuro, porque em 2026-07
nao se sabia em qual dos dois o grafico ia cair.

Hoje se sabe: o site e escuro por definicao. Um grafico que vai ao ar
deve usar a grade solida do sistema, `tinta("grade", modo = "escuro")`
(= `site("filete")`), que e fria como o resto da pagina. Esta funcao
fica para o caso em que o fundo e mesmo desconhecido – um widget
embutido fora do site, por exemplo.

## See also

[`tinta()`](https://theoadepaula.github.io/theoviz/reference/tinta.md),
[`site()`](https://theoadepaula.github.io/theoviz/reference/site.md).

## Examples

``` r
grade_rgba()
#> [1] "rgba(138,138,133,0.22)"
```
