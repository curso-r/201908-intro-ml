load("RData/titanic_predicted.RData")

# ESSA PARTE EH OPCIONAL

# sumario
resultados <- titanic_predicted %>%
  filter(base %in% "train") %>% # o meu verdadeiro testador eh o Kaggle neste caso. Senão eu deixaria o "test"
  mutate(base = if_else(runif(n()) > 0.7, "test", "train")) %>% # só de mentirinha para ilustrar.
  select(base, Survived, starts_with("score")) %>%
  gather(modelo, score, starts_with("score")) %>%
  group_by(base, modelo) %>%
  nest %>%
  mutate(
    roc = map(data, ~ AUC::roc(.x$score, .x$Survived)),
    auc = map_dbl(roc, AUC::auc),
    gini = map_dbl(data, ~MLmetrics::Gini(.x$score, as.numeric(.x$Survived) - 1))
  )

resultados

# graficos para o chefe
resultados %>%
  select(-data, -roc) %>%
  gather(metrica, valor, auc, gini) %>%
  ggplot(aes(x = modelo, y = valor, colour = base, fill = base)) +
  # geom_col(position = "dodge") +
  geom_point() +
  geom_line(aes(group = base)) +
  facet_wrap(~metrica, scales = "free")



roc_plot <- resultados %>%
  select(base, modelo, roc) %>%
  mutate(
    roc = map(roc, ~{
      .x %>% 
        unclass %>% 
        as.data.frame
    })
  ) %>%
  unnest %>%
  ggplot(aes(x = fpr, y = tpr, colour = modelo, label = cutoffs)) +
  geom_line() +
  geom_abline(colour = "grey50") +
  theme_minimal() +
  coord_fixed() +
  facet_wrap(~base)

plotly::ggplotly(roc_plot)
