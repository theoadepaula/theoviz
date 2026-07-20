# theoviz

Identidade visual compartilhada dos projetos de dados abertos publicados em
[theoalbuquerque.com.br](https://theoalbuquerque.com.br).

Existe por um motivo específico: as mesmas cores, o mesmo estilo de tabela e a
mesma formatação numérica estavam **copiados em três projetos**, sob três nomes
diferentes. Eram idênticos byte a byte — o que só se descobriu ao compará-los,
em 2026-07-19. Três cópias divergem; um pacote, não.

```r
# instalar
pak::pak("theoadepaula/theoviz")
# ou
remotes::install_github("theoadepaula/theoviz")
```

## O que tem dentro

### Paleta — `paleta()`, `tinta()`, `grade_rgba()`

Quatro cores de série, **validadas para daltonismo** (protanopia, deuteranopia,
tritanopia): pior par adjacente com ΔE 17,6 em protanopia, contra um piso de 8.

```r
paleta()
#>        s1        s2        s3        s4
#> "#2a78d6" "#008300" "#e87ba4" "#eda100"
```

> ⚠️ **A ordem dos slots faz parte da validação.** Usar `s1` e `s3` em duas
> séries é seguro; trocar `s2` por uma cor "parecida" não é. Há um teste que
> trava os valores exatos — mudá-los exige mudar o teste também, para que a
> troca seja deliberada e revalidada.

**Limite conhecido:** o magenta (`s3`) fica abaixo de 3:1 de contraste sobre
fundo branco. Daí a regra que acompanha esta paleta: **todo gráfico traz rótulo
direto na ponta da série**, além da legenda. Identidade de série nunca depende
só de cor.

`tinta()` traz os neutros (texto, grade, eixo, fundo) — separados das cores de
série porque nunca codificam dado, só estrutura. `grade_rgba()` devolve a grade
com alfa, que o plotly precisa para o fundo transparente do tema escuro do site.

### Tabelas — `tabela_gt()`, `fmt_br()`, `fmt_pct_br()`

O tema canônico das tabelas `gt`, aprovado em 2026-07-19. Em uma frase: régua
horizontal apenas, cabeçalho discreto alinhado à esquerda, nenhuma linha
vertical. Coluna se separa por espaço, não por tinta.

```r
dados |>
  tabela_gt(titulo = "Atividades que somem da série histórica",
            nota   = "Fonte: *relatórios anuais*.") |>
  fmt_br(valor, decimais = 1)
```

Saída crua de tibble em `<pre>` não vai ao ar. E **não reimplemente o layout no
projeto** — foi assim que os três divergiram antes. Mudou o estilo? Muda aqui.

### Números — `num_br()`, `pct_br()`, `mil()`

Milhar com ponto, decimal com vírgula.

```r
num_br(1234567)          #> "1.234.567"
num_br(33.126, dec = 2)  #> "33,13"
pct_br(33.126)           #> "33,1%"
mil(137063)              #> "137"
```

> Usa `formatC()`, não `format()`. Com `format()` o vetor inteiro é alinhado a
> uma largura comum, e o número curto sai com espaço na frente — que aparece
> calado no meio de uma frase do artigo. Duas das três implementações antigas
> tinham esse defeito, contornado com `trim = TRUE`.

## O que deliberadamente **não** tem

**O tema ggplot.** Parecia candidato óbvio, mas os dois projetos que usam ggplot
divergem por motivos reais: o Cargos pinta uma superfície de fundo e mostra
grade só no eixo Y; o Anuário não pinta fundo e mostra as duas grades. E o
terceiro projeto usa plotly, para o qual um tema ggplot não serve de nada.
Unificar exigiria parametrizar até o ponto em que o pacote não decide mais nada.

Cada projeto mantém seu `tema_*()` local, construído **sobre** `paleta()` e
`tinta()` — que é onde estava a duplicação de verdade.

**Helpers de interatividade.** `girafe_cargos()`, `interativo()` e `grafico()`
codificam decisões de cada projeto (o que acende no hover, o que o tooltip
mostra). Não são identidade visual; são desenho de interação.

## Onde é usado

| Projeto | Arquivo de tema | Alias local |
|---|---|---|
| `cargos-executivo-federal` | `artigos/_tema.R` | `tabela()` |
| `relatorios-slu` | `code/tema_visual.R` | `tabela()` |
| `anuario-mineral-brasileiro` | `code/tema.R` | `tabela_amb()` |

Os aliases existem para não mexer nos `.qmd` já escritos.

## Cuidado: pacote e `freeze` divergem no tempo

O site renderiza os artigos com `freeze`, então **um artigo já congelado não
re-renderiza quando este pacote muda**. Uma alteração de layout faria o site
exibir dois estilos ao mesmo tempo — os artigos novos com o novo, os antigos com
o antigo.

A cura: a cada mudança que afete layout, subir a versão no `DESCRIPTION` e rodar
uma vez, no repo do site:

```bash
quarto render quarto --no-freeze
```

É o problema antigo com outro eixo. Antes, três cópias divergiam no espaço;
agora, uma fonte só pode divergir no tempo.

## Desenvolvimento

```bash
R CMD INSTALL .
Rscript -e 'testthat::test_dir("tests/testthat")'
```

Os testes travam os valores exatos da paleta e das tintas de propósito. Se um
deles quebrar depois de uma mudança de cor, a pergunta certa não é "como faço o
teste passar" — é "revalidei o contraste?".
