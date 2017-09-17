﻿CREATE TABLE enem_empilhado as (
--Select do ENEM 2014		
	SELECT
	nu_ano,
	nu_cpf,
	id_inscricao,
	id_mascara,
	in_estuda_classe_hospitalar,
	cod_municipio_residencia,
	cod_municipio_esc,
	id_dependencia_adm_esc,
	id_localizacao_esc,
	sit_func_esc,
	idade,
	tp_sexo,
	nacionalidade,
	cod_municipio_nascimento,
	st_conclusao,
	ano_concluiu,
	tp_escola,
	in_tp_ensino,
	tp_estado_civil,
	tp_cor_raca,
	in_baixa_visao,
	in_cegueira,
	in_surdez,
	in_deficiencia_auditiva,
	in_surdo_cegueira,
	in_deficiencia_fisica,
	in_deficiencia_mental,
	in_deficit_atencao,
	in_dislexia,
	in_gestante,
	in_lactante,
	in_idoso,
	in_autismo,
	in_sabatista,
	in_braille,
	in_ampliada_24,
	in_ampliada_18,
	in_ledor,
	in_acesso,
	in_transcricao,
	in_libras,
	in_leitura_labial,
	in_mesa_cadeira_rodas,
	in_mesa_cadeira_separada,
	in_guia_interprete,
	in_certificado,
	cod_municipio_prova,
	nota_cn,
	nota_ch,
	nota_lc,
	nota_mt,
	nu_nota_comp1,
	nu_nota_comp2,
	nu_nota_comp3,
	nu_nota_comp4,
	nu_nota_comp5,
	nu_nota_redacao,
	q001,
	q002,
	q003,
	q004,
	q005,
	q006,
	q007,
	q008,
	q009,
	q010,
	q011,
	q012,
	q013,
	q014,
	q015,
	q016,
	q017,
	q018,
	q019,
	q020,
	q021,
	q022,
	q023,
	q024,
	q025,
	q026,
	q027,
	q028,
	q029,
	q030,
	q031,
	q032,
	q033,
	q034,
	q035,
	q036,
	q037,
	q038,
	q039,
	q040,
	q041,
	q042,
	q043,
	q044,
	q045,
	q046,
	q047,
	q048,
	q049,
	q050,
	q051,
	q052,
	q053,
	q054,
	q055,
	q056,
	q057,
	q058,
	q059,
	q060,
	q061,
	q062,
	q063,
	q064,
	q065,
	q066,
	q067,
	q068,
	q069,
	q070,
	q071,
	q072,
	q073,
	q074,
	q075,
	q076
	FROM enem_2014

	UNION ALL

--Select do ENEM 2013
	SELECT
	nu_ano,
	nu_cpf,
	id_inscricao,
	id_mascara,
	in_estuda_classe_hospitalar,
	cod_municipio_residencia,
	cod_municipio_esc,
	id_dependencia_adm_esc,
	id_localizacao_esc,
	sit_func_esc,
	idade,
	tp_sexo,
	nacionalidade,
	cod_municipio_nascimento,
	st_conclusao,
	ano_concluiu,
	tp_escola,
	in_tp_ensino,
	tp_estado_civil,
	tp_cor_raca,
	in_baixa_visao,
	in_cegueira,
	in_surdez,
	in_deficiencia_auditiva,
	in_surdo_cegueira,
	in_deficiencia_fisica,
	in_deficiencia_mental,
	in_deficit_atencao,
	in_dislexia,
	in_gestante,
	in_lactante,
	in_idoso,
	in_autismo,
	in_sabatista,
	in_braille,
	in_ampliada_24,
	in_ampliada_18,
	in_ledor,
	in_acesso,
	in_transcricao,
	in_libras,
	in_leitura_labial,
	in_mesa_cadeira_rodas,
	in_mesa_cadeira_separada,
	in_guia_interprete,
	in_certificado,
	cod_municipio_prova,
	nota_cn,
	nota_ch,
	nota_lc,
	nota_mt,
	nu_nota_comp1,
	nu_nota_comp2,
	nu_nota_comp3,
	nu_nota_comp4,
	nu_nota_comp5,
	nu_nota_redacao,
	q001,
	q002,
	q003,
	q004,
	q005,
	q006,
	q007,
	q008,
	q009,
	q010,
	q011,
	q012,
	q013,
	q014,
	q015,
	q016,
	q017,
	q018,
	q019,
	q020,
	q021,
	q022,
	q023,
	q024,
	q025,
	q026,
	q027,
	q028,
	q029,
	q030,
	q031,
	q032,
	q033,
	q034,
	q035,
	q036,
	q037,
	q038,
	q039,
	q040,
	q041,
	q042,
	q043,
	q044,
	q045,
	q046,
	q047,
	q048,
	q049,
	q050,
	q051,
	q052,
	q053,
	q054,
	q055,
	q056,
	q057,
	q058,
	q059,
	q060,
	q061,
	q062,
	q063,
	q064,
	q065,
	q066,
	q067,
	q068,
	q069,
	q070,
	q071,
	q072,
	q073,
	q074,
	q075,
	q076
	FROM enem_2013

	UNION ALL

--Select do ENEM 2012
	SELECT	
	nu_ano,
	nu_cpf,
	id_inscricao,
	id_mascara,
	in_estuda_classe_hospitalar,
	cod_municipio_residencia,
	cod_municipio_esc,
	id_dependencia_adm_esc,
	id_localizacao_esc,
	sit_func_esc,
	idade,
	tp_sexo,
	NULL as nacionalidade,
	NULL as cod_municipio_nascimento,
	st_conclusao,
	ano_concluiu,
	tp_escola,
	in_tp_ensino,
	tp_estado_civil,
	tp_cor_raca,
	in_baixa_visao,
	in_cegueira,
	in_surdez,
	in_deficiencia_auditiva,
	in_surdo_cegueira,
	in_deficiencia_fisica,
	in_deficiencia_mental,
	in_deficit_atencao,
	in_dislexia,
	in_gestante,
	in_lactante,
	in_idoso,
	in_autismo,
	in_sabatista,
	in_braille,
	in_ampliada_24,
	in_ampliada_18,
	in_ledor,
	in_acesso,
	in_transcricao,
	in_libras,
	in_leitura_labial,
	in_mesa_cadeira_rodas,
	in_mesa_cadeira_separada,
	in_guia_interprete,
	in_certificado,
	cod_municipio_prova,
	nota_cn,
	nota_ch,
	nota_lc,
	nota_mt,
	nu_nota_comp1,
	nu_nota_comp2,
	nu_nota_comp3,
	nu_nota_comp4,
	nu_nota_comp5,
	nu_nota_redacao,
	Q01 as q001,
	Q02 as q002,
	Q03 as q003,
	Q04 as q004,
	Q05 as q005,
	Q06 as q006,
	Q07 as q007,
	Q08 as q008,
	Q09 as q009,
	Q10 as q010,
	Q11 as q011,
	Q12 as q012,
	Q13 as q013,
	Q14 as q014,
	Q15 as q015,
	Q16 as q016,
	Q17 as q017,
	Q18 as q018,
	Q19 as q019,
	Q20 as q020,
	Q21 as q021,
	case when Q22='B' then 'C' else Q22 end as q022,
	Q23 as q023,
	Q24 as q024,
	Q25 as q025,
	Q26 as q026,
	Q27 as q027,
	Q28 as q028,
	Q29 as q029,
	Q30 as q030,
	Q31 as q031,
	Q32 as q032,
	Q33 as q033,
	Q34 as q034,
	Q35 as q035,
	Q36 as q036,
	Q37 as q037,
	Q38 as q038,
	Q39 as q039,
	NULL as q040,
	NULL as q041,
	NULL as q042,
	NULL as q043,
	NULL as q044,
	NULL as q045,
	NULL as q046,
	NULL as q047,
	NULL as q048,
	NULL as q049,
	NULL as q050,
	NULL as q051,
	NULL as q052,
	NULL as q053,
	Q40 as q054,
	Q41 as q055,
	Q42 as q056,
	Q43 as q057,
	Q44 as q058,
	Q45 as q059,
	Q46 as q060,
	Q47 as q061,
	Q48 as q062,
	Q49 as q063,
	Q50 as q064,
	Q51 as q065,
	Q52 as q066,
	Q53 as q067,
	Q54 as q068,
	Q55 as q069,
	Q56 as q070,
	Q57 as q071,
	Q58 as q072,
	Q59 as q073,
	Q60 as q074,
	Q61 as q075,
	Q62 as q076
	FROM enem_2012

	UNION ALL

--Select do ENEM 2011
	SELECT
	nu_ano,
	nu_cpf,
	id_inscricao,
	id_mascara,
	in_estuda_classe_hospitalar,
	cod_municipio_residencia,
	cod_municipio_esc,
	id_dependencia_adm_esc,
	id_localizacao_esc,
	sit_func_esc,
	idade,
	tp_sexo,
	NULL as nacionalidade,
	NULL as cod_municipio_nascimento,
	st_conclusao,
	ano_concluiu,
	tp_escola,
	in_tp_ensino,
	tp_estado_civil,
	tp_cor_raca,
	in_baixa_visao,
	in_cegueira,
	in_surdez,
	in_deficiencia_auditiva,
	in_surdo_cegueira,
	in_deficiencia_fisica,
	in_deficiencia_mental,
	in_deficit_atencao,
	in_dislexia,
	in_gestante,
	in_lactante,
	in_idoso,
	in_autismo,
	in_sabatista,
	in_braille,
	in_ampliada_24,
	in_ampliada_18,
	in_ledor,
	in_acesso,
	in_transcricao,
	in_libras,
	in_leitura_labial,
	in_mesa_cadeira_rodas,
	in_mesa_cadeira_separada,
	in_guia_interprete,
	in_certificado,
	cod_municipio_prova,
	nota_cn,
	nota_ch,
	nota_lc,
	nota_mt,
	nu_nota_comp1,
	nu_nota_comp2,
	nu_nota_comp3,
	nu_nota_comp4,
	nu_nota_comp5,
	nu_nota_redacao,
	q02 as q001,
	q03 as q002,
	NULL as q003,
	cast(q01 as numeric) as q004,
	q06 as q005,
	q07 as q006,
	q61 as q007,
	q62 as q008, 
	q63 as q009, 
	q64 as q010, 
	q65 as q011, 
	q66 as q012, 
	q67 as q013, 
	q68 as q014, 
	q69 as q015, 
	q70 as q016, 
	q71 as q017, 
	q72 as q018, 
	q73 as q019, 
	q74 as q020, 
	q75 as q021, 
	case when q08='B' then 'C' else q08 end as q022,
	cast(q24 as numeric) as q023,
	NULL as q024,
	NULL as q025,
	NULL as q026,
	NULL as q027,
	cast(q27 as numeric) as q028,
	NULL as q029,
	q28 as q030,
	q29 as q031,
	q30 as q032,
	q31 as q033,
	q32 as q034,
	q33 as q035,
	q58 as q036,
	q59 as q037,
	q60 as q038,
	q57 as q039,
	cast(case when q23=' .' then NULL else q23 end as numeric) as q040,
	q22 as q041,
	cast(case when q09=' ' then NULL else q09 end as numeric) as q042,
	cast(case when q10=' ' then NULL else q10 end as numeric) as q043,
	cast(case when q11=' ' then NULL else q11 end as numeric) as q044,
	cast(case when q12=' ' then NULL else q12 end as numeric) as q045,
	cast(case when q13=' ' then NULL else q13 end as numeric) as q046,
	q15 as q047,
	q16 as q048,
	q17 as q049,
	q18 as q050,
	q19 as q051,
	q20 as q052,
	q21 as q053,
	q34 as q054,
	q35 as q055,
	q36 as q056,
	q37 as q057,
	q38 as q058,
	q39 as q059,
	q40 as q060,
	q41 as q061,
	NULL as q062,
	NULL as q063,
	q43 as q064,
	case when q44 in ('0','1','2') then 'A' when q44 in ('3','4','5') then 'B' else NULL end as q065,
	case when q45 in ('0','1','2') then 'A' when q45 in ('3','4','5') then 'B' else NULL end as q066,
	NULL as q067,
	case when q46 in ('0','1','2') then 'A' when q46 in ('3','4','5') then 'B' else NULL end as q068,
	NULL as q069,
	case when q47 in ('0','1','2') then 'A' when q47 in ('3','4','5') then 'B' else NULL end as q070,
	case when q48 in ('0','1','2') then 'A' when q48 in ('3','4','5') then 'B' else NULL end as q071,
	case when q49 in ('0','1','2') then 'A' when q49 in ('3','4','5') then 'B' else NULL end as q072,
	case when q50 in ('0','1','2') then 'A' when q50 in ('3','4','5') then 'B' else NULL end as q073,
	case when q51 in ('0','1','2') then 'A' when q51 in ('3','4','5') then 'B' else NULL end as q074,
	NULL as q075,
	q52 as q076
	FROM enem_2011_comp


	UNION ALL

--Select do ENEM 2010
	SELECT
	nu_ano,
	nu_cpf,
	id_inscricao,
	id_mascara,
	in_estuda_classe_hospitalar,
	cod_municipio_residencia,
	cod_municipio_esc,
	id_dependencia_adm_esc,
	id_localizacao_esc,
	sit_func_esc,
	idade,
	tp_sexo,
    NULL as nacionalidade,
	NULL as cod_municipio_nascimento,
	st_conclusao,
	ano_concluiu,
	tp_escola,
	in_tp_ensino,
	tp_estado_civil,
	tp_cor_raca,
	in_baixa_visao,
	in_cegueira,
	in_surdez,
	in_deficiencia_auditiva,
	in_surdo_cegueira,
	in_deficiencia_fisica,
	in_deficiencia_mental,
	in_deficit_atencao,
	in_dislexia,
	in_gestante,
	in_lactante,
	in_idoso,
	in_autismo,
	in_sabatista,
	in_braille,
	in_ampliada_24,
	in_ampliada_18,
	in_ledor,
	in_acesso,
	in_transcricao,
	in_libras,
	in_leitura_labial,
	in_mesa_cadeira_rodas,
	in_mesa_cadeira_separada,
	in_guia_interprete,
	in_certificado,
	cod_municipio_prova,
	nota_cn,
	nota_ch,
	nota_lc,
	nota_mt,
	nu_nota_comp1,
	nu_nota_comp2,
	nu_nota_comp3,
	nu_nota_comp4,
	nu_nota_comp5,
	nu_nota_redacao,
	case when q02='A' then 'B' when q02='B' then 'C' when q02='C' then 'E'
	when q02='D' then 'G' when q02='E' or q02='F' or q02='G' then 'H'
	when q02='H' then 'A' else q02 end as q001,
	case when q03='A' then 'B' when q03='B' then 'C' when q03='C' then 'E'
	when q03='D' then 'G' when q03='E' or q03='F' or q03='G' then 'H'
	when q03='H' then 'A' else q03 end as q002,
	NULL as q003,
	NULL as q004,
	case when q06='B' then 'C' when q06='C' then 'D' else q06 end as q005,
	q07 as q006,
	NULL as q007,
	NULL as q008,
	NULL as q009,
	NULL as q010,
	NULL as q011,
	NULL as q012,
	NULL as q013,
	NULL as q014,
	NULL as q015,
	NULL as q016,
	NULL as q017,
	NULL as q018,
	NULL as q019,
	NULL as q020,
	NULL as q021,
	case when q08='B' then 'C' else q08 end as q022,
	q24 as q023,
	NULL as q024,
	NULL as q025,
	NULL as q026,
	NULL as q027,
	q27 as q028,
	NULL as q029,
	q28 as q030,
	q29 as q031,
	case when q30='F' then NULL when q30='H' then NULL else q30 end as q032,
	q31 as q033,
	q32 as q034,
	case when q33='F' then NULL when q33='H' then NULL else q33 end as q035,
	NULL as q036,
	NULL as q037,
	NULL as q038,
	NULL as q039,
	NULL as q040,
	q22 as q041,
	q09 as q042,
	q10 as q043,
	q11 as q044,
	q12 as q045,
	q13 as q046,
	q15 as q047,
	q16 as q048,
	q17 as q049,
	q18 as q050,
	q19 as q051,
	q20 as q052,
	q21 as q053,
	q34 as q054,
	q35 as q055,
	q36 as q056,
	q37 as q057,
	q38 as q058,
	q39 as q059,
	q40 as q060,
	q41 as q061,
	NULL as q062,
	NULL as q063,
	q44 as q064,
	case when q45 in (0,1,2) then 'A' when q45 in (3,4,5) then 'B' else NULL end as q065,
	case when q46 in (0,1,2) then 'A' when q46 in (3,4,5) then 'B' else NULL end as q066,
	NULL as q067,
	case when q47 in (0,1,2) then 'A' when q47 in (3,4,5) then 'B' else NULL end as q068,
	NULL as q069,
	case when q48 in (0,1,2) then 'A' when q48 in (3,4,5) then 'B' else NULL end as q070,
	case when q49 in (0,1,2) then 'A' when q49 in (3,4,5) then 'B' else NULL end as q071,
	case when q50 in (0,1,2) then 'A' when q50 in (3,4,5) then 'B' else NULL end as q072,
	case when q51 in (0,1,2) then 'A' when q51 in (3,4,5) then 'B' else NULL end as q073,
	case when q52 in (0,1,2) then 'A' when q52 in (3,4,5) then 'B' else NULL end as q074,
	NULL as q075,
	q53 as q076
	FROM enem_2010
);
