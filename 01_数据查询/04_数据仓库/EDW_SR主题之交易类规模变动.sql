-----------------------------------------------------------------交易类规模变动-----------------------------------------------------------
select c.c_proj_code,
       c.c_proj_name,
       round(sum(decode(b.c_scatype_code, '02', a.f_incurred_tot, 0)) /
             10000,
             2) as 申购,
       round(sum(decode(b.c_scatype_code, '03', a.f_incurred_tot, 0)) /
             10000,
             2) as 赎回
  from tt_sr_scale_type_d   a,
       dim_sr_scale_type    b,
       dim_pb_project_basic c,
       dim_pb_project_biz   d
 where a.l_scatype_id = b.l_scatype_id
   and a.l_proj_id = c.l_proj_id
   and c.l_proj_id = d.l_proj_id
   and c.l_effective_flag = 1
   and d.l_valuation_flag = 1
   and B.C_SCATYPE_CLASS = 'XTHTGM'
   and b.c_scatype_code in ('02', '03')
   and a.f_incurred_tot <> 0
   and a.l_day_id >= 20161001
   and a.l_day_id <= 20161010
 group by c.c_proj_code, c.c_proj_name;