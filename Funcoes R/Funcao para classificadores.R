# Argumentos da funcao que sao obrigatorios: database --- escolher o dataframe que possui os dados de evasao a serem utilizados;
# Os outros argumentos possuem valores padrao. 
# Classificador padrao: CART; Opcoes: "CART" (executa apenas classificador CART), 
# "C45" (executa apenas classificador C4.5), "NB" (executa apenas classificador Naive Bayes), "reglog" (executa apenas classificador de regressao logistica),
# "Nnet" (executa apenas classificador de redes neurais) e "todos" (executa todos os classificadores)
# Numero de folds para cross-validation padrao e 4; Opcoes: qualquer numero maior que zero
# Percentual da base a ser usada para treinamento padrao = 75% (25% sao usados para teste); Opcoes: qualquer percentual (valores de 0 a 1)
# Numero de cores a ser usado caso OS seja baseado em UNIX padrao = 4; As opcoes dependem da maquina em que esta sendo executado
# Fazer balanceamento dos dados padrao e nao fazer balanceamento. Opcoes: "up"para up-sampling e "down" para down-sampling

# Depende de dplyr, caret e doParallel (UNIX)

classificando_evasao = function(database,cv_folds=4,pct_training=0.75,classificador="CART",num_cores=4,balanceamento=""){
  library(dplyr)
  library(caret)
  
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
  
  # Removendo missing
  database = na.omit(database)
  
  # Removendo as colunas que nao possuem variancia - as colunas a ser retiradas pode variar de acordo com os dados 
  nzv = nearZeroVar(database)
  database = database[,-nzv]
  
  # Determinando o tipo de controle a ser feito sobre os modelos
  fitcontrol = trainControl(method = "cv",number = cv_folds,summaryFunction = twoClassSummary)
  
  # Numero de nucleos para processamento paralelo (LINUX) -- Para windows usar Microsoft R OPEN
  if(Sys.info()[1]=="Linux")library(doParallel);registerDoParallel(cores = num_cores)
  
  # Separando base de treinamento da base de teste
  intraining = createDataPartition(database$evasao, p = pct_training, list = FALSE)
  
  base_treina = database[intraining,]
  
  base_teste = database[-intraining,]
  
  
  # Fazendo as classificacoes com upsampling na base de treinamento
  if(balanceamento=="up"){
    up_data = upSample(x = dplyr::select(base_treina,-evasao), y = base_treina$evasao,yname="evasao")
  }
  
  # Downsampling
  if(balanceamento=="down"){
    dwn_data = downSample(x = dplyr::select(base_treina,-evasao), y = base_treina$evasao,yname="evasao")
  }
  
  
  # Classificando com Naive Bayes
  if(classificador=="todos" | classificador=="NB"){
    if(balanceamento=="up"){
      naive_fit <<- train(x = dplyr::select(up_data,-evasao),y=up_data$evasao,method="nb",trControl=fitcontrol,metric = 'Spec')
    }else if(balanceamento=="down"){
      naive_fit <<- train(x = dplyr::select(dwn_data,-evasao),y=dwn_data$evasao,method="nb",trControl=fitcontrol,metric = 'Spec')
    }else{
      naive_fit <<- train(x = dplyr::select(base_treina,-evasao),y=base_treina$evasao,method="nb",trControl=fitcontrol,metric = 'Spec')
    }
    naive_pred <<- predict(naive_fit,base_teste)
    mc_naive <<- confusionMatrix(naive_pred,base_teste$evasao)
  }
  
  
  # Classificando com CART
  if(classificador=="todos" | classificador=="CART"){
    if(balanceamento=="up"){
      cart_fit <<- train(x = dplyr::select(up_data,-evasao),y=up_data$evasao,method="rpart",trControl=fitcontrol,tuneLength = 10,maxdepth=30,metric = 'Spec')
    }else if(balanceamento=="down"){
      cart_fit <<- train(x = dplyr::select(dwn_data,-evasao),y=dwn_data$evasao,method="rpart",trControl=fitcontrol,tuneLength = 10,maxdepth=30,metric = 'Spec')
    }else{
      cart_fit <<- train(x = dplyr::select(base_treina,-evasao),y=base_treina$evasao,method="rpart",trControl=fitcontrol,tuneLength = 10,maxdepth=30,metric = 'Spec')
    }
    cart_pred <<- predict(cart_fit,base_teste)
    mc_cart <<- confusionMatrix(cart_pred,base_teste$evasao)
  }
  
  
  # Classificando com C4.5
  if(classificador=="todos" | classificador=="C45"){
    if(balanceamento=="up"){
      c45_fit <<- train(x=dplyr::select(up_data,-evasao),y=up_data$evasao,method="J48",tuneLength = 10,trControl=fitcontrol,metric = 'Spec') 
    }else if(balanceamento=="down"){
      c45_fit <<- train(x=dplyr::select(dwn_data,-evasao),y=dwn_data$evasao,method="J48",tuneLength = 10,trControl=fitcontrol,metric = 'Spec') 
    }else{
      c45_fit <<- train(x=dplyr::select(base_treina,-evasao),y=base_treina$evasao,method="J48",tuneLength = 10,trControl=fitcontrol,metric = 'Spec') 
    }
    c45_pred <<- predict(c45_fit,base_teste)
    mc_c45 <<- confusionMatrix(c45_pred,base_teste$evasao)
  }
  
  
  # Classificando com regressao logistica
  
  
  if(classificador=="todos" | classificador=="reglog"){
    if(balanceamento=="up"){
      base_log <<- dplyr::select(up_data,-co_curso)
      reglog_fit <<- train(evasao ~ .,data=base_log ,method="glm",family=binomial(link="logit"),trControl=fitcontrol,metric = 'Spec') 
    }else if(balanceamento=="down"){
      base_log <<- dplyr::select(dwn_data,-co_curso)
      reglog_fit <<- train(evasao ~ .,data=base_log ,method="glm",family=binomial(link="logit"),trControl=fitcontrol,metric = 'Spec') 
    }else{
      base_log <<- dplyr::select(base_treina,-co_curso)
      reglog_fit <<- train(evasao ~ .,data=base_log ,method="glm",family=binomial(link="logit"),trControl=fitcontrol,metric = 'Spec') 
    }
    reg_pred <<- predict(reglog_fit,base_teste)
    mc_reg <<- confusionMatrix(reg_pred,base_teste$evasao)
  }
  
  # Classificando com redes neurais
  if(classificador=="todos" | classificador=="Nnet"){
    if(balanceamento=="up"){
      nnet_fit <<- train(x=dplyr::select(up_data,-c(evasao,co_curso)),y=up_data$evasao,method="nnet",trControl=fitcontrol,metric = 'Spec', maxit=1000) 
    }else if(balanceamento=="down"){
      nnet_fit <<- train(x=dplyr::select(dwn_data,-c(evasao,co_curso)),y=dwn_data$evasao,method="nnet",trControl=fitcontrol,metric = 'Spec', maxit=1000) 
    }else{
      nnet_fit <<- train(x=dplyr::select(base_treina,-c(evasao,co_curso)),y=base_treina$evasao,method="nnet",trControl=fitcontrol,metric = 'Spec', maxit=1000) 
    }
    nnet_pred <<- predict(nnet_fit,base_teste)
    mc_nnet <<- confusionMatrix(nnet_pred,base_teste$evasao)
  }
}


