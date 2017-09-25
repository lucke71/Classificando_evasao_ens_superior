create table unb_curso_completo as (
	with alunos_2010 as(
		select 	distinct 
				t1.co_aluno,
				t1.nu_cpf,
				t1.co_ies,
				t2.ds_categoria_administrativa,
				t2.ds_organizacao_academica,
				t1.co_curso,
				extract(year from dt_ingresso_curso) as ano_ing,
				case when extract(month from dt_ingresso_curso)<=6 then 1 else 2 end as semestre_ingresso,
				COALESCE(t2.qt_vagas_integral_pres,0) + COALESCE(t2.qt_vagas_matutino_pres,0) + COALESCE(t2.qt_vagas_noturno_pres,0) + COALESCE(t2.qt_vagas_vespertino_pres,0) as vagas,					
				COALESCE(t2.qt_inscritos_integral_pres,0) + COALESCE(t2.qt_inscritos_matutino_pres,0) + COALESCE(t2.qt_inscritos_noturno_pres,0) + COALESCE(t2.qt_inscritos_vespertino_pres,0) as candidatos, 	
				co_ocde_area_geral,
				case when co_ocde_area_geral in (4,5) then 1 /*Exatas*/
					 when co_ocde_area_geral in (6,7) then 2 /*Saude*/
					 when co_ocde_area_geral in (1,2,3,8) then 3 /*Humanas*/
				end as areas_3,
				tp_atributo_ingresso as ABI,
				in_integral_curso,
				in_matutino_curso,
				in_vespertino_curso,
				in_noturno_curso,
				nu_integralizacao_integral,
				nu_integralizacao_matutino,
				nu_integralizacao_vespertino,
				nu_integralizacao_noturno,
				co_nacionalidade_aluno,
				co_aluno_situacao,
				in_reserva_vagas,
				in_compl_estagio,
				in_compl_extensao,
				in_compl_monitoria,
				in_compl_pesquisa,
				in_bolsa_estagio,
				in_bolsa_monitoria,
				in_bolsa_pesquisa,
				in_bolsa_extensao,
				count(t1.co_curso) over (partition by co_aluno) as num_cursos,
				2010 as ano
		from dm_aluno_2010 t1
		inner join dm_curso_2010 t2 on t1.co_curso=t2.co_curso
		where t1.co_ies=2 and t1.co_modalidade_ensino=1 and t1.co_nivel_academico=1 and not(co_aluno_situacao=5 and tp_atributo_ingresso=1)
	),

	num_ies_2010 as (
		select 	count(distinct co_ies) as num_ies,
				co_aluno
		from dm_aluno_2010
		group by co_aluno
	),

	docentes_2010 as (
		select	distinct 
				co_curso,
				count(case when co_situacao_docente=1 then 1 end) over (partition by t1.co_curso) as doc_exercicio,
				count(case when co_situacao_docente=2 then 1 end) over (partition by t1.co_curso) as doc_qualifcacao,
				count(case when co_situacao_docente=3 then 1 end) over (partition by t1.co_curso) as doc_exer_outro_org,
				count(case when co_situacao_docente=4 then 1 end) over (partition by t1.co_curso) as doc_afastado_outro,
				count(case when co_situacao_docente=5 then 1 end) over (partition by t1.co_curso) as doc_afas_saude,
				count(case when co_escolaridade_docente=1 then 1 end) over (partition by t1.co_curso) as doc_sem_grad,
				count(case when co_escolaridade_docente=2 then 1 end) over (partition by t1.co_curso) as doc_graduacao,
				count(case when co_escolaridade_docente=3 then 1 end) over (partition by t1.co_curso) as doc_especializacao,
				count(case when co_escolaridade_docente=4 then 1 end) over (partition by t1.co_curso) as doc_mestrado,
				count(case when co_escolaridade_docente=5 then 1 end) over (partition by t1.co_curso) as doc_doutorado,
				count(case when co_regime_trabalho=1 then 1 end) over (partition by t1.co_curso) as doc_integ_de,
				count(case when co_regime_trabalho=2 then 1 end) over (partition by t1.co_curso) as doc_integ_sem_de,
				count(case when co_regime_trabalho=3 then 1 end) over (partition by t1.co_curso) as doc_temp_parcial,
				count(case when co_regime_trabalho=4 then 1 end) over (partition by t1.co_curso) as doc_horista,
				count(case when co_nacionalidade_docente=1 then 1 end) over (partition by t1.co_curso) as doc_brasileiro,
				count(case when co_nacionalidade_docente=2 then 1 end) over (partition by t1.co_curso) as doc_brasileiro_nat,
				count(case when co_nacionalidade_docente=3 then 1 end) over (partition by t1.co_curso) as doc_estrangeiro
		from docente_curso_2010 t1 
		inner join dm_docente_2010 t2 on t1.co_docente=t2.co_docente
		where t1.co_ies=2
	),

	alunos_2011 as (
		select 	distinct 
				t1.co_aluno,
				t1.nu_cpf,
				t1.co_ies,
				t2.ds_categoria_administrativa,
				t2.ds_organizacao_academica,
				t1.co_curso,
				extract(year from dt_ingresso_curso) as ano_ing,
				case when extract(month from dt_ingresso_curso)<=6 then 1 else 2 end as semestre_ingresso,
				COALESCE(t2.qt_vagas_integral_pres,0) + COALESCE(t2.qt_vagas_matutino_pres,0) + COALESCE(t2.qt_vagas_noturno_pres,0) + COALESCE(t2.qt_vagas_vespertino_pres,0) as vagas,					
				COALESCE(t2.qt_inscritos_integral_pres,0) + COALESCE(t2.qt_inscritos_matutino_pres,0) + COALESCE(t2.qt_inscritos_noturno_pres,0) + COALESCE(t2.qt_inscritos_vespertino_pres,0) as candidatos, 	
				co_ocde_area_geral,
				case when co_ocde_area_geral in (4,5) then 1 /*Exatas*/
					 when co_ocde_area_geral in (6,7) then 2 /*Saude*/
					 when co_ocde_area_geral in (1,2,3,8) then 3 /*Humanas*/
				end as areas_3,
				tp_atributo_ingresso as ABI,
				in_integral_curso,
				in_matutino_curso,
				in_vespertino_curso,
				in_noturno_curso,
				nu_integralizacao_integral,
				nu_integralizacao_matutino,
				nu_integralizacao_vespertino,
				nu_integralizacao_noturno,
				co_nacionalidade_aluno,
				co_aluno_situacao,
				in_reserva_vagas,
				in_compl_estagio,
				in_compl_extensao,
				in_compl_monitoria,
				in_compl_pesquisa,
				in_bolsa_estagio,
				in_bolsa_monitoria,
				in_bolsa_pesquisa,
				in_bolsa_extensao,
				count(t1.co_curso) over (partition by co_aluno) as num_cursos,
				2011 as ano
		from dm_aluno_2011 t1
		inner join dm_curso_2011 t2 on t1.co_curso=t2.co_curso
		where t1.co_ies=2 and t1.co_modalidade_ensino=1 and t1.co_nivel_academico=1 and not(co_aluno_situacao=5 and tp_atributo_ingresso=1)
	),

	num_ies_2011 as (
		select 	count(distinct co_ies) as num_ies,
				co_aluno
		from dm_aluno_2011
		group by co_aluno
	),

	docentes_2011 as (
		select	distinct 
				co_curso,
				count(case when co_situacao_docente=1 then 1 end) over (partition by t1.co_curso) as doc_exercicio,
				count(case when co_situacao_docente=2 then 1 end) over (partition by t1.co_curso) as doc_qualifcacao,
				count(case when co_situacao_docente=3 then 1 end) over (partition by t1.co_curso) as doc_exer_outro_org,
				count(case when co_situacao_docente=4 then 1 end) over (partition by t1.co_curso) as doc_afastado_outro,
				count(case when co_situacao_docente=5 then 1 end) over (partition by t1.co_curso) as doc_afas_saude,
				count(case when co_escolaridade_docente=1 then 1 end) over (partition by t1.co_curso) as doc_sem_grad,
				count(case when co_escolaridade_docente=2 then 1 end) over (partition by t1.co_curso) as doc_graduacao,
				count(case when co_escolaridade_docente=3 then 1 end) over (partition by t1.co_curso) as doc_especializacao,
				count(case when co_escolaridade_docente=4 then 1 end) over (partition by t1.co_curso) as doc_mestrado,
				count(case when co_escolaridade_docente=5 then 1 end) over (partition by t1.co_curso) as doc_doutorado,
				count(case when co_regime_trabalho=1 then 1 end) over (partition by t1.co_curso) as doc_integ_de,
				count(case when co_regime_trabalho=2 then 1 end) over (partition by t1.co_curso) as doc_integ_sem_de,
				count(case when co_regime_trabalho=3 then 1 end) over (partition by t1.co_curso) as doc_temp_parcial,
				count(case when co_regime_trabalho=4 then 1 end) over (partition by t1.co_curso) as doc_horista,
				count(case when co_nacionalidade_docente=1 then 1 end) over (partition by t1.co_curso) as doc_brasileiro,
				count(case when co_nacionalidade_docente=2 then 1 end) over (partition by t1.co_curso) as doc_brasileiro_nat,
				count(case when co_nacionalidade_docente=3 then 1 end) over (partition by t1.co_curso) as doc_estrangeiro
		from docente_curso_2011 t1 
		inner join dm_docente_2011 t2 on t1.co_docente=t2.co_docente
		where t1.co_ies=2
	),
		
	alunos_2012 as (
		select 	distinct 
				t1.co_aluno,
				t1.nu_cpf,
				t1.co_ies,
				t2.ds_categoria_administrativa,
				t2.ds_organizacao_academica,
				t1.co_curso,
				extract(year from dt_ingresso_curso) as ano_ing,
				case when extract(month from dt_ingresso_curso)<=6 then 1 else 2 end as semestre_ingresso,
				COALESCE(t2.qt_vagas_integral_pres,0) + COALESCE(t2.qt_vagas_matutino_pres,0) + COALESCE(t2.qt_vagas_noturno_pres,0) + COALESCE(t2.qt_vagas_vespertino_pres,0) as vagas,					
				COALESCE(t2.qt_inscritos_integral_pres,0) + COALESCE(t2.qt_inscritos_matutino_pres,0) + COALESCE(t2.qt_inscritos_noturno_pres,0) + COALESCE(t2.qt_inscritos_vespertino_pres,0) as candidatos, 	
				co_ocde_area_geral,
				case when co_ocde_area_geral in (4,5) then 1 /*Exatas*/
					 when co_ocde_area_geral in (6,7) then 2 /*Saude*/
					 when co_ocde_area_geral in (1,2,3,8) then 3 /*Humanas*/
				end as areas_3,
				tp_atributo_ingresso as ABI,
				in_integral_curso,
				in_matutino_curso,
				in_vespertino_curso,
				in_noturno_curso,
				nu_integralizacao_integral,
				nu_integralizacao_matutino,
				nu_integralizacao_vespertino,
				nu_integralizacao_noturno,
				co_nacionalidade_aluno,
				co_aluno_situacao,
				in_reserva_vagas,
				in_compl_estagio,
				in_compl_extensao,
				in_compl_monitoria,
				in_compl_pesquisa,
				in_bolsa_estagio,
				in_bolsa_monitoria,
				in_bolsa_pesquisa,
				in_bolsa_extensao,
				count(t1.co_curso) over (partition by co_aluno) as num_cursos,
				2012 as ano
		from dm_aluno_2012 t1
		inner join dm_curso_2012 t2 on t1.co_curso=t2.co_curso
		where t1.co_ies=2 and t1.co_modalidade_ensino=1 and t1.co_nivel_academico=1 and not(co_aluno_situacao=5 and tp_atributo_ingresso=1)
	),

	num_ies_2012 as (
		select 	count(distinct co_ies) as num_ies,
				co_aluno
		from dm_aluno_2012
		group by co_aluno
	),

	docentes_2012 as (
		select	distinct 
				co_curso,
				count(case when co_situacao_docente=1 then 1 end) over (partition by t1.co_curso) as doc_exercicio,
				count(case when co_situacao_docente=2 then 1 end) over (partition by t1.co_curso) as doc_qualifcacao,
				count(case when co_situacao_docente=3 then 1 end) over (partition by t1.co_curso) as doc_exer_outro_org,
				count(case when co_situacao_docente=4 then 1 end) over (partition by t1.co_curso) as doc_afastado_outro,
				count(case when co_situacao_docente=5 then 1 end) over (partition by t1.co_curso) as doc_afas_saude,
				count(case when co_escolaridade_docente=1 then 1 end) over (partition by t1.co_curso) as doc_sem_grad,
				count(case when co_escolaridade_docente=2 then 1 end) over (partition by t1.co_curso) as doc_graduacao,
				count(case when co_escolaridade_docente=3 then 1 end) over (partition by t1.co_curso) as doc_especializacao,
				count(case when co_escolaridade_docente=4 then 1 end) over (partition by t1.co_curso) as doc_mestrado,
				count(case when co_escolaridade_docente=5 then 1 end) over (partition by t1.co_curso) as doc_doutorado,
				count(case when co_regime_trabalho=1 then 1 end) over (partition by t1.co_curso) as doc_integ_de,
				count(case when co_regime_trabalho=2 then 1 end) over (partition by t1.co_curso) as doc_integ_sem_de,
				count(case when co_regime_trabalho=3 then 1 end) over (partition by t1.co_curso) as doc_temp_parcial,
				count(case when co_regime_trabalho=4 then 1 end) over (partition by t1.co_curso) as doc_horista,
				count(case when co_nacionalidade_docente=1 then 1 end) over (partition by t1.co_curso) as doc_brasileiro,
				count(case when co_nacionalidade_docente=2 then 1 end) over (partition by t1.co_curso) as doc_brasileiro_nat,
				count(case when co_nacionalidade_docente=3 then 1 end) over (partition by t1.co_curso) as doc_estrangeiro
		from docente_curso_2012 t1 
		inner join dm_docente_2012 t2 on t1.co_docente=t2.co_docente
		where t1.co_ies=2
	),

	alunos_2013 as (
		select 	distinct 
				t1.co_aluno,
				t1.nu_cpf,
				t1.co_ies,
				t2.ds_categoria_administrativa,
				t2.ds_organizacao_academica,
				t1.co_curso,
				extract(year from dt_ingresso_curso) as ano_ing,
				case when extract(month from dt_ingresso_curso)<=6 then 1 else 2 end as semestre_ingresso,
				COALESCE(t2.qt_vagas_principal_integral,0) + COALESCE(t2.qt_vagas_principal_matutino,0) + COALESCE(t2.qt_vagas_principal_noturno,0) + COALESCE(t2.qt_vagas_principal_vespertino,0) as vagas,
				COALESCE(t2.qt_inscritos_principal_matu,0) + COALESCE(t2.qt_inscritos_principal_vesp,0) + COALESCE(t2.qt_inscritos_principal_noturno,0) + COALESCE(t2.qt_inscritos_principal_inte,0) as candidatos, 
				t1.co_ocde_area_geral,
				case when t1.co_ocde_area_geral in (4,5) then 1 /*Exatas*/
					 when t1.co_ocde_area_geral in (6,7) then 2 /*Saude*/
					 when t1.co_ocde_area_geral in (1,2,3,8) then 3 /*Humanas*/
				end as areas_3,
				tp_atributo_ingresso as ABI,
				in_integral_curso,
				in_matutino_curso,
				in_vespertino_curso,
				in_noturno_curso,
				nu_integralizacao_integral,
				nu_integralizacao_matutino,
				nu_integralizacao_vespertino,
				nu_integralizacao_noturno,
				co_nacionalidade_aluno,
				co_aluno_situacao,
				in_reserva_vagas,
				in_compl_estagio,
				in_compl_extensao,
				in_compl_monitoria,
				in_compl_pesquisa,
				in_bolsa_estagio,
				in_bolsa_monitoria,
				in_bolsa_pesquisa,
				in_bolsa_extensao,
				count(t1.co_curso) over (partition by co_aluno) as num_cursos,
				2013 as ano
		from dm_aluno_2013 t1
		inner join dm_curso_2013 t2 on t1.co_curso=t2.co_curso
		where t1.co_ies=2 and t1.co_modalidade_ensino=1 and t1.co_nivel_academico=1 and not(co_aluno_situacao=5 and tp_atributo_ingresso=1)
	),

	num_ies_2013 as (
		select 	count(distinct co_ies) as num_ies,
				co_aluno
		from dm_aluno_2013
		group by co_aluno
	),

	docentes_2013 as (
		select	distinct 
				co_curso,
				count(case when co_situacao_docente=1 then 1 end) over (partition by t1.co_curso) as doc_exercicio,
				count(case when co_situacao_docente=2 then 1 end) over (partition by t1.co_curso) as doc_qualifcacao,
				count(case when co_situacao_docente=3 then 1 end) over (partition by t1.co_curso) as doc_exer_outro_org,
				count(case when co_situacao_docente=4 then 1 end) over (partition by t1.co_curso) as doc_afastado_outro,
				count(case when co_situacao_docente=5 then 1 end) over (partition by t1.co_curso) as doc_afas_saude,
				count(case when co_escolaridade_docente=1 then 1 end) over (partition by t1.co_curso) as doc_sem_grad,
				count(case when co_escolaridade_docente=2 then 1 end) over (partition by t1.co_curso) as doc_graduacao,
				count(case when co_escolaridade_docente=3 then 1 end) over (partition by t1.co_curso) as doc_especializacao,
				count(case when co_escolaridade_docente=4 then 1 end) over (partition by t1.co_curso) as doc_mestrado,
				count(case when co_escolaridade_docente=5 then 1 end) over (partition by t1.co_curso) as doc_doutorado,
				count(case when co_regime_trabalho=1 then 1 end) over (partition by t1.co_curso) as doc_integ_de,
				count(case when co_regime_trabalho=2 then 1 end) over (partition by t1.co_curso) as doc_integ_sem_de,
				count(case when co_regime_trabalho=3 then 1 end) over (partition by t1.co_curso) as doc_temp_parcial,
				count(case when co_regime_trabalho=4 then 1 end) over (partition by t1.co_curso) as doc_horista,
				count(case when co_nacionalidade_docente=1 then 1 end) over (partition by t1.co_curso) as doc_brasileiro,
				count(case when co_nacionalidade_docente=2 then 1 end) over (partition by t1.co_curso) as doc_brasileiro_nat,
				count(case when co_nacionalidade_docente=3 then 1 end) over (partition by t1.co_curso) as doc_estrangeiro
		from docente_curso_2013 t1 
		inner join dm_docente_2013 t2 on t1.co_docente=t2.co_docente
		where t1.co_ies=2
	),

	alunos_2014 as (
		select 	distinct 
				t1.co_aluno,
				t1.nu_cpf,
				t1.co_ies,
				t2.ds_categoria_administrativa,
				t2.ds_organizacao_academica,
				t1.co_curso,
				extract(year from dt_ingresso_curso) as ano_ing,
				case when extract(month from dt_ingresso_curso)<=6 then 1 else 2 end as semestre_ingresso,
				COALESCE(t2.qt_vagas_novas_integral,0) + COALESCE(t2.qt_vagas_novas_matutino,0) + COALESCE(t2.qt_vagas_novas_vespertino,0) + COALESCE(t2.qt_vagas_novas_noturno,0) as vagas,
				COALESCE(t2.qt_insc_vagas_novas_int,0) + COALESCE(t2.qt_insc_vagas_novas_mat,0) + COALESCE(t2.qt_insc_vagas_novas_vesp,0) + COALESCE(t2.qt_insc_vagas_novas_not,0) as candidatos, 
				t1.co_ocde_area_geral,
				case when t1.co_ocde_area_geral in (4,5) then 1 /*Exatas*/
					 when t1.co_ocde_area_geral in (6,7) then 2 /*Saude*/
					 when t1.co_ocde_area_geral in (1,2,3,8) then 3 /*Humanas*/
				end as areas_3,
				tp_atributo_ingresso as ABI,
				in_integral_curso,
				in_matutino_curso,
				in_vespertino_curso,
				in_noturno_curso,
				nu_integralizacao_integral,
				nu_integralizacao_matutino,
				nu_integralizacao_vespertino,
				nu_integralizacao_noturno,
				co_nacionalidade_aluno,
				co_aluno_situacao,
				in_reserva_vagas,
				in_compl_estagio,
				in_compl_extensao,
				in_compl_monitoria,
				in_compl_pesquisa,
				in_bolsa_estagio,
				in_bolsa_monitoria,
				in_bolsa_pesquisa,
				in_bolsa_extensao,
				count(t1.co_curso) over (partition by co_aluno) as num_cursos,
				2014 as ano
		from dm_aluno_2014 t1
		inner join dm_curso_2014 t2 on t1.co_curso=t2.co_curso
		where t1.co_ies=2 and t1.co_modalidade_ensino=1 and t1.co_nivel_academico=1 and not(co_aluno_situacao=5 and tp_atributo_ingresso=1)
	),

	num_ies_2014 as (
		select 	count(distinct co_ies) as num_ies,
				co_aluno
		from dm_aluno_2014
		group by co_aluno
	),

	docentes_2014 as (
		select	distinct 
				co_curso,
				count(case when co_situacao_docente=1 then 1 end) over (partition by t1.co_curso) as doc_exercicio,
				count(case when co_situacao_docente=2 then 1 end) over (partition by t1.co_curso) as doc_qualifcacao,
				count(case when co_situacao_docente=3 then 1 end) over (partition by t1.co_curso) as doc_exer_outro_org,
				count(case when co_situacao_docente=4 then 1 end) over (partition by t1.co_curso) as doc_afastado_outro,
				count(case when co_situacao_docente=5 then 1 end) over (partition by t1.co_curso) as doc_afas_saude,
				count(case when co_escolaridade_docente=1 then 1 end) over (partition by t1.co_curso) as doc_sem_grad,
				count(case when co_escolaridade_docente=2 then 1 end) over (partition by t1.co_curso) as doc_graduacao,
				count(case when co_escolaridade_docente=3 then 1 end) over (partition by t1.co_curso) as doc_especializacao,
				count(case when co_escolaridade_docente=4 then 1 end) over (partition by t1.co_curso) as doc_mestrado,
				count(case when co_escolaridade_docente=5 then 1 end) over (partition by t1.co_curso) as doc_doutorado,
				count(case when co_regime_trabalho=1 then 1 end) over (partition by t1.co_curso) as doc_integ_de,
				count(case when co_regime_trabalho=2 then 1 end) over (partition by t1.co_curso) as doc_integ_sem_de,
				count(case when co_regime_trabalho=3 then 1 end) over (partition by t1.co_curso) as doc_temp_parcial,
				count(case when co_regime_trabalho=4 then 1 end) over (partition by t1.co_curso) as doc_horista,
				count(case when co_nacionalidade_docente=1 then 1 end) over (partition by t1.co_curso) as doc_brasileiro,
				count(case when co_nacionalidade_docente=2 then 1 end) over (partition by t1.co_curso) as doc_brasileiro_nat,
				count(case when co_nacionalidade_docente=3 then 1 end) over (partition by t1.co_curso) as doc_estrangeiro
		from docente_curso_2014 t1 
		inner join dm_docente_2014 t2 on t1.co_docente=t2.co_docente
		where t1.co_ies=2
	),

	unb as (
		select	t1.*,
				t3.num_ies,	
				doc_exercicio,
				doc_qualifcacao,
				doc_exer_outro_org,
				doc_afastado_outro,
				doc_afas_saude,
				doc_sem_grad,
				doc_graduacao,
				doc_especializacao,
				doc_mestrado,
				doc_doutorado,
				doc_integ_de,
				doc_integ_sem_de,
				doc_temp_parcial,
				doc_horista,
				doc_brasileiro,
				doc_brasileiro_nat,
				doc_estrangeiro
		from alunos_2010 t1
		inner join docentes_2010 t2 on t1.co_curso=t2.co_curso
		inner join num_ies_2010 t3 on t1.co_aluno=t3.co_aluno

		union all

		select	t1.*,
				t3.num_ies,	
				doc_exercicio,
				doc_qualifcacao,
				doc_exer_outro_org,
				doc_afastado_outro,
				doc_afas_saude,
				doc_sem_grad,
				doc_graduacao,
				doc_especializacao,
				doc_mestrado,
				doc_doutorado,
				doc_integ_de,
				doc_integ_sem_de,
				doc_temp_parcial,
				doc_horista,
				doc_brasileiro,
				doc_brasileiro_nat,
				doc_estrangeiro
		from alunos_2011 t1
		inner join docentes_2011 t2 on t1.co_curso=t2.co_curso
		inner join num_ies_2011 t3 on t1.co_aluno=t3.co_aluno


		union all

		select	t1.*,
				t3.num_ies,
				doc_exercicio,
				doc_qualifcacao,
				doc_exer_outro_org,
				doc_afastado_outro,
				doc_afas_saude,
				doc_sem_grad,
				doc_graduacao,
				doc_especializacao,
				doc_mestrado,
				doc_doutorado,
				doc_integ_de,
				doc_integ_sem_de,
				doc_temp_parcial,
				doc_horista,
				doc_brasileiro,
				doc_brasileiro_nat,
				doc_estrangeiro
		from alunos_2012 t1
		inner join docentes_2012 t2 on t1.co_curso=t2.co_curso
		inner join num_ies_2012 t3 on t1.co_aluno=t3.co_aluno

		union all

		select	t1.*,
				t3.num_ies,
				doc_exercicio,
				doc_qualifcacao,
				doc_exer_outro_org,
				doc_afastado_outro,
				doc_afas_saude,
				doc_sem_grad,
				doc_graduacao,
				doc_especializacao,
				doc_mestrado,
				doc_doutorado,
				doc_integ_de,
				doc_integ_sem_de,
				doc_temp_parcial,
				doc_horista,
				doc_brasileiro,
				doc_brasileiro_nat,
				doc_estrangeiro
		from alunos_2013 t1
		inner join docentes_2013 t2 on t1.co_curso=t2.co_curso
		inner join num_ies_2013 t3 on t1.co_aluno=t3.co_aluno

		union all

		select	t1.*,
				t3.num_ies,
				doc_exercicio,
				doc_qualifcacao,
				doc_exer_outro_org,
				doc_afastado_outro,
				doc_afas_saude,
				doc_sem_grad,
				doc_graduacao,
				doc_especializacao,
				doc_mestrado,
				doc_doutorado,
				doc_integ_de,
				doc_integ_sem_de,
				doc_temp_parcial,
				doc_horista,
				doc_brasileiro,
				doc_brasileiro_nat,
				doc_estrangeiro
		from alunos_2014 t1
		inner join docentes_2014 t2 on t1.co_curso=t2.co_curso
		inner join num_ies_2014 t3 on t1.co_aluno=t3.co_aluno
	),

	ult_sit as (
		select tab.*
		from (
			select	t1.*,
					max(ano) over (partition by co_aluno,co_curso) as ano_max
			from unb t1
		)tab
		where ano_max=ano
	),

	evasao as (
		select 	t1.*,
				1 as evasao
		from ult_sit t1
		where co_aluno_situacao in (4,5)

		union all

		select 	t2.*,
				0 as evasao
		from ult_sit t2
		where co_aluno_situacao not in (4,5)
	)

	select 	tab2.co_ies,
			tab2.ds_categoria_administrativa,
			tab2.ds_organizacao_academica,
			tab2.co_curso,
			tab2.id_mascara,
			tab2.co_aluno,
			tab2.nu_cpf,
			tab2.semestre_ingresso,
			tab2.ano_ing,
			tab2.vagas,
			tab2.candidatos, 
			tab2.co_ocde_area_geral,
			tab2.areas_3,
			tab2.ABI,
			tab2.in_integral_curso,
			tab2.in_matutino_curso,
			tab2.in_vespertino_curso,
			tab2.in_noturno_curso,
			tab2.nu_integralizacao_integral,
			tab2.nu_integralizacao_matutino,
			tab2.nu_integralizacao_vespertino,
			tab2.nu_integralizacao_noturno,
			tab2.co_nacionalidade_aluno,
			tab2.co_aluno_situacao,
			tab2.in_reserva_vagas,
			tab2.in_compl_estagio,
			tab2.in_compl_extensao,
			tab2.in_compl_monitoria,
			tab2.in_compl_pesquisa,
			tab2.in_bolsa_estagio,
			tab2.in_bolsa_monitoria,
			tab2.in_bolsa_pesquisa,
			tab2.in_bolsa_extensao,
			tab2.num_ies,
			tab2.num_cursos,
			tab2.ano as ano_CES,
			tab2.ano_max2 as ano_ENEM,
			tab2.ano_max,
			tab2.evasao,
			tab2.doc_exercicio,
			tab2.doc_qualifcacao,
			tab2.doc_exer_outro_org,
			tab2.doc_afastado_outro,
			tab2.doc_afas_saude,
			tab2.doc_sem_grad,
			tab2.doc_graduacao,
			tab2.doc_especializacao,
			tab2.doc_mestrado,
			tab2.doc_doutorado,
			tab2.doc_integ_de,
			tab2.doc_integ_sem_de,
			tab2.doc_temp_parcial,
			tab2.doc_horista,
			tab2.doc_brasileiro,
			tab2.doc_brasileiro_nat,
			tab2.doc_estrangeiro,
			--atributos ENEM
			tab2.in_estuda_classe_hospitalar,
			tab2.cod_municipio_residencia,
			tab2.cod_municipio_esc,
			tab2.id_dependencia_adm_esc,
			tab2.id_localizacao_esc,
			tab2.sit_func_esc,
			tab2.idade,
			tab2.tp_sexo,
			tab2.nacionalidade,
			tab2.cod_municipio_nascimento,
			tab2.st_conclusao,
			tab2.ano_concluiu,
			tab2.tp_escola,
			tab2.in_tp_ensino,
			tab2.tp_estado_civil,
			tab2.tp_cor_raca,
			tab2.in_baixa_visao,
			tab2.in_cegueira,
			tab2.in_surdez,
			tab2.in_deficiencia_auditiva,
			tab2.in_surdo_cegueira,
			tab2.in_deficiencia_fisica,
			tab2.in_deficiencia_mental,
			tab2.in_deficit_atencao,
			tab2.in_dislexia,
			tab2.in_gestante,
			tab2.in_lactante,
			tab2.in_idoso,
			tab2.in_autismo,
			tab2.in_sabatista,
			tab2.in_braille,
			tab2.in_ampliada_24,
			tab2.in_ampliada_18,
			tab2.in_ledor,
			tab2.in_acesso,
			tab2.in_transcricao,
			tab2.in_libras,
			tab2.in_leitura_labial,
			tab2.in_mesa_cadeira_rodas,
			tab2.in_mesa_cadeira_separada,
			tab2.in_guia_interprete,
			tab2.in_certificado,
			tab2.cod_municipio_prova,
			tab2.NOTA_CN,
			tab2.NOTA_CH,
			tab2.NOTA_LC,
			tab2.NOTA_MT,
			tab2.nu_nota_comp1,
			tab2.nu_nota_comp2,
			tab2.nu_nota_comp3,
			tab2.nu_nota_comp4,
			tab2.nu_nota_comp5,
			tab2.nu_nota_redacao,
			tab2.q001,
			tab2.q002,
			tab2.q003,
			tab2.q004,
			tab2.q005,
			tab2.q006,
			tab2.q007,
			tab2.q008,
			tab2.q009,
			tab2.q010,
			tab2.q011,
			tab2.q012,
			tab2.q013,
			tab2.q014,
			tab2.q015,
			tab2.q016,
			tab2.q017,
			tab2.q018,
			tab2.q019,
			tab2.q020,
			tab2.q021,
			tab2.q022,
			tab2.q023,
			tab2.q024,
			tab2.q025,
			tab2.q026,
			tab2.q027,
			tab2.q028,
			tab2.q029,
			tab2.q030,
			tab2.q031,
			tab2.q032,
			tab2.q033,
			tab2.q034,
			tab2.q035,
			tab2.q036,
			tab2.q037,
			tab2.q038,
			tab2.q039,
			tab2.q040,
			tab2.q041,
			tab2.q042,
			tab2.q043,
			tab2.q044,
			tab2.q045,
			tab2.q046,
			tab2.q047,
			tab2.q048,
			tab2.q049,
			tab2.q050,
			tab2.q051,
			tab2.q052,
			tab2.q053,
			tab2.q054,
			tab2.q055,
			tab2.q056,
			tab2.q057,
			tab2.q058,
			tab2.q059,
			tab2.q060,
			tab2.q061,
			tab2.q062,
			tab2.q063,
			tab2.q064,
			tab2.q065,
			tab2.q066,
			tab2.q067,
			tab2.q068,
			tab2.q069,
			tab2.q070,
			tab2.q071,
			tab2.q072,
			tab2.q073,
			tab2.q074,
			tab2.q075,
			tab2.q076
	from(
		select	distinct 
				tab.*,
				--enem_empilhado
				t2.nu_ano,
				t2.id_inscricao,
				t2.id_mascara,
				t2.in_estuda_classe_hospitalar,
				t2.cod_municipio_residencia,
				t2.cod_municipio_esc,
				t2.id_dependencia_adm_esc,
				t2.id_localizacao_esc,
				t2.sit_func_esc,
				t2.idade,
				t2.tp_sexo,
				t2.nacionalidade,
				t2.cod_municipio_nascimento,
				t2.st_conclusao,
				t2.ano_concluiu,
				t2.tp_escola,
				t2.in_tp_ensino,
				t2.tp_estado_civil,
				t2.tp_cor_raca,
				t2.in_baixa_visao,
				t2.in_cegueira,
				t2.in_surdez,
				t2.in_deficiencia_auditiva,
				t2.in_surdo_cegueira,
				t2.in_deficiencia_fisica,
				t2.in_deficiencia_mental,
				t2.in_deficit_atencao,
				t2.in_dislexia,
				t2.in_gestante,
				t2.in_lactante,
				t2.in_idoso,
				t2.in_autismo,
				t2.in_sabatista,
				t2.in_braille,
				t2.in_ampliada_24,
				t2.in_ampliada_18,
				t2.in_ledor,
				t2.in_acesso,
				t2.in_transcricao,
				t2.in_libras,
				t2.in_leitura_labial,
				t2.in_mesa_cadeira_rodas,
				t2.in_mesa_cadeira_separada,
				t2.in_guia_interprete,
				t2.in_certificado,
				t2.cod_municipio_prova,
				t2.NOTA_CN,
				t2.NOTA_CH,
				t2.NOTA_LC,
				t2.NOTA_MT,
				t2.nu_nota_comp1,
				t2.nu_nota_comp2,
				t2.nu_nota_comp3,
				t2.nu_nota_comp4,
				t2.nu_nota_comp5,
				t2.nu_nota_redacao,
				t2.q001,
				t2.q002,
				t2.q003,
				t2.q004,
				t2.q005,
				t2.q006,
				t2.q007,
				t2.q008,
				t2.q009,
				t2.q010,
				t2.q011,
				t2.q012,
				t2.q013,
				t2.q014,
				t2.q015,
				t2.q016,
				t2.q017,
				t2.q018,
				t2.q019,
				t2.q020,
				t2.q021,
				t2.q022,
				t2.q023,
				t2.q024,
				t2.q025,
				t2.q026,
				t2.q027,
				t2.q028,
				t2.q029,
				t2.q030,
				t2.q031,
				t2.q032,
				t2.q033,
				t2.q034,
				t2.q035,
				t2.q036,
				t2.q037,
				t2.q038,
				t2.q039,
				t2.q040,
				t2.q041,
				t2.q042,
				t2.q043,
				t2.q044,
				t2.q045,
				t2.q046,
				t2.q047,
				t2.q048,
				t2.q049,
				t2.q050,
				t2.q051,
				t2.q052,
				t2.q053,
				t2.q054,
				t2.q055,
				t2.q056,
				t2.q057,
				t2.q058,
				t2.q059,
				t2.q060,
				t2.q061,
				t2.q062,
				t2.q063,
				t2.q064,
				t2.q065,
				t2.q066,
				t2.q067,
				t2.q068,
				t2.q069,
				t2.q070,
				t2.q071,
				t2.q072,
				t2.q073,
				t2.q074,
				t2.q075,
				t2.q076,
				max(t2.nu_ano) over (partition by t2.nu_cpf) as ano_max2
		from evasao tab
		inner join enem_empilhado t2 on tab.nu_cpf=t2.nu_cpf and tab.ano>=t2.nu_ano
	) tab2
	where ano_max2=nu_ano
);