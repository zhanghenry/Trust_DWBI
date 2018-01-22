--期次收入
select a.c_stage_code,
       sum(decode(a.c_revtype_code,'XTGDBC', a.f_revenue, 0)),
       sum(decode(a.c_revtype_code,'XTFDBC', a.f_revenue, 0))
  from tde_revenue_change a
 where to_char(a.d_revenue, 'YYYY') = '2016' and a.l_actual_flag = 0
 group by a.c_stage_code;