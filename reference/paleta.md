# Cores de serie

Os quatro slots categoricos da paleta, na ordem validada.

## Usage

``` r
paleta(n = 4, modo = c("claro", "escuro"), uso = c("marca", "texto"))
```

## Arguments

- n:

  Quantos slots devolver (1 a 4). Sem argumento, devolve os quatro.

- modo:

  `"claro"` (padrao) ou `"escuro"`. O modo escuro tem passos proprios,
  validados contra a superficie escura – nao e um clareamento automatico
  do claro.

- uso:

  `"marca"` (padrao) para linha, ponto e barra – piso de 3:1 – ou
  `"texto"` quando a cor da serie pinta texto – piso de 4,5:1. Ver a
  secao *Marca nao e texto*. `"texto"` so existe com `modo = "escuro"`.

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

## Marca nao e texto

Os slots acima sao cores de **marca** – linha, ponto, barra –, e o piso
de marca e 3:1. Texto tem piso de **4,5:1** (WCAG AA), e o verde `s2`,
com 3,86:1 sobre `#0d1014`, nao chega la. Por isso, quando a cor da
serie vira **texto** – celula de tabela `gt` pintada pela serie, rotulo
direto na ponta da linha, anotacao plotly –, peca `uso = "texto"`:


    verde <- paleta(2, "escuro", uso = "texto")[["s2"]]
    gt::tab_style(g, gt::cell_text(color = verde),
                  gt::cells_body(columns = variacao))

A variante de texto troca **so o verde**: `#008f56`, 4,60:1 sobre
`noite`, a DeltaE 7,3 do `s2` em visao normal – le como o mesmo verde.
Os outros tres slots ja passam 4,5:1 (5,24 / 4,83 / 6,21) e saem iguais.
A linha do grafico segue em `s2`; so o rotulo dela muda.

Sob daltonismo, o pior par da variante de texto fica em DeltaE 6,5 – a
faixa 6-8, legal so com codificacao secundaria. Texto sempre a tem: o
proprio conteudo (o nome da serie, o sinal do numero). A cor reforca,
nunca decide.

A garantia e sobre `noite`, o chao em que tabelas e graficos pousam.
Sobre a `chapa` o verde de texto cai para 4,26 e o magenta para 4,47:
texto colorido dentro de cartao nao esta coberto.

So existe no modo escuro. No claro, tres dos quatro slots ficam abaixo
de 4,5:1 sobre `#fcfcfb` (4,30 / 2,62 / 2,11), e o site nao tem
superficie clara contra a qual validar uma alternativa – pedir
`uso = "texto"` no claro e erro, nao silencio.

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

# a cor da serie como TEXTO (celula de tabela, rotulo direto):
paleta(modo = "escuro", uso = "texto")
#>        s1        s2        s3        s4 
#> "#3987e5" "#008f56" "#d55181" "#c98500" 
```
