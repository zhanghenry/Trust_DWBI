--私募投行业务语句查询
select sum(t.f_balance_agg)/100000000 as f_eot, --存续规模
        sum(case when b.l_pool_flag = 0 and substr(y.l_setup_date,1,6) between substr(t.l_month_id,1,4)||'01' and t.l_month_id then t.f_balance_agg else 0 end)/100000000 as f_ieot,
        sum(case when b.l_pool_flag = 0 and substr(x.l_begin_date,1,6) = t.l_month_id then t.f_balance_agg else 0 end)/100000000 as f_itot  --
from tt_ic_invest_cont_m t, dim_ic_contract x, dim_pb_product y, dim_pb_project_basic a, dim_pb_project_biz b, dim_month c, dim_pb_department d
      where t.l_cont_id = x.l_cont_id and x.l_prod_id = y.l_prod_id and a.l_dept_id = d.l_dept_id
           and y.l_proj_id = a.l_proj_id and a.l_proj_id = b.l_proj_id and t.l_month_id = c.month_id
           and c.month_id = to_char(To_Date('28-02-2018', 'dd-mm-yyyy'),'yyyymm')
           and x.l_invown_flag in (0)
           and d.c_dept_code not in ('841', '0_1001')
and ( (nvl(b.c_special_type, '0') = 'A' and  x.c_busi_type <> '1')
        or (nvl(x.c_cont_type,'XN') = 'XN')
        or (nvl(b.c_special_type, '0') <> 'A' ))
and substr(x.l_effective_date,1,6) <= t.l_month_id
and substr(x.l_expiration_date,1,6) > t.l_month_id;