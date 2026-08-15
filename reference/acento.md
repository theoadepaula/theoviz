# Acento unico do site

O areia (`#cfae72`), unico acento do sistema visual do site.

## Usage

``` r
acento(estado = c("base", "hover", "pressionado"))
```

## Arguments

- estado:

  `"base"` (padrao), `"hover"` ou `"pressionado"`. O `hover` e o de
  **texto**, que acende; o `pressionado` e o de **superficie**, que
  afunda. A assimetria e deliberada: fundo que clareia no hover empurra
  o rotulo para perto do piso de contraste.

## Value

Uma cor em hexadecimal.

## Quando usar o acento, e quando usar a paleta

A regra decide pelo **numero de series**, e nao pelo gosto:

- **Uma serie**:

  use o acento. E o que a figura da home faz, e e o que faz o grafico
  ler como peca do site em vez de saida de biblioteca.

- **Duas ou mais**:

  use
  [`paleta()`](https://theoadepaula.github.io/theoviz/reference/paleta.md),
  na ordem dos slots. O acento nao entra na paleta categorica: ele nao
  foi validado para daltonismo contra os quatro slots, e o sistema do
  site reserva o areia para "acao, estado ativo ou marcador estrutural".

Nao ha meio-termo: um grafico de tres series com uma delas em areia
mistura dois vocabularios e quebra os dois.

## A propriedade que este valor tem, e que um acento novo nao herda

O areia passa **nos dois sentidos** – 9,03:1 como texto sobre `noite` e
os mesmos 9,03:1 como fundo com rotulo em `noite` por cima, porque
contraste e simetrico. E por isso que o site nao tem um "areia de botao"
a parte.

Isso e propriedade **deste valor**, nao licenca geral. Um acento que
passa como texto nao passa automaticamente como superficie – foi
exatamente esse erro que custou uma correcao ao site em 2026-08-04.

## See also

[`site()`](https://theoadepaula.github.io/theoviz/reference/site.md),
[`paleta()`](https://theoadepaula.github.io/theoviz/reference/paleta.md).

## Examples

``` r
acento()
#> [1] "#cfae72"
acento("pressionado")
#> [1] "#bd9a5b"
```
