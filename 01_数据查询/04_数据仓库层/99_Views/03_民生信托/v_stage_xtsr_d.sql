create or replace view v_stage_xtsr_d as
select a.l_day_id as 日期,
       c.l_proj_id as 项目ID,
       c.c_proj_code as 项目编码,
       b.l_stage_id as 期次ID,
       b.c_stage_code as 期次编码,
       sum(decode(d.c_ietype_code, 'XTGDBC', a.f_actual_eoy, 0)) as 本年支付固定报酬,
       sum(decode(d.c_ietype_code, 'XTGDBC', a.f_planned_eoy, 0)) as 本年确认固定报酬,
       sum(decode(d.c_ietype_code, 'XTFDBC', a.f_actual_eoy, 0)) as 本年支付浮动报酬,
       sum(decode(d.c_ietype_code, 'XTFDBC', a.f_planned_eoy, 0)) as 本年确认浮动报酬,
       sum(decode(d.c_ietype_code, 'XTCGF', a.f_planned_eoy, 0)) as 本年确认财顾费
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
