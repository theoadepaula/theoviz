# Contraste WCAG, calculado -- nao copiado de um relatorio ---------------------
#
# Ate a 0.2.0 os numeros de contraste viviam so em comentario e em README: eram
# medicoes feitas uma vez, com uma ferramenta de fora, e depois transcritas. Isso
# funciona ate a primeira vez que alguem troca uma cor e esquece de remedir -- e
# o comentario passa a mentir com toda a autoridade de um numero.
#
# Aqui a conta e refeita a cada `R CMD check`. Se um valor de cor mudar, o teste
# recalcula e o piso e cobrado de novo. E a mesma logica dos testes que travam os
# hexadecimais: a pergunta certa depois de trocar uma cor nao e "como faco o
# teste passar", e sim "revalidei o contraste?".
#
# A formula e a da WCAG 2.1 (relative luminance), e vale so para contraste
# claro/escuro. A separacao entre duas cores SOB DALTONISMO e outra medida
# (DeltaE em espaco perceptual, com simulacao de protanopia/deuteranopia/
# tritanopia); essa continua vindo do validador do skill `dataviz`, e os
# resultados estao registrados em R/paleta.R com data.

luminancia <- function(hex) {
  v <- grDevices::col2rgb(hex)[, 1] / 255
  v <- ifelse(v <= 0.03928, v / 12.92, ((v + 0.055) / 1.055)^2.4)
  sum(c(0.2126, 0.7152, 0.0722) * v)
}

contraste <- function(a, b) {
  l <- sort(c(luminancia(a), luminancia(b)), decreasing = TRUE)
  (l[1] + 0.05) / (l[2] + 0.05)
}

# Arredonda como se le num relatorio, para o teste poder afirmar o numero que
# esta escrito na documentacao.
contraste_r <- function(a, b) round(contraste(a, b), 2)
