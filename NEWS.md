# theoviz 0.3.0

**O pacote passa a acompanhar o sistema visual do site.**

Em 2026-08-09 o site trocou de direção visual: saiu *"A Sala de Leitura
Noturna"* (fundo `#0f172a`, acento azul `#0085ff`, Inter, raio 0,5rem, sombra no
hover) e entrou **"O Boletim Técnico"** — fundo quase preto, acento areia único,
IBM Plex Sans + Mono, raio zero, sombra zero.

O `theoviz` seguia calibrado para o sistema aposentado. Esta versão fecha essa
distância.

## 🔴 Correção: a tabela branca no meio da página escura

`tabela_gt()` **não dizia uma cor sequer**. Parecia elegância — "a tabela herda
a página" — e era o oposto: o `gt` não herda nada. Sem instrução ele crava
`background-color: #FFFFFF` com texto `#333333`, *inline*, e nenhum
`custom.scss` derruba estilo inline.

Como toda página do site é escura, **toda tabela de todo artigo ia ao ar como um
retângulo branco no meio do texto.**

```r
tabela_gt(dados, modo = "escuro")   # novo argumento
```

- `"escuro"` — fundo **transparente** e tintas do site. A tabela pousa na página
  em vez de recortar uma chapa dentro dela. É a mesma escolha já feita nos
  gráficos plotly do SLU (`paper_bgcolor = "rgba(0,0,0,0)"`), pelo mesmo motivo.
- `"claro"` (padrão) — superfície clara explícita, para impressão, slide e PDF.
  **Não** é transparente de propósito: tinta escura sobre transparente seria
  ilegível justamente na página escura em que os artigos vivem.

Há teste garantindo que `#FFFFFF` e `#333333` não voltam calados.

## Novo: `site()` e `acento()`

Os tokens de cor da direção "Boletim Técnico", espelhados do bloco `@theme` de
`src/styles/global.css`.

```r
site("noite")    #> "#0d1014"   -- o chão da página
site("filete")   #> "#2c333c"   -- grade e base de eixo
acento()         #> "#cfae72"   -- o areia, único acento do sistema
```

**Sim, isto é uma cópia** — e cópia é o que este pacote existe para eliminar. A
diferença é que agora há **uma**, datada, com a fonte escrita, e um teste que a
confere contra o CSS do site quando o repo está na máquina. Antes havia três, e
cada projeto inventava o seu próprio cinza: o `relatorios-slu` chegou a cravar
`TINTA_2 <- "#8a8a85"` com o comentário *"não é o `tinta('fraca')` do
theoviz"*. Era esse o sintoma.

**A regra que `acento()` carrega:** uma série usa o acento; duas ou mais usam
`paleta()`, na ordem dos slots. O areia **não entra na paleta categórica** —
não foi validado para daltonismo contra os quatro slots, e o sistema do site o
reserva para ação e estado ativo. Não há meio-termo: três séries com uma delas
em areia mistura dois vocabulários.

Fica de fora tipografia, espaçamento e forma. Isso é do CSS do site e não tem
uso do lado do R.

## As tintas do modo escuro foram rebaseadas

Eram cinzas **quentes** herdados do sistema anterior. O Boletim é um sistema
**frio**, e cinza quente sobre página fria não lê como neutro discreto — lê como
figura recortada de outro documento.

| tinta | antes | agora | token do site |
|---|---|---|---|
| `forte` | `#ffffff` | `#dde1e6` | `titulo` |
| `media` | `#c3c2b7` | `#a9b0b8` | `leitura` |
| `fraca` | `#898781` | `#7d858e` | `rotulo` |
| `grade` | `#2c2c2a` | `#2c333c` | `filete` |
| `eixo` | `#383835` | `#2c333c` | `filete` |
| `fundo` | `#1a1a19` | `#0d1014` | `noite` |

⚠️ **`tinta("forte", modo = "escuro")` deixou de ser branco puro.** O site
proíbe `#ffffff` sobre este fundo por razão específica: ele vibra. Há teste
cobrando isso.

⚠️ **`tinta("fraca")` deixou de ser a mesma nos dois modos.** Era, até a 0.2.0:
`#898781` servia claro e escuro. O Boletim tem um piso próprio, medido contra o
fundo e contra a chapa.

⚠️ **`grade` e `eixo` agora são o mesmo valor no escuro.** O site usa um filete
só para os dois. No modo claro seguem distintos — o claro não foi rebaseado.

`grade_rgba()` continua existindo, com o papel redefinido: é o recurso de **chão
desconhecido**, para quando a figura não sabe sobre o que vai pousar. Sabendo,
prefira a grade sólida.

## ✅ As cores de série não mudaram

O resultado limpo desta versão. ΔE entre as cores não depende do fundo, e o
contraste contra o chão só **melhorou** — `#0d1014` é mais escuro que o
`#1a1a19` de antes:

| | `s1` | `s2` | `s3` | `s4` |
|---|---|---|---|---|
| contraste vs `#0d1014` | 5,24 | 3,86 | 4,83 | 6,21 |
| contraste vs `#141920` (chapa) | 4,85 | 3,57 | 4,47 | 5,75 |

Os quatro passam de 3:1 sobre as duas superfícies. **Nenhum projeto precisa
mexer numa linha por causa disso.**

## Coluna numérica sai em mono

> "Sans é discurso, Mono é medida. A fronteira é semântica, não estética."
> — a Regra das Duas Vozes, `DESIGN.md` do site

`tabela_gt()` aplica IBM Plex Mono às colunas numéricas e IBM Plex Sans ao
resto. O `tabular-nums` já estava aqui desde a 0.1.0 e resolvia metade do
problema — alinhava os algarismos, mas deixava o número na voz da prosa.

## Contraste recalculado, não transcrito

Até a 0.2.0 os números de contraste viviam em comentário e no README: medições
feitas uma vez, com ferramenta de fora, depois transcritas. Isso funciona até a
primeira vez que alguém troca uma cor e esquece de remedir — e o comentário
passa a mentir com toda a autoridade de um número.

`tests/testthat/helper-contraste.R` implementa a luminância relativa da WCAG
2.1, e a conta é refeita a cada `R CMD check`. A separação sob daltonismo (ΔE em
espaço perceptual) continua vindo do validador do skill `dataviz`, registrada
com data no código.

**Teste de deriva:** `test-site.R` lê o `global.css` do repo do site, quando ele
está na máquina, e confere os 14 tokens um a um. Cópia envelhece calada; esta
não.

## Documentação

- **Site pkgdown** — <https://theoadepaula.github.io/theoviz/>, com tema casado
  com o Boletim (fundo `#0d1014`, acento areia, IBM Plex, raio zero). Construído
  e publicado pelo workflow `pkgdown.yaml` a cada push na `main`; o `docs/` não
  é versionado.
- **Figuras no README** — `data-raw/figuras.R` gera as três imagens a partir dos
  valores reais do pacote: os hexadecimais e os contrastes que aparecem nelas são
  calculados na hora, não digitados.

## Recado para quem cuida dos projetos

Esta versão **é retrocompatível no modo claro**: sem argumento, `paleta()`,
`tinta()` e `tabela_gt()` devolvem exatamente o que devolviam na 0.2.0. Só o
modo escuro mudou de valores.

O padrão segue `"claro"` de propósito. Virá-lo restilizaria de uma vez todos os
artigos ainda não congelados e deixaria o site com dois estilos ao mesmo tempo.
Passar ao escuro é decisão de publicação de cada projeto, tomada junto com
`quarto render quarto --no-freeze`.

Fica pendente, e não é meu para fazer:

1. **Migrar os três projetos para `modo = "escuro"`**, um de cada vez. Os três
   hoje chamam `paleta()` e `tinta()` no claro enquanto renderizam em páginas
   escuras.
2. **`relatorios-slu`** — apagar o `TINTA_2 <- "#8a8a85"` local e usar
   `tinta("fraca", modo = "escuro")`.
3. **`cargos-executivo-federal`** — o `_tema.R` pinta `surface = "#fcfcfb"`,
   uma superfície quase branca dentro de uma página escura.
4. **Rodar `quarto render quarto --no-freeze`** no site depois de cada migração.

---

# theoviz 0.2.0

## Documentação e infraestrutura de pacote

O `R CMD check` acusava um WARNING: **nenhuma das nove funções exportadas tinha
página de ajuda**. Havia blocos roxygen no código, mas o `man/` nunca fora
gerado e o `NAMESPACE` era mantido à mão. `?paleta` não funcionava depois de
instalado.

- **`man/` gerado por roxygen2**, e o `NAMESPACE` passa a ser gerado junto —
  não edite mais os dois à mão. `Roxygen: list(markdown = TRUE)` no
  `DESCRIPTION`, que os blocos já assumiam.
- **`?theoviz`** — página de visão geral com as três famílias de funções, a
  fronteira do pacote e o aviso do `freeze`.
- **`vignette("theoviz")`** — o passo a passo com o raciocínio: por que a paleta
  é mecanismo de segurança e não escolha estética, por que o limite de contraste
  do `s3` vira a regra do rótulo direto, e por que tema de ggplot ficou de fora.
- **CI** (`.github/workflows/R-CMD-check.yaml`) — check em Ubuntu e Windows a
  cada push e PR. Como os testes travam os valores de cor de propósito, o CI faz
  a pergunta "revalidei o contraste?" aparecer **no PR**, não depois do merge.
- **`.Rbuildignore`** (não existia) e `.gitignore` cobrindo artefatos de build.
- `DESCRIPTION`: `Depends: R (>= 4.1)`, `BugReports`, `Language: pt-BR`,
  `VignetteBuilder`.

`R CMD check --as-cran` agora passa limpo. Sobram um NOTE de "New submission",
que só vale para CRAN, e um WARNING de `qpdf` ausente, que é ferramenta da
máquina e não defeito do pacote.

## Modo escuro na paleta

`paleta()` e `tinta()` agora aceitam `modo = "escuro"`.

```r
paleta(modo = "escuro")
#>        s1        s2        s3        s4
#> "#3987e5" "#008300" "#d55181" "#c98500"

tinta("fundo", modo = "escuro")
#> "#1a1a19"
```

**Retrocompatível.** Sem argumento, as duas funções devolvem exatamente o que
devolviam na 0.1.0 — há teste garantindo que `paleta()` é idêntica a
`paleta(modo = "claro")`.

### Por que existe

O painel do projeto *cargos-executivo-federal* precisa dos dois modos, porque o
site é escuro e um painel que não acompanha vira um retângulo branco no meio da
página. Os valores escuros já estavam **cravados no template HTML daquele
projeto** — exatamente o tipo de cópia que este pacote existe para eliminar.
Agora moram aqui, e o projeto os injeta no CSS a partir daqui.

### O que foi validado, e o que não passou

Os passos escuros não são clareamento automático do claro: foram validados
contra a superfície escura (`#1a1a19`) com o validador do skill `dataviz`, em
2026-07-19.

| | pior par adjacente | contraste vs superfície |
|---|---|---|
| claro (`#fcfcfb`) | ΔE 16,3 (deutan) | `s3` 2,62 e `s4` 2,11 — **abaixo de 3:1** |
| escuro (`#1a1a19`) | ΔE 13,0 (deutan) | os quatro **acima de 3:1** |

Resultado que contraria a intuição: **no escuro a paleta é mais segura em
contraste que no claro.** A regra do rótulo direto nasce do modo claro.

⚠️ **Limite novo, que precisa acompanhar o modo escuro:** olhando *todos* os
pares, e não só os adjacentes, `s2` × `s4` (verde × âmbar) cai para **ΔE 6,9 em
protanopia** — dentro da faixa 6–8, legal apenas com codificação secundária. Um
gráfico escuro que use somente esses dois slots precisa de rótulo direto ou
textura. Na ordem dos slots o problema não aparece.

---

## Recado para quem cuida dos projetos

Esta versão **só mexeu no `theoviz`**. Nada foi alterado nos três projetos, de
propósito — quem estiver trabalhando neles pode puxar a 0.2.0 sem conflito.

Fica pendente, e não é meu para fazer:

1. **`relatorios-slu`** — o painel HTML tem as cores escuras cravadas no
   template, como o do Cargos tinha. Pode passar a injetá-las de
   `paleta(modo = "escuro")` pelo script que monta o painel.
2. **Artigos em `plot_ly`** — se algum tema escuro de gráfico repetir esses
   hexadecimais à mão, agora tem de onde buscá-los.
3. **Rodar `quarto render quarto --no-freeze`** no site depois de subir a versão,
   senão artigos já congelados seguem com o estilo antigo. (Já estava no
   `CLAUDE.md`; vale lembrar a cada bump.)

Nada disso é urgente: a 0.1.0 continua funcionando, e a 0.2.0 não muda nenhum
valor existente.

---

# theoviz 0.1.0

Primeira versão. Paleta validada para daltonismo (`paleta()`, `tinta()`,
`grade_rgba()`), tema canônico das tabelas `gt` (`tabela_gt()`, `fmt_br()`,
`fmt_pct_br()`) e formatação numérica em pt-BR (`num_br()`, `pct_br()`, `mil()`).

Existe porque as mesmas cores, o mesmo estilo de tabela e a mesma formatação
estavam copiados em três projetos sob três nomes diferentes. Eram idênticos byte
a byte — o que só se descobriu ao compará-los.
