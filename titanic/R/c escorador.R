load("RData/titanic.RData")
load("RData/model01.RData")
load("RData/model02.RData")

titanic_predicted <- titanic %>% 
  mutate(score_model01 = predict(model01, newdata = ., type = "prob")$yes,
         score_model02 = predict(model02, newdata = ., type = "prob")$yes)

save(titanic_predicted, file = "RData/titanic_predicted.RData")
