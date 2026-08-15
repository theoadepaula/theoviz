# Identidade visual dos artigos: como usar e por quê

Este pacote não é uma coleção de utilitários bonitos. Ele é a resposta a
um problema concreto: em julho de 2026, ao comparar três projetos de
dados abertos do mesmo autor, descobriu-se que as mesmas cores, o mesmo
estilo de tabela e a mesma formatação numérica estavam **copiados nos
três**, sob três nomes diferentes — `COR$s1`, `PAL["slot1"]`,
`CORES["s1"]`. Eram idênticos byte a byte.

Três cópias divergem. Um pacote, não.

## Antes da paleta: em que página a figura vai cair

Em 2026-08-09 o site trocou de direção visual — saiu *“A Sala de Leitura
Noturna”*, entrou **“O Boletim Técnico”**. Desde a 0.3.0 o pacote
carrega os tokens de cor desse sistema:

``` r

site("noite")    # o chão da página
#> [1] "#0d1014"
site("filete")   # grade e base de eixo
#> [1] "#2c333c"
acento()         # o areia, único acento do sistema
#> [1] "#cfae72"
```

Sim, isto é uma **cópia** do `@theme` de `src/styles/global.css`, no
repo do site — e cópia é o que este pacote existe para eliminar. A
diferença importa: agora há uma, datada, com a fonte escrita, e um teste
que a confere contra o CSS do site quando o repo está na máquina. Antes
havia três, e cada projeto inventava o cinza que faltava.

O que **não** entra: tipografia, espaçamento e as regras de forma (raio
zero, sombra zero). Isso é do CSS do site e não tem uso do lado do R. O
que o pacote consome são as cores, porque gráfico e tabela precisam
delas para pousar na página sem parecer recorte de outro documento.

### A cor de uma figura sai de onde

Três funções devolvem cor, e a escolha entre elas não é de gosto:

| quantas séries | o que usar |
|----|----|
| **uma** | [`acento()`](https://theoadepaula.github.io/theoviz/reference/acento.md) — o areia do site |
| **duas ou mais** | [`paleta()`](https://theoadepaula.github.io/theoviz/reference/paleta.md), na ordem dos slots |
| nenhuma (estrutura) | [`tinta()`](https://theoadepaula.github.io/theoviz/reference/tinta.md) — texto, grade, eixo, fundo |

Não há meio-termo. Um gráfico de três séries com uma delas em areia
mistura dois vocabulários e quebra os dois: o areia **não entra na
paleta categórica**, tanto porque não foi validado para daltonismo
contra os quatro slots quanto porque o sistema do site o reserva para
ação e estado ativo.

## A paleta é um mecanismo de segurança

As quatro cores de série não foram escolhidas por gosto. Elas passaram
por um validador de daltonismo (protanopia, deuteranopia, tritanopia), e
a separação entre pares adjacentes ficou em ΔE 17,6 no pior caso —
contra um piso de 8.

``` r

paleta()
#>        s1        s2        s3        s4 
#> "#2a78d6" "#008300" "#e87ba4" "#eda100"
```

Você pede menos que quatro quando o gráfico tem menos séries:

``` r

paleta(2)
#>        s1        s2 
#> "#2a78d6" "#008300"
```

**A ordem dos slots faz parte da validação.** Usar `s1` e `s3` em duas
séries é seguro; trocar `s2` por uma cor “parecida” não é. Há teste
travando os valores exatos: se ele quebrar depois de uma mudança de cor,
a pergunta certa não é “como faço o teste passar”, é “revalidei o
contraste?”.

### O limite que gera uma regra

O magenta (`s3`) fica **abaixo de 3:1 de contraste** sobre fundo claro.
Isso não se conserta trocando o tom — se trocasse, quebraria a separação
para daltônicos, que é a restrição mais dura.

Então o limite vira regra de desenho: **todo gráfico traz rótulo direto
na ponta da série, além da legenda.** A identidade de uma série nunca
pode depender só da cor. É por isso que essa regra aparece em todos os
projetos que usam este pacote.

### Modo escuro

``` r

paleta(modo = "escuro")
#>        s1        s2        s3        s4 
#> "#3987e5" "#008300" "#d55181" "#c98500"
```

Não é clareamento automático do modo claro — são passos próprios,
validados contra a superfície escura. O verde é o único slot igual nos
dois modos.

O resultado contraria a intuição:

|  | pior par adjacente | contraste vs superfície |
|----|----|----|
| claro (`#fcfcfb`) | ΔE 16,3 (deutan) | `s3` 2,62 e `s4` 2,11 — **abaixo de 3:1** |
| escuro (`#0d1014`) | ΔE 13,0 (deutan) | 5,24 / 3,86 / 4,83 / 6,21 — os quatro **acima de 3:1** |

O chão mudou de `#1a1a19` para `#0d1014` em 2026-08-09 e **estes valores
não mudaram junto**, porque não precisavam: ΔE entre as cores não
depende do fundo, e o contraste contra um chão mais escuro só melhorou.
Quem sustenta essa afirmação não é este parágrafo — é
`tests/testthat/test-site.R`, que recalcula os contrastes a cada
`R CMD check`.

No escuro a paleta é mais segura em contraste que no claro. A regra do
rótulo direto nasce do modo claro, e vale nos dois por consistência.

Um limite novo acompanha o modo escuro: olhando *todos* os pares, e não
só os adjacentes, `s2` × `s4` (verde × âmbar) cai para **ΔE 6,9 em
protanopia** — dentro da faixa 6–8, legal apenas com codificação
secundária. Um gráfico escuro que use **somente esses dois slots**
precisa de rótulo direto ou textura. Usando os slots na ordem, o
problema não aparece.

### Tintas neutras

Cinzas de texto, grade, eixo e fundo. Ficam separados das cores de série
porque **nunca codificam dado** — só estrutura.

``` r

tinta()
#>     forte     media     fraca     grade      eixo     fundo 
#> "#0b0b0b" "#52514e" "#898781" "#e1e0d9" "#c3c2b7" "#fcfcfb"
tinta("grade")
#> [1] "#e1e0d9"
tinta(modo = "escuro")
#>     forte     media     fraca     grade      eixo     fundo 
#> "#dde1e6" "#a9b0b8" "#7d858e" "#2c333c" "#2c333c" "#0d1014"
```

**No modo escuro as tintas são os tokens do site**, desde a 0.3.0 — não
valores próprios:

``` r

identical(tinta("fraca", modo = "escuro"), site("rotulo"))
#> [1] TRUE
```

Eram cinzas **quentes** herdados do sistema visual anterior (`#898781`,
`#2c2c2a`). O Boletim é um sistema **frio**, e cinza quente sobre página
fria não lê como neutro discreto — lê como figura recortada de outro
documento.

Duas consequências que quebram hábito:

- **`tinta("fraca")` deixou de ser a mesma nos dois modos.** Era, até a
  0.2.0. O Boletim tem um piso próprio, medido contra o fundo e contra a
  chapa.
- **`grade` e `eixo` são o mesmo valor no escuro.** O site usa um filete
  só para os dois. No claro seguem distintos: o modo claro não foi
  rebaseado.

[`grade_rgba()`](https://theoadepaula.github.io/theoviz/reference/grade_rgba.md)
devolve a grade com alfa, que hexadecimal de 6 dígitos não carrega:

``` r

grade_rgba()
#> [1] "rgba(138,138,133,0.22)"
grade_rgba(0.4)
#> [1] "rgba(138,138,133,0.4)"
```

Ele é o recurso de **chão desconhecido**: serve quando a figura não sabe
sobre o que vai pousar, e por isso não tem argumento `modo`. Sabendo o
chão, prefira a grade sólida — `tinta("grade", modo = "escuro")`.

## Tabelas

[`tabela_gt()`](https://theoadepaula.github.io/theoviz/reference/tabela_gt.md)
é o tema canônico. Em uma frase: régua horizontal apenas, cabeçalho
discreto alinhado à esquerda, nenhuma linha vertical. Coluna se separa
por espaço, não por tinta.

``` r

dados <- data.frame(
  atividade = c("Coleta seletiva", "Varrição manual", "Varrição mecanizada"),
  valor     = c(54549, 1067450, 213081)
)

dados |>
  tabela_gt(
    titulo    = "Quantitativos de 2025",
    subtitulo = "Últimos valores publicados",
    nota      = "Fonte: *relatórios anuais do SLU/DF*."
  ) |>
  fmt_br(valor)
```

| Quantitativos de 2025                 |           |
|---------------------------------------|-----------|
| Últimos valores publicados            |           |
| atividade                             | valor     |
| Coleta seletiva                       | 54.549    |
| Varrição manual                       | 1.067.450 |
| Varrição mecanizada                   | 213.081   |
| Fonte: *relatórios anuais do SLU/DF*. |           |

Três coisas que parecem detalhe e não são:

- **`tabular-nums`** entra no CSS da tabela. Sem isso as casas decimais
  não alinham na vertical e a coluna de número fica tremida.
- **Sem moldura.** A tabela flutua no texto em vez de virar caixa.
- **A coluna numérica sai em mono**, e o resto em sans. *Sans é
  discurso, mono é medida* — a fronteira é semântica, não estética.

### O `gt` não herda a página

Este foi o defeito mais caro que a 0.3.0 corrigiu. Até a 0.2.0
[`tabela_gt()`](https://theoadepaula.github.io/theoviz/reference/tabela_gt.md)
não dizia **uma cor sequer**. Parecia elegância — “a tabela herda a
página” — e era o oposto: sem instrução, o `gt` crava
`background-color: #FFFFFF` com texto `#333333`, *inline*, e nenhum
`custom.scss` derruba estilo inline.

Como toda página do site é escura, toda tabela de todo artigo ia ao ar
como um retângulo branco no meio do texto.

A mesma tabela no modo escuro, apresentada aqui sobre o chão para o qual
ela foi feita — esta vignette tem fundo claro, e uma tabela transparente
com tinta clara por cima seria invisível nele. É o mesmo argumento, na
direção inversa:

``` r

dados |>
  tabela_gt(titulo = "Quantitativos de 2025", modo = "escuro") |>
  fmt_br(valor)
```

| Quantitativos de 2025 |           |
|:----------------------|----------:|
| atividade             |     valor |
| Coleta seletiva       |    54.549 |
| Varrição manual       | 1.067.450 |
| Varrição mecanizada   |   213.081 |

**Escolha o `modo` pela página em que a tabela vai cair:**

- `"escuro"` — fundo **transparente** e tintas do site. A tabela pousa
  na página em vez de recortar uma chapa dentro dela; é a mesma escolha
  já feita nos gráficos plotly. É o modo do que vai ao ar.
- `"claro"` (padrão) — superfície clara explícita, para impressão, slide
  e PDF. **Não** é transparente de propósito: tinta escura sobre
  transparente seria ilegível justamente na página escura em que os
  artigos vivem.

O padrão continua `"claro"` porque virá-lo restilizaria de uma vez todos
os artigos ainda não congelados, deixando o site com dois estilos ao
mesmo tempo. Passar ao escuro é decisão de publicação de cada projeto —
ver a última seção.

E a regra que dá sentido ao pacote: **não reimplemente o layout dentro
do projeto.** Foi exatamente assim que os três divergiram. Mudou o
estilo? Muda aqui, sobe a versão.

## Números

``` r

num_br(1234567)
#> [1] "1.234.567"
num_br(33.126, dec = 2)
#> [1] "33,13"
pct_br(33.126)
#> [1] "33,1%"
mil(137063)
#> [1] "137"
```

Usa [`formatC()`](https://rdrr.io/r/base/formatc.html), não
[`format()`](https://rdrr.io/r/base/format.html). A diferença não é
cosmética: [`format()`](https://rdrr.io/r/base/format.html) alinha o
vetor inteiro a uma largura comum, então o número curto sai com espaço
na frente — que aparece calado no meio de uma frase de artigo. Duas das
três implementações antigas tinham esse defeito, contornado com
`trim = TRUE`.

## Como um projeto adota

Cada projeto carrega o pacote no seu arquivo de tema e dá um **alias
local**, para não mexer nos `.qmd` já escritos:

``` r

library(theoviz)

tabela <- tabela_gt        # relatorios-slu, cargos-executivo-federal
tabela_amb <- tabela_gt    # anuario-mineral-brasileiro
```

E constrói o tema de ggplot **sobre** a paleta, em vez de repetir
hexadecimais:

``` r

tema_projeto <- function(modo = "escuro") {
  ggplot2::theme_minimal() +
    ggplot2::theme(
      text        = ggplot2::element_text(colour = tinta("media", modo = modo)),
      panel.grid  = ggplot2::element_line(colour = tinta("grade", modo = modo)),
      plot.background = ggplot2::element_rect(fill  = tinta("fundo", modo = modo),
                                              colour = NA)
    )
}
```

## O que este pacote deliberadamente não tem

**Tema de ggplot.** Parecia candidato óbvio, mas os projetos divergem
por motivos reais: um pinta superfície de fundo e mostra grade só no
eixo Y; outro não pinta fundo e mostra as duas grades; um terceiro usa
plotly, para o qual um tema ggplot não serve de nada. Unificar exigiria
parametrizar até o ponto em que o pacote não decide mais nada — e um
pacote que não decide nada não elimina duplicação, só a move.

**Helpers de interatividade.** Eles codificam decisões de cada projeto:
o que acende no hover, o que o tooltip mostra. Isso é desenho de
interação, não identidade visual.

**Tipografia, espaçamento e forma.** O
[`site()`](https://theoadepaula.github.io/theoviz/reference/site.md)
traz só cor. Raio zero, sombra zero e a escala de espaçamento vivem no
CSS do site, onde são aplicáveis; do lado do R não teriam uso.

A fronteira do pacote é essa: **o que era idêntico entre projetos entra;
o que diverge por razão legítima, ou não tem uso do lado do R, fica
fora.**

## O risco que sobra: divergir no tempo

O site renderiza os artigos com `freeze`. Um artigo já congelado **não**
re-renderiza quando este pacote muda — então uma alteração de layout
faria o site exibir dois estilos ao mesmo tempo, os artigos novos com o
novo e os antigos com o antigo.

A cura, a cada mudança que afete layout:

``` bash
rm -rf quarto/_freeze      # sem apagar, o freeze devolve a execucao antiga
npm run build:quarto
```

É o problema antigo com outro eixo. Antes, três cópias divergiam no
**espaço**; agora, uma fonte só pode divergir no **tempo**.
