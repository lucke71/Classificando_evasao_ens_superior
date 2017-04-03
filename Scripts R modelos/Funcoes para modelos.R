library(dplyr)
library(caret)
unb_curso = dbGetQuery(con,"select * from unb_curso_completo")

unb_curso_sample = unb_curso[sample(1:nrow(unb_curso),1000),]

#colocando co_ies na 1a posicao de coluna para ficar igual as tabelas DF (sql da UnB ja foi arrumado)
# unb_curso_sample = unb_curso_sample[,c(170,1:169)]

# indicar quais atributos sao factors
attr_nao_factor = c("vagas","candidatos","num_ies","idade","ano_max","ano_concluiu","nu_nota_comp1","nu_nota_comp2","nu_nota_comp3","nu_nota_comp4","nu_nota_comp5","nu_nota_redacao")

nao_factor_pos = sapply(attr_nao_factor,function(x)grep(paste0("^",x,"$"),names(unb_curso_sample)))

var_factor = (1:ncol(unb_curso_sample))[-nao_factor_pos]

# funcao para remover espacos antes e depois de respostas
tira_espaco = function (x) gsub("^\\s+|\\s+$", "", x)

# funcao para trocar valores vazios ("") por "branco"
val_branco = function (x) sub("^$","branco",x)

# funcao para trocar o valor NA por "branco"
val_NA = function (x) ifelse(is.na(x),"branco",x) 


# aplicando funcao trim nos atributos que sao "fatores"
unb_curso_sample[,var_factor] = lapply(unb_curso_sample[,var_factor],tira_espaco)

# aplicando funcao val_branco nos atributos que sao "fatores"
unb_curso_sample[,var_factor] = lapply(unb_curso_sample[,var_factor],val_branco)

# aplicando funcao val_branco nos atributos que sao "fatores"
unb_curso_sample[,var_factor] = lapply(unb_curso_sample[,var_factor],val_NA)


# removendo municipios de nascimento e de escola - criando atributo indicativo de municipios diferentes
unb_curso_sample = unb_curso_sample %>% mutate(mun_nasc_dif_res = cod_municipio_nascimento!=cod_municipio_residencia) 
unb_curso_sample = unb_curso_sample %>% mutate(mun_res_dif_esc = cod_municipio_residencia!=cod_municipio_esc) 
unb_curso_sample = unb_curso_sample %>% mutate(mun_res_dif_prova = cod_municipio_residencia!=cod_municipio_prova) 
unb_curso_sample = unb_curso_sample %>% mutate(uf_res = substr(cod_municipio_residencia,1,2))
unb_curso_sample = unb_curso_sample %>% mutate(uf_esc = substr(cod_municipio_esc,1,2))
unb_curso_sample = unb_curso_sample %>% mutate(uf_nasc = substr(cod_municipio_nascimento,1,2))

unb_curso_sample = dplyr::select(unb_curso_sample,-c(cod_municipio_residencia,cod_municipio_esc,cod_municipio_prova,cod_municipio_nascimento))


# adicionando atributo dummy para indicar se aluno concluiu ensino medio e adicionando zero ao ano de conclusao caso nao tenha concluido
unb_curso_sample$concluiu_ens_med = ifelse(is.na(unb_curso_sample$ano_concluiu),FALSE,TRUE)
unb_curso_sample$ano_concluiu[is.na(unb_curso_sample$ano_concluiu)] = 0

# atualizando a posicao dos atributos fatores
nao_factor_pos = sapply(attr_nao_factor,function(x)grep(paste0("^",x,"$"),names(unb_curso_sample)))
var_factor = (1:ncol(unb_curso_sample))[-nao_factor_pos]

# transformando os atributos em factors
unb_curso_sample[,var_factor] = lapply(unb_curso_sample[,var_factor],factor,exclude=NULL)

# os missing sao pessoas que nao possuem notas nas provas do enem
# lapply(unb_curso_sample[,sapply(unb_curso_sample,class)=="numeric"],summary)

# percentual de missing
# 1-(nrow(na.omit(unb_curso_sample))/nrow(unb_curso_sample))

# Removendo missing
unb_curso_sample = na.omit(unb_curso_sample)

# Removendo as colunas que nao possuem variancia - as colunas a ser retiradas pode variar de acordo com os dados 
nzv = nearZeroVar(unb_curso_sample)
unb_curso_sample = unb_curso_sample[,-nzv]

# Determinando o tipo de controle a ser feito sobre os modelos
fitcontrol = trainControl(method = "cv",number = 4)

# Separando base de treinamento da base de teste
intraining = createDataPartition(unb_curso_sample$evasao, p = .75, list = FALSE)

base_treina = unb_curso_sample[intraining,]

base_teste = unb_curso_sample[-intraining,]


# Classificando com Naive Bayes
naive_fit = train(x = dplyr::select(base_treina,-evasao),y=base_treina$evasao,method="nb",trControl=fitcontrol,metric = 'Spec')

naive_pred = predict(naive_fit,base_teste)

naive_matriz_conf = confusionMatrix(naive_pred,base_teste$evasao)


# Classificando com CART
cart_fit = train(x = dplyr::select(base_treina,-evasao),y=base_treina$evasao,method="rpart",trControl=fitcontrol,tuneLength = 10,maxdepth=30,metric = 'Spec')

cart_pred = predict(cart_fit,base_teste)

cart_matriz_conf = confusionMatrix(cart_pred,base_teste$evasao)


# Classificando com C4.5
c45_fit = train(x=dplyr::select(base_treina,-evasao),y=base_treina$evasao,method="J48",tuneLength = 10,trControl=fitcontrol,metric = 'Spec') 

c45_pred = predict(c45_fit,base_teste)

c45_matriz_conf = confusionMatrix(c45_pred,base_teste$evasao)


# classificando com regressao 
reglog_fit = train(x=dplyr::select(base_treina,-evasao),y=base_treina$evasao,data=base_treina,method="plr",trControl=fitcontrol,metric = 'Spec') 

pred_reg = predict(reglog_fit,base_test)

mc_reg = confusionMatrix(pred_reg,base_test$evasao)


# classificando com redes neurais
nnet_fit = train(x[,-2],y,method="nnet",trControl=fitcontrol,metric = 'Spec') 
pred_nnet = predict(nnet_fit,base_test)
mc_nnet = confusionMatrix(pred_nnet,base_test$evasao)
