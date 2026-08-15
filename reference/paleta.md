# Cores de serie

Os quatro slots categoricos da paleta, na ordem validada.

## Usage

``` r
paleta(n = 4, modo = c("claro", "escuro"))
```

## Arguments

- n:

  Quantos slots devolver (1 a 4). Sem argumento, devolve os quatro.

- modo:

  `"claro"` (padrao) ou `"escuro"`. O modo escuro tem passos proprios,
  validados contra a superficie escura – nao e um clareamento automatico
  do claro.

## Value

Vetor nomeado de cores em hexadecimal.

## Uma serie so nao usa a paleta

Grafico de **uma** serie usa
[`acento()`](https://theoadepaula.github.io/theoviz/reference/acento.md),
o areia do site. A paleta comeca a valer em **duas**. Ver a regra
inteira em
[`acento()`](https://theoadepaula.github.io/theoviz/reference/acento.md).

## A ordem dos slots faz parte da validacao

Usar `s1` e `s3` num grafico de duas series e seguro; trocar `s2` por
uma cor "parecida" nao e. Ha teste travando os valores exatos – mudar um
exige mudar o teste tambem, para que a troca seja deliberada e
revalidada.

Nunca cicle a paleta. Uma quinta serie vira facetas ou "outros", nao uma
cor nova.

## Contraste contra o fundo

No modo **escuro**, os quatro passam de 3:1 contra o chao do site
(`#0d1014`): 5,24 / 3,86 / 4,83 / 6,21. E tambem contra a chapa elevada
(`#141920`), que e o pior caso de um grafico dentro de cartao: 4,85 /
3,57 / 4,47 / 5,75. Medido em 2026-08-13.

No modo **claro** dois slots ficam abaixo do piso – `s3` em 2,62 e `s4`
em 2,11 sobre `#fcfcfb`. E dessa falha que nasce a regra do rotulo
direto, e por isso ela vale nos dois modos: identidade de serie nunca
depende so de cor.

## See also

[`acento()`](https://theoadepaula.github.io/theoviz/reference/acento.md)
para o caso de uma serie so;
[`tinta()`](https://theoadepaula.github.io/theoviz/reference/tinta.md)
para os neutros.

## Examples

``` r
paleta()                    # os quatro, modo claro
#>        s1        s2        s3        s4 
#> "#2a78d6" "#008300" "#e87ba4" "#eda100" 
paleta(2)                   # so os dois primeiros: azul e verde
#>        s1        s2 
#> "#2a78d6" "#008300" 
paleta(modo = "escuro")     # os quatro passos do modo escuro
#>        s1        s2        s3        s4 
#> "#3987e5" "#008300" "#d55181" "#c98500" 
```
