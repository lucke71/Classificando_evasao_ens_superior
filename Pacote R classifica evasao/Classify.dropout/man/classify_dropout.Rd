\name{classify_dropout}
\alias{classify_dropout}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Transforms dataframe and classifies data using multiple classifiers.
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
This function transforms data created by "create_dropout_database" and classifies dropout students according to the users choosing. 
}
\usage{
classify_dropout(database, cv_folds = 4, pct_training = 0.75, classificador = "CART", num_cores = 4, balanceamento = "")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{database}{
%%     ~~Describe \code{database} here~~
Dataframe that contains student data named according to "create_dropout_database"
}
  \item{cv_folds}{
%%     ~~Describe \code{cv_folds} here~~
Number of folds to be used in cross-validation. Only numbers greater than 0 (zero).
}
  \item{pct_training}{
%%     ~~Describe \code{pct_training} here~~
Percentage of the original database to be used for training the classifiers. Only numbers between 0 and 1 are accepted.
}
  \item{classificador}{
%%     ~~Describe \code{classificador} here~~
String contaning the name of classifier to be used. Options are "CART", "C45", "Nnet", "reglog", "NB" and "todos". See details.
}
  \item{num_cores}{
%%     ~~Describe \code{num_cores} here~~
Number of machine cores to be used. Only works when runnning R in a Unix system.
}
  \item{balanceamento}{
%%     ~~Describe \code{balanceamento} here~~
String containing the name of the technique to balance data. Options are "up", "down" and "". See details.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~

}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (database, cv_folds = 4, pct_training = 0.75, classificador = "CART", 
    num_cores = 4, balanceamento = "") 
{
    library(dplyr)
    library(caret)
    attr_nao_factor = c("vagas", "candidatos", "num_ies", "idade", 
        "ano_max", "ano_concluiu", "nu_nota_comp1", "nu_nota_comp2", 
        "nu_nota_comp3", "nu_nota_comp4", "nu_nota_comp5", "nu_nota_redacao", 
        "doc_exercicio", "doc_qualifcacao", "doc_exer_outro_org", 
        "doc_afastado_outro", "doc_falecido", "doc_graduacao", 
        "doc_especializacao", "doc_mestrado", "doc_doutorado", 
        "doc_integ_de", "doc_integ_sem_de", "doc_temp_parcial", 
        "doc_horista", "doc_brasileiro", "doc_brasileiro_nat", 
        "doc_estrangeiro")
    nao_factor_pos = sapply(attr_nao_factor, function(x) grep(paste0("^", 
        x, "$"), names(database)))
    nao_factor_pos = unlist(nao_factor_pos)
    var_factor = (1:ncol(database))[-nao_factor_pos]
    tira_espaco = function(x) gsub("^\\s+|\\s+$", "", x)
    val_branco = function(x) sub("^$", "branco", x)
    val_NA = function(x) ifelse(is.na(x), "branco", x)
    database[, var_factor] = lapply(database[, var_factor], tira_espaco)
    database[, var_factor] = lapply(database[, var_factor], val_branco)
    database[, var_factor] = lapply(database[, var_factor], val_NA)
    if (any(grepl("cod_municipio_residencia", names(database))) & 
        any(grepl("cod_municipio_nascimento", names(database))) & 
        any(grepl("cod_municipio_prova", names(database)))) {
        database = database \%>\% mutate(mun_nasc_dif_res = cod_municipio_nascimento != 
            cod_municipio_residencia)
        database = database \%>\% mutate(mun_res_dif_esc = cod_municipio_residencia != 
            cod_municipio_esc)
        database = database \%>\% mutate(mun_res_dif_prova = cod_municipio_residencia != 
            cod_municipio_prova)
        database = database \%>\% mutate(uf_res = substr(cod_municipio_residencia, 
            1, 2))
        database = database \%>\% mutate(uf_esc = substr(cod_municipio_esc, 
            1, 2))
        database = database \%>\% mutate(uf_nasc = substr(cod_municipio_nascimento, 
            1, 2))
        database = dplyr::select(database, -c(cod_municipio_residencia, 
            cod_municipio_esc, cod_municipio_prova, cod_municipio_nascimento))
    }
    if (any(grepl("ano_concluiu", names(database)))) {
        database$concluiu_ens_med = ifelse(is.na(database$ano_concluiu), 
            FALSE, TRUE)
        database$ano_concluiu[is.na(database$ano_concluiu)] = 0
    }
    nao_factor_pos = sapply(attr_nao_factor, function(x) grep(paste0("^", 
        x, "$"), names(database)))
    nao_factor_pos = unlist(nao_factor_pos)
    var_factor = (1:ncol(database))[-nao_factor_pos]
    database[, var_factor] = lapply(database[, var_factor], factor, 
        exclude = NULL)
    database = na.omit(database)
    nzv = nearZeroVar(database)
    database = database[, -nzv]
    fitcontrol = trainControl(method = "cv", number = cv_folds, 
        summaryFunction = twoClassSummary)
    if (Sys.info()[1] == "Linux") 
        library(doParallel)
    registerDoParallel(cores = num_cores)
    intraining = createDataPartition(database$evasao, p = pct_training, 
        list = FALSE)
    base_treina = database[intraining, ]
    base_teste = database[-intraining, ]
    if (balanceamento == "up") {
        up_data = upSample(x = dplyr::select(base_treina, -evasao), 
            y = base_treina$evasao, yname = "evasao")
    }
    if (balanceamento == "down") {
        dwn_data = downSample(x = dplyr::select(base_treina, 
            -evasao), y = base_treina$evasao, yname = "evasao")
    }
    if (classificador == "todos" | classificador == "NB") {
        if (balanceamento == "up") {
            naive_fit <<- train(x = dplyr::select(up_data, -evasao), 
                y = up_data$evasao, method = "nb", trControl = fitcontrol, 
                metric = "Spec")
        }
        else if (balanceamento == "down") {
            naive_fit <<- train(x = dplyr::select(dwn_data, -evasao), 
                y = dwn_data$evasao, method = "nb", trControl = fitcontrol, 
                metric = "Spec")
        }
        else {
            naive_fit <<- train(x = dplyr::select(base_treina, 
                -evasao), y = base_treina$evasao, method = "nb", 
                trControl = fitcontrol, metric = "Spec")
        }
        naive_pred <<- predict(naive_fit, base_teste)
        mc_naive <<- confusionMatrix(naive_pred, base_teste$evasao)
    }
    if (classificador == "todos" | classificador == "CART") {
        if (balanceamento == "up") {
            cart_fit <<- train(x = dplyr::select(up_data, -evasao), 
                y = up_data$evasao, method = "rpart", trControl = fitcontrol, 
                tuneLength = 10, maxdepth = 30, metric = "Spec")
        }
        else if (balanceamento == "down") {
            cart_fit <<- train(x = dplyr::select(dwn_data, -evasao), 
                y = dwn_data$evasao, method = "rpart", trControl = fitcontrol, 
                tuneLength = 10, maxdepth = 30, metric = "Spec")
        }
        else {
            cart_fit <<- train(x = dplyr::select(base_treina, 
                -evasao), y = base_treina$evasao, method = "rpart", 
                trControl = fitcontrol, tuneLength = 10, maxdepth = 30, 
                metric = "Spec")
        }
        cart_pred <<- predict(cart_fit, base_teste)
        mc_cart <<- confusionMatrix(cart_pred, base_teste$evasao)
    }
    if (classificador == "todos" | classificador == "C45") {
        if (balanceamento == "up") {
            c45_fit <<- train(x = dplyr::select(up_data, -evasao), 
                y = up_data$evasao, method = "J48", tuneLength = 10, 
                trControl = fitcontrol, metric = "Spec")
        }
        else if (balanceamento == "down") {
            c45_fit <<- train(x = dplyr::select(dwn_data, -evasao), 
                y = dwn_data$evasao, method = "J48", tuneLength = 10, 
                trControl = fitcontrol, metric = "Spec")
        }
        else {
            c45_fit <<- train(x = dplyr::select(base_treina, 
                -evasao), y = base_treina$evasao, method = "J48", 
                tuneLength = 10, trControl = fitcontrol, metric = "Spec")
        }
        c45_pred <<- predict(c45_fit, base_teste)
        mc_c45 <<- confusionMatrix(c45_pred, base_teste$evasao)
    }
    if (classificador == "todos" | classificador == "reglog") {
        if (balanceamento == "up") {
            if (any(grepl("co_curso", names(database)))) {
                base_log <<- dplyr::select(up_data, -co_curso)
            }
            else {
                base_log = up_data
            }
            reglog_fit <<- train(evasao ~ ., data = base_log, 
                method = "glm", family = binomial(link = "logit"), 
                trControl = fitcontrol, metric = "Spec")
        }
        else if (balanceamento == "down") {
            if (any(grepl("co_curso", names(database)))) {
                base_log <<- dplyr::select(dwn_data, -co_curso)
            }
            else {
                base_log = up_data
            }
            reglog_fit <<- train(evasao ~ ., data = base_log, 
                method = "glm", family = binomial(link = "logit"), 
                trControl = fitcontrol, metric = "Spec")
        }
        else {
            if (any(grepl("co_curso", names(database)))) {
                base_log <<- dplyr::select(base_treina, -co_curso)
            }
            else {
                base_log = up_data
            }
            reglog_fit <<- train(evasao ~ ., data = base_log, 
                method = "glm", family = binomial(link = "logit"), 
                trControl = fitcontrol, metric = "Spec")
        }
        reg_pred <<- predict(reglog_fit, base_teste)
        mc_reg <<- confusionMatrix(reg_pred, base_teste$evasao)
    }
    if (classificador == "todos" | classificador == "Nnet") {
        if (balanceamento == "up") {
            if (any(grepl("co_curso", names(database)))) {
                nnet_fit <<- train(x = dplyr::select(up_data, 
                  -c(evasao, co_curso)), y = up_data$evasao, 
                  method = "nnet", trControl = fitcontrol, metric = "Spec", 
                  maxit = 1000)
            }
            else {
                nnet_fit <<- train(x = dplyr::select(up_data, 
                  -evasao), y = up_data$evasao, method = "nnet", 
                  trControl = fitcontrol, metric = "Spec", maxit = 1000)
            }
        }
        else if (balanceamento == "down") {
            if (any(grepl("co_curso", names(database)))) {
                nnet_fit <<- train(x = dplyr::select(dwn_data, 
                  -c(evasao, co_curso)), y = dwn_data$evasao, 
                  method = "nnet", trControl = fitcontrol, metric = "Spec", 
                  maxit = 1000)
            }
            else {
                nnet_fit <<- train(x = dplyr::select(dwn_data, 
                  -evasao), y = dwn_data$evasao, method = "nnet", 
                  trControl = fitcontrol, metric = "Spec", maxit = 1000)
            }
        }
        else {
            if (any(grepl("co_curso", names(database)))) {
                nnet_fit <<- train(x = dplyr::select(base_treina, 
                  -c(evasao, co_curso)), y = base_treina$evasao, 
                  method = "nnet", trControl = fitcontrol, metric = "Spec", 
                  maxit = 1000)
            }
            else {
                nnet_fit <<- train(x = dplyr::select(base_treina, 
                  -evasao), y = base_treina$evasao, method = "nnet", 
                  trControl = fitcontrol, metric = "Spec", maxit = 1000)
            }
        }
        nnet_pred <<- predict(nnet_fit, base_teste)
        mc_nnet <<- confusionMatrix(nnet_pred, base_teste$evasao)
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
