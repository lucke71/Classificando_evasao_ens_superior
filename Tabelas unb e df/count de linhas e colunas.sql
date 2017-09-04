--Tabela 1 - UnB Total empilhada
select	count(1) as num_vinculos,
		co_aluno_situacao,
		case when co_curso = 1140048 then 3 else co_ocde_area_geral end as co_ocde_area_geral
from unb_empilhada
group by co_aluno_situacao,case when co_curso = 1140048 then 3 else co_ocde_area_geral end;


--Tabela 2 - UnB graduação presencial
select	count(1) as num_vinculos,
		co_aluno_situacao,
		case when co_curso = 1140048 then 3 else co_ocde_area_geral end as co_ocde_area_geral
from unb_empilhada
where co_nivel_academico=1 and co_modalidade_ensino=1
group by co_aluno_situacao,case when co_curso = 1140048 then 3 else co_ocde_area_geral end;



--Tabela 3 - UnB ingressantes e graduação presencial
select	count(1) as num_vinculos,
		co_aluno_situacao,
		case when co_curso = 1140048 then 3 else co_ocde_area_geral end as co_ocde_area_geral
from unb_ingress_teste
group by co_aluno_situacao,	case when co_curso = 1140048 then 3 else co_ocde_area_geral end;


select	count(1) as num_vinculos,
		co_aluno_situacao,
		case when co_curso = 1140048 then 3 else co_ocde_area_geral end as co_ocde_area_geral
from unb_empilhada_ingressantes
group by co_aluno_situacao,	case when co_curso = 1140048 then 3 else co_ocde_area_geral end;


--Tabela 4 - UnB ingressantes e graduação presencial
select	count(1) as num_vinculos,
		co_aluno_situacao,
		case when co_curso = 1140048 then 3 else co_ocde_area_geral end as co_ocde_area_geral
from unb_empilhada_ingressantes
where abi=0
group by co_aluno_situacao,	case when co_curso = 1140048 then 3 else co_ocde_area_geral end;



--Contagem por nivel de evasao (tabelas finais)
select	count(1)
from unb_grupo_ingressantes
where abi=0;


select	count(1)
from unb_grupo_ingressantes
where abi=0 and evasao=1;


select	count(1)
from unb_curso_ingressantes
where not(co_aluno_situacao=5 and abi=1);

select	count(1)
from unb_curso_ingressantes
where not(co_aluno_situacao=5 and abi=1) and evasao =1;


select	count(1)
from unb_ies_ingressantes
where not(co_aluno_situacao=5 and abi=1);

select	count(1)
from unb_ies_ingressantes
where not(co_aluno_situacao=5 and abi=1) and evasao =1;













select	count(COLUMN_NAME)
from INFORMATION_SCHEMA.COLUMNS
WHERE
TABLE_CATALOG='lucas_assis'
AND TABLE_SCHEMA='public'
AND TABLE_NAME='unb_curso_ingressantes';


select	count(1)
from unb_grupo_ingressantes; 

select	count(1)
from unb_grupo_ingressantes
where evasao=1;

select	count(COLUMN_NAME)
from INFORMATION_SCHEMA.COLUMNS
WHERE
TABLE_CATALOG='lucas_assis'
AND TABLE_SCHEMA='public'
AND TABLE_NAME='unb_grupo_ingressantes';


select	count(1)
from unb_ies_ingressantes; 

select	count(1)
from unb_ies_ingressantes
where evasao=1;

select	count(COLUMN_NAME)
from INFORMATION_SCHEMA.COLUMNS
WHERE
TABLE_CATALOG='lucas_assis'
AND TABLE_SCHEMA='public'
AND TABLE_NAME='unb_ies_ingressantes';

