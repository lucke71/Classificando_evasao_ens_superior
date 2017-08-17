create table unb_empilhada_ingressantes as (
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
		where t1.co_ies=2 and t1.co_modalidade_ensino=1 and t1.co_nivel_academico=1
			and extract(year from dt_ingresso_curso)=2010
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
		where t1.co_ies=2 and t1.co_modalidade_ensino=1 and t1.co_nivel_academico=1
			and extract(year from dt_ingresso_curso)=2011
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
		where t1.co_ies=2 and t1.co_modalidade_ensino=1 and t1.co_nivel_academico=1
			and extract(year from dt_ingresso_curso)=2012
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
		where t1.co_ies=2 and t1.co_modalidade_ensino=1 and t1.co_nivel_academico=1
			and extract(year from dt_ingresso_curso)=2013
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
		where t1.co_ies=2 and t1.co_modalidade_ensino=1 and t1.co_nivel_academico=1
			and extract(year from dt_ingresso_curso)=2014
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
	)

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
);