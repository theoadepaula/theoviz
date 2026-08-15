# Tokens de cor do sistema visual do site

As cores da direcao **"Boletim Tecnico"**, adotada pelo site em
2026-08-09. Sao o espelho do bloco `@theme` de `src/styles/global.css`,
para que um grafico ou painel feito em R pouse na pagina sem que ninguem
tenha de redigitar um hexadecimal.

## Usage

``` r
site(qual = NULL)
```

## Arguments

- qual:

  Nome de um token. Sem argumento, devolve todos.

## Value

Vetor nomeado de cores em hexadecimal; ou uma string, se `qual` for
dado.

## Details

O site e **escuro por definicao** e nao tem modo claro – por isso esta
funcao nao tem argumento `modo`. Ver a secao "O site nao tem modo claro"
em
[`tinta()`](https://theoadepaula.github.io/theoviz/reference/tinta.md).

## Os tokens

**Superficies**

- `noite`:

  `#0d1014` – o chao de tudo. Fundo da pagina.

- `chapa`:

  `#141920` – a unica superficie acima do chao (cartao, campo). A 1,08:1
  do fundo: e pouco de proposito, e e pouco mesmo.

- `divisa`:

  `#1e242c` – divisoria de 1px.

- `filete`:

  `#2c333c` – o traco que pertence a uma figura: base de eixo e grade de
  grafico.

- `controle`:

  `#616a75` – contorno de componente interativo. 3,47:1 sobre o fundo,
  que e o piso da WCAG 1.4.11. **Nao e cor de divisoria.**

**Texto** (contraste medido sobre `noite`)

- `titulo`:

  `#dde1e6` – 14,52:1. Titulo e numero em destaque. Nao e branco puro: o
  branco puro sobre este fundo vibra.

- `leitura`:

  `#a9b0b8` – 8,71:1. Todo o texto corrido.

- `apoio`:

  `#828a93` – 5,45:1. Legenda de figura, descricao.

- `rotulo`:

  `#7d858e` – 5,10:1. **O piso do sistema**: rotulo mono, data, rotulo
  de eixo. Sobre `chapa` cai para 4,72:1, e a folga ate o limite de 4,5
  e de 0,22 – nao mexa em nenhum dos dois sem remedir.

**Acento e retorno**

- `areia`, `areia_clara`, `areia_pressionada`:

  ver
  [`acento()`](https://theoadepaula.github.io/theoviz/reference/acento.md).

- `ok`:

  `#7fb08a` – 7,70:1. Confirmacao.

- `err`:

  `#d08a7a` – 6,90:1. Falha.

`ok` e `err` sao dessaturados de proposito: num sistema de acento unico,
um verde ou vermelho vivo leria imediatamente como segunda cor de marca.
**Nunca aparecem sozinhos** – cor nao e sinal acessivel, entao todo
retorno vem acompanhado de texto.

## See also

[`acento()`](https://theoadepaula.github.io/theoviz/reference/acento.md)
para o acento unico,
[`tinta()`](https://theoadepaula.github.io/theoviz/reference/tinta.md)
para as tintas de grafico e
[`paleta()`](https://theoadepaula.github.io/theoviz/reference/paleta.md)
para as cores de serie.

## Examples

``` r
site("noite")
#> [1] "#0d1014"
site("filete")   # a grade de um grafico
#> [1] "#2c333c"
names(site())
#>  [1] "noite"             "chapa"             "divisa"           
#>  [4] "filete"            "controle"          "titulo"           
#>  [7] "leitura"           "apoio"             "rotulo"           
#> [10] "areia"             "areia_clara"       "areia_pressionada"
#> [13] "ok"                "err"              
```
