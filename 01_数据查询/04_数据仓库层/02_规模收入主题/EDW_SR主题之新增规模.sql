-----------------------------------------------------------------新增项目----------------------------------------------------------------
--新增项目个数
--按照项目信息表
select b.c_proj_type_n, count(*)
  from dim_pb_project_basic a, dim_pb_project_biz b
 where a.l_effective_flag = 1
   and a.l_proj_id = b.l_proj_id
   and a.c_proj_phase >= '35'
   and nvl(a.l_setup_date, 20991231) between 20160901 and 20160930
 group by b.c_proj_type_n;

--新增项目个数
--按照项目状态表
select t.c_object_code
  from tt_pb_object_status_m t, dim_pb_object_status s
 where t.l_month_id = 201609
   and t.l_objstatus_id = s.l_objstatus_id
   and t.c_object_type = 'XM'
   and s.l_setup_tm_flag = 1; 
 
--新增项目个数，按期限，需要确认期限都维护准确
select case
         when nvl(c.l_time_limit, 99) <= 12 then
          '一年期以内 else ' 一年期以上
       end 期限,
       count(*)
  from tt_sr_scale_proj_d a, dim_sr_project_junk b, dim_pb_project_basic c
 where a.l_proj_id = c.l_proj_id
   and a.L_PROJ_JUNK_ID = b.L_PROJ_JUNK_ID
   and a.l_proj_id = c.l_proj_id
   and a.l_day_id = 20160630
   and b.l_setup_ty_flag = 1
 group by case
            when nvl(c.l_time_limit, 99) <= 12 then
             '一年期以内 else ' 一年期以上
          end;

--新增项目个数，按期限明细	
select c.c_proj_code,
       c.c_proj_name,
       case
         when nvl(c.l_time_limit, 99) <= 12 then
          '一年期以内 else ' 一年期以上
       end 期限,
       count(*),
       sum(a.f_increase_eot)
  from tt_sr_scale_proj_d a, dim_sr_project_junk b, dim_pb_project_basic c
 where a.l_proj_id = c.l_proj_id
   and a.L_PROJ_JUNK_ID = b.L_PROJ_JUNK_ID
   and a.l_proj_id = c.l_proj_id
   and a.l_day_id = 20160630
   and b.l_setup_ty_flag = 1
 group by c.c_proj_code,
          c.c_proj_name,
          case
            when nvl(c.l_time_limit, 99) <= 12 then
             '一年期以内 else ' 一年期以上
          end;

--新增项目规模
select sum(a.f_increase_eot)
  from tt_sr_scale_stage_d a, dim_sr_stage b
 where a.l_stage_id = b.l_stage_id
   and B.L_SETUP_DATE > 20151231
   and a.l_day_id = 20160630;

--新增规模
--新成立规模，非交易类申购
--JYXT
select c.c_proj_type,
       c.c_proj_type_n,
       c.c_func_type,
       c.c_func_type_n,
       c.c_affair_props,
       c.c_affair_props_n,
       sum(case
             when b.c_scatype_code = '50' then
              a.f_incurred_eot
             when b.c_scatype_code = '02' and l_valuation_flag <> 1 then
              a.f_incurred_eot
             else
              0
           end) / 100000000 as f_scale
  from tt_sr_scale_type_m   a,
       dim_sr_scale_type    b,
       dim_pb_project_biz   c,
       dim_pb_project_basic d
 where a.l_proj_id = c.l_proj_id
   and c.l_proj_id = d.l_proj_id
   and a.l_scatype_id = b.l_scatype_id
   and a.l_month_id = 201608
 group by c.c_proj_type,
          c.c_proj_type_n,
          c.c_func_type,
          c.c_func_type_n,
          c.c_affair_props,
          c.c_affair_props_n
 order by c.c_proj_type, c.c_func_type, c.c_affair_props;   
   
--新增规模
--排除类资金池项目
--ZHXT
select c.c_proj_type_n, round(sum(a.f_increase_tot) / 100000000, 2)
  from tt_tc_scale_cont_m   a,
       dim_tc_contract      d,
       dim_pb_product       e,
       dim_pb_project_basic b,
       dim_pb_project_biz   c
 where a.l_proj_id = b.l_proj_id
   and a.l_cont_id = d.l_cont_id
   and a.l_prod_id = e.l_prod_id
   and b.l_proj_id = c.l_proj_id
   and substr(d.l_effective_date, 1, 6) <= 201609
   and substr(d.l_expiration_date, 1, 6) > 201609
   and e.l_setup_date between 20160101 and 20160930
   and c.l_pool_flag = 0
      --and nvl(b.l_expiry_date, 20991231) > 20160930
   and a.l_month_id = 201609
 group by c.c_proj_type_n;   
  