# Classificando_evasao_ens_superior

Gerador de classificadores para alunos do ensino superior brasileiro com dados do INEP.

A evasão no ensino superior é um problema que atinge diversas instituições no mundo. 
No Brasil, a evasão no ensino superior é pouco estudada e não há divulgação regular de dados ou estudos aprofundados sobre o assunto.
Este projeto possui um framework para treinar classificadores de evasão, que podem ser utilizados para determinar em um grupo específico quais alunos possuem maior tendência de evadir e apoiar tomadas de decisão futuras.

O projeto contém a preparação dos dados disponibilizados pelo Instituto Nacional de Estudos e Pesquisas Educacionais Anísio Teixeira (INEP) em SQL e o código em R para treinar os classificadores. Os dados utilizados são os microdados do Censo da Educação Superior (CES) e do Exame Nacional do Ensino Médio (ENEM). Apesar deles serem disponibilizados pelo INEP em "http://portal.inep.gov.br/basica-levantamentos-acessar", para utilizar este framework é necessário estar fisicamente dentro do instituto, pois para juntar as bases é preciso utilizar a identificação do CPF dos estudantes. Para ter acesso é necessário solicitar ao INEP em "http://portal.inep.gov.br/acesso-a-informacao/servico-de-atendimento-ao-pesquisador-sap".

