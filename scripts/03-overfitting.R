library(tidyverse)
library(caret)
set.seed(5893524)
theme_set(theme_minimal())

# Criando banco de dados --------------------------------------------------

criar_amostra <- function(n) {
  tibble(
    x = runif(n, 0, 20),
    y = 500 + 0.4 * (x-10)^3 + rnorm(n, sd = 50)
  )
}

df <- criar_amostra(10)

ggplot(df, aes(x = x, y = y)) +
  geom_point()


# Ajustando modelo linear -------------------------------------------------

modelo <- train(y ~ x, data = df, method = "lm")

ggplot(df, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

df %>% 
  mutate(predicao = predict(modelo, df)) %>% 
  summarise(rmse = sqrt(mean((predicao - y)^2)))

# Ajustando modelo quadrático ---------------------------------------------

modelo <- train(y ~ poly(x, 2), data = df, method = "lm")

ggplot(df, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), se = FALSE, color = "orange")

df %>% 
  mutate(predicao = predict(modelo, df)) %>% 
  summarise(rmse = sqrt(mean((predicao - y)^2)))

# Ajustando modelo cúbico -------------------------------------------------

modelo <- train(y ~ poly(x, 3), data = df, method = "lm")

ggplot(df, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ poly(x, 3), se = FALSE, color = "green")

df %>% 
  mutate(predicao = predict(modelo, df)) %>% 
  summarise(rmse = sqrt(mean((predicao - y)^2)))


# Ajustando modelo de grau 9 ---------------------------------------------

modelo <- train(y ~ poly(x, 9, raw = TRUE), data = df, method = "lm")

ggplot(df, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ poly(x, 9, raw = TRUE), se = FALSE, color = "red")

df %>% 
  mutate(predicao = predict(modelo, df)) %>% 
  summarise(rmse = sqrt(mean((predicao - y)^2)))

modelo$finalModel


# Resumo ------------------------------------------------------------------

calcula_erros_treino <- function(df, grau) {
  
  erros <- tibble(grau = NA, rmse = NA)
  
  for(g in grau) {
    
    modelo <- lm(y ~ poly(x, g, raw = TRUE), data = df)
    
    erro <- df %>% 
      mutate(predicao = predict(modelo, df)) %>% 
      summarise(rmse = sqrt(mean((predicao - y)^2))) %>%
      .$rmse
      
    erros <- rbind(erros, c(g, erro))
  }
  
  na.omit(erros)
}

calcula_erros_treino(df, grau = 1:9)


# Uma nova base -----------------------------------------------------------

nova_base <- criar_amostra(100)

# Grau 1
ggplot(df, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  geom_point(data = nova_base, color = "gray")

# Grau 3
ggplot(df, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ poly(x, 3), se = FALSE, color = "green") +
  geom_point(data = nova_base, color = "gray")

# Grau 9
ggplot(df, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ poly(x, 9), se = FALSE, color = "red") +
  geom_point(data = nova_base, color = "gray")

# Erros na nova base

calcula_erros_teste <- function(df, nova_base, grau) {
  
  erros <- tibble(grau = NA, rmse = NA)
  
  for(g in grau) {
    
    modelo <- lm(y ~ poly(x, g, raw = TRUE), data = df)
    
    erro <- nova_base %>% 
      mutate(predicao = predict(modelo, nova_base)) %>% 
      summarise(rmse = sqrt(mean((predicao - y)^2))) %>%
      .$rmse
    
    erros <- rbind(erros, c(g, erro))
  }
  
  na.omit(erros)
}

calcula_erros_teste(df, nova_base, grau = 1:9)

# Ajustando na nova base

modelo <- train(y ~ poly(x, 9, raw = TRUE), data = nova_base, method = "lm")

ggplot(nova_base, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ poly(x, 9, raw = TRUE), se = FALSE, color = "red")

df %>% 
  mutate(predicao = predict(modelo, df)) %>% 
  summarise(rmse = sqrt(mean((predicao - y)^2)))

modelo$finalModel

# Exercício ---------------------------------------------------------------

# Coloque a data do seu nascimento
# Por exemplo, 29/07/1989
semente <- 29071989

criar_amostra <- function(n, semente) {
  set.seed(semente)
  tibble(
    x = runif(n, 0, 3),
    p = 1/(1 + exp(-(2.5 - x^sample(1:5, 1) + rnorm(n, 0, 8)))),
    y = as.numeric(rbernoulli(n, p = p))
  )
}

# Base
df <- criar_amostra(10000, semente)

# Frequência
count(df, y)

# Relação entre x e y
df %>% 
  ggplot(aes(x = x, y = y)) +
  geom_point(alpha = 0.01)

# Base de treino e de teste
df <- df %>% 
  mutate(
    base = sample(
      c("treino", "teste"), 
      size = nrow(df), 
      replace = TRUE, 
      prob = c(0.7, 0.3)
    )
  )

df_treino <- df %>% filter(base == "treino")
df_teste <- df %>% filter(base == "teste")

# calcula_erros_teste <- function(df, nova_base, grau) {
#   
#   acc <- tibble(grau = NA, acc = NA)
#   
#   for(g in grau) {
#     
#     modelo <- glm(y ~ poly(x, g, raw = TRUE), data = df, family = binomial)
#     
#     prop <- nova_base %>% 
#       mutate(
#         predicao = predict(modelo, nova_base, type = "response"),
#         predicao = ifelse(predicao > 0.5, 1, 0),
#         acerto = ifelse(predicao == y, 1, 0)
#       ) %>% 
#       summarise(prop_acerto = mean(acerto)) %>%
#       .$prop_acerto
#     
#     acc <- rbind(acc, c(g, prop))
#   }
#   
#   na.omit(acc)
# }
# 
# calcula_erros_teste(df = df_treino, nova_base = df_teste, grau = 1:5)
