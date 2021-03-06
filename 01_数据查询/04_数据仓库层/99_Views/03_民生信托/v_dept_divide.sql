create or replace view v_dept_divide as
(
select    t_xm.l_dayid,
          t_xm.l_proj_id,
          t_xm.l_dept_id     l_dept_id_xm,--项目分成部门
          t_xm.f_divide_rate p_rate,      --项目分成比例
          t_qc.l_divide_id   l_stageid,
          t_qc.l_dept_id     l_dept_id_qc,--期次分成部门
          t_qc.f_divide_rate s_rate       --期次分成比例
          from
   (select d3.l_dayid, d1.l_proj_id, d2.l_dept_id, d1.f_divide_rate
   from dim_pe_divide_scheme d1, dim_pb_department d2, dim_day d3
  where d1.l_object_id = d2.l_dept_id
    and d1.l_expiration_date >= d3.l_dayid
    and d1.c_scheme_type = 'XM'
    and d1.c_object_type = 'BM'
    and d2.l_effective_flag = 1) t_xm ,
   (select d3.l_dayid,
        d1.l_proj_id,
        d1.l_divide_id,
        d2.l_dept_id,
        d1.f_divide_rate
   from dim_pe_divide_scheme d1, dim_pb_department d2, dim_day d3
  where d1.l_object_id = d2.l_dept_id
    and d1.l_expiration_date >= d3.l_dayid
    and d1.c_scheme_type = 'QC'
    and d1.c_object_type = 'BM'
    and d2.l_effective_flag = 1) t_qc

    where t_xm.l_dayid = t_qc.l_dayid
      and t_xm.l_proj_id = t_qc.l_proj_id
      );
