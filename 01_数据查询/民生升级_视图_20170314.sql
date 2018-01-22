create or replace view v_proj_scale_d as 
with temp_bridge as
 (select t1.l_day_id, t1.l_stage_id, t1.f_scale_eot as f_bridge_eot
    from tt_sr_scale_type_d t1, dim_sr_scale_type t2
   where t1.l_scatype_id = t2.l_scatype_id
     and t2.c_scatype_code = '62')
select c.L_proj_id,
       c.c_Proj_code,
       b.l_stage_id,
       b.c_stage_code,
       a.f_increase_eot,
       a.f_decrease_eot,
       d.f_bridge_eot,
       a.f_balance_eot,
       a.f_balance_agg
  from tt_sr_scale_stage_d a, dim_sr_stage b, dim_pb_project_basic c,temp_bridge d
 where a.l_stage_id = b.l_stage_id
   and b.l_proj_id = c.l_proj_id
   and a.l_day_id = d.l_day_id
   and a.l_stage_id = d.l_stage_id;

select * from v_proj_scale_d;

create or replace view v_proj_xtsr_d as
select a.l_day_id,
       c.l_proj_id,
       c.c_proj_code,
       b.l_stage_id,
       b.c_stage_code,
       sum(decode(d.c_ietype_code, 'XTGDBC', a.f_actual_eoy, 0)) as f_gdbczf_eoy,
       sum(decode(d.c_ietype_code, 'XTGDBC', a.f_planned_eoy, 0)) as f_gdbcqr_eoy,
       sum(decode(d.c_ietype_code, 'XTFDBC', a.f_actual_eoy, 0)) as f_fdbczf_eoy,
       sum(decode(d.c_ietype_code, 'XTFDBC', a.f_planned_eoy, 0)) as f_fdbcqr_eoy
  from tt_sr_ie_stage_d     a,
       dim_sr_stage         b,
       dim_pb_project_basic c,
       dim_pb_ie_type       d
 where a.l_stage_id = b.l_stage_id
   and b.l_proj_id = c.l_proj_id
   and a.l_ietype_id = d.l_ietype_id
 group by a.l_day_id,
          c.l_proj_id,
          c.c_proj_code,
          b.l_stage_id,
          b.c_stage_code;


