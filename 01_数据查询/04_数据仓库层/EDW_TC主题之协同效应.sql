--分行存续规模
select c.c_proj_code, c.c_proj_name, sum(t.f_balance_eot) as f_scale
  from tt_sr_scale_proj_m   t,
       dim_pb_project_biz   a,
       dim_pb_institution   b,
       dim_pb_project_basic c
 where t.l_proj_id = a.l_proj_id
   and a.l_bankrec_sub = b.l_inst_id
   and a.l_proj_id = c.l_proj_id
   and t.l_month_id =
       to_char(To_Date('31-08-2016', 'dd-mm-yyyy'), 'yyyymm')
   and t.l_month_id >= substr(c.l_effective_date, 1, 6)
   and t.l_month_id < substr(c.l_expiration_date, 1, 6)
   and b.c_inst_name like '%北京%'
 group by c.c_proj_code, c.c_proj_name
having sum(t.f_balance_eot) <> 0;

--分行实际收入
with temp_fdsrc as
 (select row_number() over(partition by t.c_proj_code order by t.c_fdsrc_name) as l_rn,
         t.c_proj_code,
         t.c_fdsrc_name
    from (select c.c_proj_code,
                 case
                   when b.c_fdsrc_code like '11%' and d.c_inst_name = '交通银行' then
                    '1直投'
                   when b.c_fdsrc_code like '12%' and d.c_inst_name = '交通银行' then
                    '2理财'
                   else
                    '3其他'
                 end as c_fdsrc_name
            from tt_tc_fdsrc_proj_m   a,
                 dim_tc_fund_source   b,
                 dim_pb_project_basic c,
                 dim_pb_institution   d
           where a.l_fdsrc_id = b.l_fdsrc_id(+)
             and a.l_proj_id = c.l_proj_id
             and a.l_fdsrc_inst_id = d.l_inst_id(+)
             and a.l_month_id = 201703 --and c.c_proj_code = 'G144'
             ) t),
temp_actual_year as
 (select b.c_proj_code, sum(a.f_actual_tot) as f_actual_year
    from tt_sr_tstrev_proj_m a, dim_pb_project_basic b
   where a.l_proj_id = b.l_proj_id
     and a.l_month_id >= substr(b.l_effective_date, 1, 6)
     and a.l_month_id < substr(b.l_expiration_date, 1, 6)
     and substr(a.l_month_id, 1, 4) = 2017
     and a.l_month_Id <= 201703 --and b.c_proj_code = 'E701'
   group by b.c_proj_code, b.c_proj_name)
select d.c_fdsrc_name,
       c.c_inst_name,
       a.c_proj_code,
       a.c_proj_name,
       b.c_proj_type_n,
       b.c_func_type_n,
       b.c_affair_props_n,
       sum(e.f_actual_year) as f_actual_year
  from dim_pb_project_basic a,
       dim_pb_project_biz   b,
       dim_pb_institution   c,
       temp_fdsrc           d,
       temp_actual_year     e
 where b.l_bankrec_sub = c.l_inst_id
   and a.l_proj_id = b.l_proj_id
      --and nvl(A.L_EXPIRY_DATE,20991231) >= 20160101
   and a.l_effective_flag = 1
   and a.c_proj_code = d.c_proj_code
   and d.l_rn = 1
   and a.c_proj_code = e.c_proj_code
--and a.c_proj_code = 'E701'
 group by d.c_fdsrc_name, c.c_inst_name, a.c_proj_code, a.c_proj_name,b.c_proj_type_n,
       b.c_func_type_n,
       b.c_affair_props_n
 order by d.c_fdsrc_name, c.c_inst_name, a.c_proj_code, a.c_proj_name;

