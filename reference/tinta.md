# Tintas neutras

Cinzas de texto, grade e fundo. Separados das cores de serie porque
nunca codificam dado – so estrutura.

## Usage

``` r
tinta(qual = NULL, modo = c("claro", "escuro"))
```

## Arguments

- qual:

  Nome de uma tinta. Sem argumento, devolve todas.

- modo:

  `"claro"` (padrao) ou `"escuro"`.

## Value

Vetor nomeado de cores em hexadecimal.

## O site nao tem modo claro

O padrao continua sendo `"claro"`, e isso e deliberado: trocar o padrao
restilizaria de uma vez artigos ja congelados por `freeze`, e o site
passaria a exibir dois estilos ao mesmo tempo. **Mas o site e escuro por
definicao** – um grafico que vai ao ar quer `modo = "escuro"`.

A troca e uma decisao de publicacao, tomada em cada projeto junto com um
re-render completo do site (apagar `quarto/_freeze/` e rodar
`npm run build:quarto`). O modo claro segue util fora do site:
impressao, slide, PDF.

## De onde vem cada modo

No **modo escuro**, desde a 0.3.0, as tintas *sao* os tokens do site –
ver
[`site()`](https://theoadepaula.github.io/theoviz/reference/site.md).
Antes eram cinzas quentes herdados do sistema visual anterior, e o
Boletim e um sistema frio; cinza quente sobre pagina fria nao le como
neutro discreto, le como figura recortada de outro documento.

|           |           |           |                   |
|-----------|-----------|-----------|-------------------|
| **tinta** | **0.2.0** | **0.3.0** | **token do site** |
| `forte`   | `#ffffff` | `#dde1e6` | `titulo`          |
| `media`   | `#c3c2b7` | `#a9b0b8` | `leitura`         |
| `fraca`   | `#898781` | `#7d858e` | `rotulo`          |
| `grade`   | `#2c2c2a` | `#2c333c` | `filete`          |
| `eixo`    | `#383835` | `#2c333c` | `filete`          |
| `fundo`   | `#1a1a19` | `#0d1014` | `noite`           |

Duas notas sobre a tabela. O `forte` deixou de ser branco puro porque o
site o proibe sobre este fundo, com razao especifica: ele vibra. E
`grade` e `eixo` passaram a ser **o mesmo valor**, porque o site usa um
filete so para as duas coisas – os dois nomes seguem existindo para nao
quebrar quem ja os chama.

O **modo claro nao foi rebaseado**, e nao havia como: o site nao tem
superficie clara contra a qual validar. Ele guarda a referencia
`#fcfcfb`.

## See also

[`site()`](https://theoadepaula.github.io/theoviz/reference/site.md)
para o conjunto completo de tokens do site.

## Examples

``` r
tinta()
#>     forte     media     fraca     grade      eixo     fundo 
#> "#0b0b0b" "#52514e" "#898781" "#e1e0d9" "#c3c2b7" "#fcfcfb" 
tinta("grade")
#> [1] "#e1e0d9"
tinta("fundo", modo = "escuro")   # o chao do site
#> [1] "#0d1014"
```
