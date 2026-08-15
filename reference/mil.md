# Numero em milhares

Para eixos e rotulos onde a unidade inteira polui. `mil(137063)` devolve
"137", nao "137.063".

## Usage

``` r
mil(x, dec = 0)
```

## Arguments

- x:

  Vetor numerico.

- dec:

  Casas decimais depois de dividir por mil.

## Value

Vetor de texto.

## Examples

``` r
mil(137063)  # "137"
#> [1] "137"
```
