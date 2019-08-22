titanic_train <- read_csv("csv/train.csv")
titanic_test <- read_csv("csv/test.csv")

glimpse(titanic_train)

aplica_dataprep <- function(data) {
  data %>%
    mutate(
      Survived = factor(if_else(Survived == 1, 'yes', 'no')),
      pronoun = str_extract(Name, ", [A-Za-z]+\\.? ") %>% str_extract("[A-Za-z]+"),
      pronoun_v2 = pronoun %>% fct_lump(5, other_level = "Rare pronoun"),
      flag_parenteses = if_else(str_detect(Name, "[\\(\\)]"), 1, 0),
      flag_quotes = if_else(str_detect(Name, '[\\"\\"]'), 1, 0),
      Embarked = if_else(is.na(Embarked), "S", Embarked),
      # ticket_prefix = str_sub(Ticket, end = -4),
      flag_has_cabin = if_else(is.na(Cabin), 0, 1)
    ) %>%
    select(
      base,
      PassengerId,
      Survived,
      
      pronoun_v2,
      Pclass,
      flag_parenteses,
      flag_quotes,
      Embarked,
      SibSp,
      Parch,
      Fare,
      flag_has_cabin,
      # ticket_prefix,
      Age,
      Sex
    )
}


titanic <- bind_rows(
  titanic_train %>% mutate(base = "train"),
  titanic_test %>% mutate(base = "test")
) %>% 
  aplica_dataprep()

# receita
titanic_receita <- recipe(
  formula = Survived ~ ., 
  data = titanic %>% filter(base %in% "train")
) %>%
  step_medianimpute(Fare) %>%
  step_log(Fare, offset = 1) %>% # log(0 + 1)
  step_modeimpute(Embarked) %>%
  step_dummy(pronoun_v2, Embarked, Sex) %>%
  step_bagimpute(Age, impute_with = imp_vars(starts_with("pronoun_v2"))) %>%
  step_center(Fare, Age, Parch, SibSp) %>%
  step_scale(Fare, Age, Parch, SibSp) %>%
  update_role(PassengerId, new_role = "id variable") %>%
  update_role(base, new_role = "splitting variable")

# olhando a base com prep() + juice()
titanic_receita_preparada <- prep(titanic_receita, data = titanic)

titanic_ok <- juice(titanic_receita_preparada)

glimpse(titanic_ok)
skimr::skim(titanic)

# guardando objetos importantes
save(titanic, file = "RData/titanic.RData")
save(titanic_receita, file = "RData/titanic_receita.RData")








