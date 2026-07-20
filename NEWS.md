# theoviz 0.2.0

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
