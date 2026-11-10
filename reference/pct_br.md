# Percentual em pt-BR

Percentual em pt-BR

## Usage

``` r
pct_br(x, dec = 1)
```

## Arguments

- x:

  Vetor numerico ja em escala de 0 a 100 (nao de 0 a 1).

- dec:

  Casas decimais.

## Value

Vetor de texto, com o sinal de porcento colado. `NA` sai `"NA"`, sem o
sinal, como em
[`num_br()`](https://theoadepaula.github.io/theoviz/reference/num_br.md).

## Examples

``` r
pct_br(33.126)  # "33,1%"
#> [1] "33,1%"
pct_br(NA)      # "NA"
#> [1] "NA"
```
