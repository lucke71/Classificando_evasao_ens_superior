library(dplyr)
library(caret)
unb_curso = dbGetQuery(con,"select * from unb_curso_completo")

unb_curso_sample = unb_curso[sample(1:nrow(unb_curso),1000),]

#colocando co_ies na 1a posicao de coluna para ficar igual as tabelas DF (sql da UnB ja foi arrumado)
# unb_curso_sample = unb_curso_sample[,c(170,1:169)]

# Eh necessario retirar o atributo co_aluno_situacao, pois ele da informacao completa aos modelos
unb_curso_sample = dplyr::select(unb_curso_sample,-co_aluno_situacao)

database = unb_curso_sample


classificando_evasao = function(database,cv_folds,pct_training,classificador){

# indicar quais atributos sao factors
attr_nao_factor = c("vagas","candidatos","num_ies","idade","ano_max","ano_concluiu","nu_nota_comp1","nu_nota_comp2","nu_nota_comp3","nu_nota_comp4","nu_nota_comp5","nu_nota_redacao","doc_exercicio","doc_qualifcacao","doc_exer_outro_org","doc_afastado_outro","doc_falecido","doc_graduacao","doc_especializacao","doc_mestrado","doc_doutorado","doc_integ_de","doc_integ_sem_de","doc_temp_parcial","doc_horista","doc_brasileiro","doc_brasileiro_nat","doc_estrangeiro")

nao_factor_pos = sapply(attr_nao_factor,function(x)grep(paste0("^",x,"$"),names(database)))

var_factor = (1:ncol(database))[-nao_factor_pos]

# funcao para remover espacos antes e depois de respostas
tira_espaco = function (x) gsub("^\\s+|\\s+$", "", x)

# funcao para trocar valores vazios ("") por "branco"
val_branco = function (x) sub("^$","branco",x)

# funcao para trocar o valor NA por "branco"
val_NA = function (x) ifelse(is.na(x),"branco",x) 


# aplicando funcao trim nos atributos que sao "fatores"
database[,var_factor] = lapply(database[,var_factor],tira_espaco)

# aplicando funcao val_branco nos atributos que sao "fatores"
database[,var_factor] = lapply(database[,var_factor],val_branco)

# aplicando funcao val_branco nos atributos que sao "fatores"
database[,var_factor] = lapply(database[,var_factor],val_NA)


# removendo municipios de nascimento e de escola - criando atributo indicativo de municipios diferentes
database = database %>% mutate(mun_nasc_dif_res = cod_municipio_nascimento!=cod_municipio_residencia) 
database = database %>% mutate(mun_res_dif_esc = cod_municipio_residencia!=cod_municipio_esc) 
database = database %>% mutate(mun_res_dif_prova = cod_municipio_residencia!=cod_municipio_prova) 
database = database %>% mutate(uf_res = substr(cod_municipio_residencia,1,2))
database = database %>% mutate(uf_esc = substr(cod_municipio_esc,1,2))
database = database %>% mutate(uf_nasc = substr(cod_municipio_nascimento,1,2))

database = dplyr::select(database,-c(cod_municipio_residencia,cod_municipio_esc,cod_municipio_prova,cod_municipio_nascimento))


# adicionando atributo dummy para indicar se aluno concluiu ensino medio e adicionando zero ao ano de conclusao caso nao tenha concluido
database$concluiu_ens_med = ifelse(is.na(database$ano_concluiu),FALSE,TRUE)
database$ano_concluiu[is.na(database$ano_concluiu)] = 0

# atualizando a posicao dos atributos fatores
nao_factor_pos = sapply(attr_nao_factor,function(x)grep(paste0("^",x,"$"),names(database)))
var_factor = (1:ncol(database))[-nao_factor_pos]

# transformando os atributos em factors
database[,var_factor] = lapply(database[,var_factor],factor,exclude=NULL)

# os missing sao pessoas que nao possuem notas nas provas do enem
# lapply(database[,sapply(database,class)=="numeric"],summary)

# percentual de missing
# 1-(nrow(na.omit(database))/nrow(database))

# Removendo missing
database = na.omit(database)

# Removendo as colunas que nao possuem variancia - as colunas a ser retiradas pode variar de acordo com os dados 
nzv = nearZeroVar(database)
database = database[,-nzv]

# Determinando o tipo de controle a ser feito sobre os modelos
fitcontrol = trainControl(method = "cv",number = cv_folds,summaryFunction = twoClassSummary)

# Separando base de treinamento da base de teste
intraining = createDataPartition(database$evasao, p = pct_training, list = FALSE)

base_treina = database[intraining,]

base_teste = database[-intraining,]


if(classificar=="ẗodos" | classificador=="NB"){
  # Classificando com Naive Bayes
  naive_fit = train(x = dplyr::select(base_treina,-evasao),y=base_treina$evasao,method="nb",trControl=fitcontrol,metric = 'Spec')
  
  naive_pred = predict(naive_fit,base_teste)
  
  naive_matriz_conf = confusionMatrix(naive_pred,base_teste$evasao)
}

if(classificar=="ẗodos" | classificador=="CART"){
  # Classificando com CART
  cart_fit = train(x = dplyr::select(base_treina,-evasao),y=base_treina$evasao,method="rpart",trControl=fitcontrol,tuneLength = 10,maxdepth=30,metric = 'Spec')
  
  cart_pred = predict(cart_fit,base_teste)
  
  cart_matriz_conf = confusionMatrix(cart_pred,base_teste$evasao)
}

if(classificar=="ẗodos" | classificador=="C45"){
# Classificando com C4.5
c45_fit = train(x=dplyr::select(base_treina,-evasao),y=base_treina$evasao,method="J48",tuneLength = 10,trControl=fitcontrol,metric = 'Spec') 

c45_pred = predict(c45_fit,base_teste)

c45_matriz_conf = confusionMatrix(c45_pred,base_teste$evasao)
}

if(classificar=="ẗodos" | classificador=="reglog"){
# classificando com regressao 
# reglog_fit = train(x=dplyr::select(base_treina,-c(evasao,co_curso)),y=base_treina$evasao,data=base_treina,method="plr",trControl=fitcontrol,metric = 'Spec') 
base_log = dplyr::select(base_treina,-co_curso)
reglog_fit = train(base_log$evasao~.,data=base_log,method="plr",trControl=fitcontrol,metric = 'Spec') 

pred_reg = predict(reglog_fit,base_test)

mc_reg = confusionMatrix(pred_reg,base_test$evasao)
}

if(classificar=="ẗodos" | classificador=="Nnet"){
# classificando com redes neurais
nnet_fit = train(x=dplyr::select(base_treina,-c(evasao,co_curso)),y=base_treina$evasao,method="nnet",trControl=fitcontrol,metric = 'Spec') 
pred_nnet = predict(nnet_fit,base_teste)
mc_nnet = confusionMatrix(pred_nnet,base_teste$evasao)
}
}


