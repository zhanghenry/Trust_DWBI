--存续项目规模按项目类型
--基于信托合同汇总
select c.c_proj_type_n, round(sum(a.f_balance_agg) / 100000000, 2)
  from tt_tc_scale_cont_m   a,
       dim_tc_contract      d,
       dim_pb_project_basic b,
       dim_pb_project_biz   c
 where a.l_proj_id = b.l_proj_id
   and a.l_cont_id = d.l_cont_id
   and b.l_proj_id = c.l_proj_id
      /*and substr(d.l_effective_date, 1, 6) <= 201609
      and substr(d.l_expiration_date, 1, 6) > 201609*/
      --and nvl(b.l_expiry_date, 20991231) > 20160930
   and a.l_month_id = 201609
 group by c.c_proj_type_n;
 
--循环类项目期次数时点规模
select c_proj_code, c_proj_name, l_period, sum(f_scale)
  from (select c.c_proj_code,
               c.c_proj_name,
               b.l_period,
               a.f_scale as f_scale
          from tt_tc_scale_flow_d   a,
               dim_tc_contract      b,
               dim_pb_project_basic c,
               dim_pb_project_biz   d
         where a.l_cont_id = b.l_cont_id
           and b.l_proj_id = c.l_proj_id
           and c.l_proj_id = d.l_proj_id
           and d.l_cycle_flag = 1
           and a.l_scatype_id in (3, 1, 6)
           and a.l_change_date <= 20170331
        --and b.l_proj_id = 524-- and b.l_period= 25
        union all
        select c.c_proj_code,
               c.c_proj_name,
               case
                 when b.l_period is null then
                  (select tt.l_period
                     from dim_tc_contract tt
                    where tt.c_cont_code = b.c_linked_cont_code
                      and tt.l_alltransfer_flag = 1)
                 else
                  b.l_period
               end as l_period,
               a.f_scale
          from tt_tc_scale_flow_d   a,
               dim_tc_contract      b,
               dim_pb_project_basic c,
               dim_pb_project_biz   d
         where a.l_cont_id = b.l_cont_id
           and b.l_proj_id = c.l_proj_id
           and c.l_proj_id = d.l_proj_id
           and d.l_cycle_flag = 1
           and a.l_scatype_id in (2, 7)
           and a.l_change_date <= 20170331
        --and b.l_proj_id = 524 --and b.l_period= 25
        )
 group by c_proj_code, c_proj_name, l_period
 order by c_proj_code, c_proj_name, l_period;