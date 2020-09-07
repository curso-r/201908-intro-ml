
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Configuração inicial

#### Passo 1: Instalar pacotes

``` r
install.packages("remotes")

# instalar pacote da Curso-R
remotes::install_github("curso-r/CursoR")

# instalar pacotes que vamos usar durante o curso
CursoR::instalar_dependencias()
```

#### Passo 2: Criar um projeto do RStudio

Faça um projeto do RStudio para usar durante todo o curso e em seguida
abra-o.

``` r
install.packages("usethis")
usethis::create_package("caminho_ate_o_projeto/nome_do_projeto")
```

#### Passo 3: Baixar o material

Certifique que você está dentro do projeto criado no passo 2 e rode o
código abaixo.

**Observação**: Assim que rodar o código abaixo, o programa vai pedir
uma escolha de opções. Escolha o número correspondente ao curso de
Introdução ao Machine Learning\!

``` r
# Baixar ou atualizar material do curso
CursoR::atualizar_material()
```

## Slides

| slide                                    | link                                                                              |
| :--------------------------------------- | :-------------------------------------------------------------------------------- |
| slides/00-intro-curso.html               | <https://curso-r.github.io/main-intro-ml/slides/00-intro-curso.html>              |
| slides/01-intro-ml.html                  | <https://curso-r.github.io/main-intro-ml/slides/01-intro-ml.html>                 |
| slides/03-modelos-de-arvores.html        | <https://curso-r.github.io/main-intro-ml/slides/03-modelos-de-arvores.html>       |
| slides/03-modelos-de-arvores\_cache/html | <https://curso-r.github.io/main-intro-ml/slides/03-modelos-de-arvores_cache/html> |
| slides/04-dataprep.html                  | <https://curso-r.github.io/main-intro-ml/slides/04-dataprep.html>                 |

## Scripts usados em aula

| script                         | link                                                                               |
| :----------------------------- | :--------------------------------------------------------------------------------- |
| 01-regressao-recipes-caret.Rmd | <https://curso-r.github.io/201908-intro-ml/scripts/01-regressao-recipes-caret.Rmd> |
| 02-regressao-logistica.Rmd     | <https://curso-r.github.io/201908-intro-ml/scripts/02-regressao-logistica.Rmd>     |
| 03-overfitting.R               | <https://curso-r.github.io/201908-intro-ml/scripts/03-overfitting.R>               |
| 04-lasso.Rmd                   | <https://curso-r.github.io/201908-intro-ml/scripts/04-lasso.Rmd>                   |
| 05-arvores-rf-xgboost.Rmd      | <https://curso-r.github.io/201908-intro-ml/scripts/05-arvores-rf-xgboost.Rmd>      |
| 06-diamonds.R                  | <https://curso-r.github.io/201908-intro-ml/scripts/06-diamonds.R>                  |
| 07-deploy.Rmd                  | <https://curso-r.github.io/201908-intro-ml/scripts/07-deploy.Rmd>                  |
| 08-desbalanceado.R             | <https://curso-r.github.io/201908-intro-ml/scripts/08-desbalanceado.R>             |
| modelo\_rf.RData               | <https://curso-r.github.io/201908-intro-ml/scripts/modelo_rf.RData>                |
