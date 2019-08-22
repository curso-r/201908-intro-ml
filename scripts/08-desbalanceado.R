# Baixar os dados: https://www.kaggle.com/mlg-ulb/creditcardfraud/downloads/creditcardfraud.zip/3

library(tidyverse)
library(caret)
library(recipes)

dados <- read_csv("~/Downloads/creditcard.csv")

dados <- dados %>% 
  mutate(Class = as.factor(Class)) %>% 
  sample_n(50000)

skimr::skim(dados)

# Criar a receita ---------------------------------------------------------

rec_sem_balancear <- recipe(Class ~ ., data = dados) %>% 
  step_center(all_predictors()) %>% 
  step_scale(all_predictors())
  
rec_upsample <- rec_sem_balancear %>% 
  step_upsample(Class)
  
rec_downsample <- rec_sem_balancear %>% 
  step_downsample(Class)


# Modelo ------------------------------------------------------------------

tc <- trainControl(
  method = "cv", 
  number = 5, 
  verboseIter = TRUE, 
  search = "grid"
)

modelo_sem_balancear <- rec_sem_balancear %>% 
  train(
    data = dados, 
    method = "ranger", 
    trControl = tc, 
    tuneLength = 2
  )

modelo_upsample <- rec_upsample %>% 
  train(
    data = dados, 
    method = "ranger", 
    trControl = tc, 
    tuneLength = 2
  )

modelo_downsample <- rec_downsample %>% 
  train(
    data = dados, 
    method = "ranger", 
    trControl = tc, 
    tuneLength = 2
  )


resamps <- resamples(
  list(
    SEM_BALANCEAR = modelo_sem_balancear, 
    UPSAMPLE = modelo_upsample, 
    DOWNSAMPLE = modelo_downsample
  )
)

dotplot(resamps)


