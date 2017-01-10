--查看是否有历史的项目的属性与当前有效项目的属性不一致
select t1.c_proj_code, t1.c_proj_name
  from (select a.c_proj_code,
               a.c_proj_name,
               b.c_Manage_Type,
               b.c_manage_type_n,
               b.c_proj_type,
               b.c_proj_type_n,
               b.c_func_type,
               b.c_func_type_n,
               b.c_affair_props,
               b.c_affair_props_n
          from dim_pb_project_basic a, dim_pb_project_biz b
         where a.l_effective_flag = 0
           and a.l_proj_id = b.l_proj_id) t1,
       (select a.c_proj_code,
               a.c_proj_name,
               b.c_Manage_Type,
               b.c_manage_type_n,
               b.c_proj_type,
               b.c_proj_type_n,
               b.c_func_type,
               b.c_func_type_n,
               b.c_affair_props,
               b.c_affair_props_n
          from dim_pb_project_basic a, dim_pb_project_biz b
         where a.l_effective_flag = 1
           and a.l_proj_id = b.l_proj_id) t2
 where t1.c_proj_code = t2.c_proj_code
   and dbms_utility.get_hash_value(t1.c_manage_type || t1.c_manage_type_n ||
                                   t1.c_proj_type || t1.c_proj_type_n ||
                                   t1.c_func_type || t1.c_func_type_n ||
                                   t1.c_affair_props || t1.c_affair_props_n,
                                   0,
                                   power(2, 30)) <>
       dbms_utility.get_hash_value(t2.c_manage_type || t2.c_manage_type_n ||
                                   t2.c_proj_type || t2.c_proj_type_n ||
                                   t2.c_func_type || t2.c_func_type_n ||
                                   t2.c_affair_props || t2.c_affair_props_n,
                                   0,
                                   power(2, 30));

--TA和FA规模比较
select t1.c_proj_code   as 项目编码,
       t1.c_proj_name   as 项目名称,
       t1.l_setup_date  as 成立日期,
       t1.f_balance_agg as TA规模,
       t2.f_balance_agg as FA规模
  from (select b.l_proj_id,
               b.c_proj_code,
               b.c_proj_name,
               b.l_setup_date,
               sum(a.f_scale) as f_balance_agg
          from tt_sr_scale_flow_d   a,
               dim_pb_project_basic b,
               dim_sr_scale_type    c
         where a.l_proj_id = b.l_proj_id
           and a.l_scatype_id = c.l_scatype_id
           and C.C_SCATYPE_CLASS = 'XTHTGM'
           and a.l_change_date <= 20170105
           and B.L_CY_ID = 1
         group by b.l_proj_id, b.c_proj_code, b.c_proj_name, b.l_setup_date) t1
  full outer join (select d.l_proj_id,
                          d.c_proj_code,
                          d.c_proj_name,
                          d.l_setup_date,
                          sum(a.f_balance) as f_balance_agg
                     from tt_to_accounting_flow_d a,
                          dim_to_subject          b,
                          dim_to_book             c,
                          dim_pb_project_basic    d
                    where a.l_subj_id = b.l_subj_id
                      and a.l_book_id = c.l_book_id
                      and c.l_proj_id = d.l_proj_id
                      and b.c_subj_code like '4001%'
                      and a.l_busi_date <= 20170105
                      and d.L_CY_ID = 1
                    group by d.l_proj_id,
                             d.c_proj_code,
                             d.c_proj_name,
                             d.l_setup_date) t2
    on t1.l_proj_id = t2.l_proj_id
 where t1.f_balance_agg <> t2.f_balance_agg
 order by t1.l_setup_date;
