--Tabela 1 - UnB Total empilhada
select	count(1) as num_vinculos,
		co_aluno_situacao,
		case when co_ocde_area_geral is null then 0 else co_ocde_area_geral end as ocde
from unb_empilhada
group by co_aluno_situacao,case when co_ocde_area_geral is null then 0 else co_ocde_area_geral end;


--Tabela 2 - UnB graduação presencial
select	count(1) as num_vinculos,
		co_aluno_situacao,
		case when co_ocde_area_geral is null then 0 else co_ocde_area_geral end as ocde
from unb_empilhada
where co_nivel_academico=1 and co_modalidade_ensino=1
group by co_aluno_situacao,case when co_ocde_area_geral is null then 0 else co_ocde_area_geral end;


--Tabela 3 - UnB ingressantes e graduação presencial
select	count(1) as num_vinculos,
		co_aluno_situacao,
		case when co_ocde_area_geral is null then 0 else co_ocde_area_geral end as ocde
from unb_ingress_teste
group by co_aluno_situacao,case when co_ocde_area_geral is null then 0 else co_ocde_area_geral end;



select	count(1)
from unb_curso_ingressantes; 

select	count(1)
from unb_curso_ingressantes
where evasao=1;

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

