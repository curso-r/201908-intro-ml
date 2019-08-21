load("RData/titanic.RData")
load("RData/titanic_receita.RData")

train_control_model01 <- trainControl(
  method = "cv",
  number = 5,
  verboseIter = TRUE,
  summaryFunction = twoClassSummary,
  classProbs = TRUE
)

tune_grid_model01 <- expand.grid(
  alpha = c(0, 0.5, 1),
  lambda = 10^(0:10)
)

model01 <- train(
  titanic_receita,
  titanic %>% filter(base %in% "train"),
  tuneGrid = tune_grid_model01,
  trControl = train_control_model01,
  method = "glmnet",
  family = "binomial",
  metric = "ROC"
)

# rascunho de exploracao do modelo -----------------------------------------------------------------



save(model01, file = "RData/model01.RData")
