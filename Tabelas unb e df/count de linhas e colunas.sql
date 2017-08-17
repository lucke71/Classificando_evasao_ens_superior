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

