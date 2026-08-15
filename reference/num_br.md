# Numero em pt-BR

Milhar com ponto, decimal com virgula. Serve tanto dentro de uma tabela
quanto colado no texto de um artigo.

## Usage

``` r
num_br(x, dec = 0)
```

## Arguments

- x:

  Vetor numerico.

- dec:

  Casas decimais.

## Value

Vetor de texto do mesmo comprimento de `x`.

## Examples

``` r
num_br(1234567)          # "1.234.567"
#> [1] "1.234.567"
num_br(33.126, dec = 2)  # "33,13"
#> [1] "33,13"
```
