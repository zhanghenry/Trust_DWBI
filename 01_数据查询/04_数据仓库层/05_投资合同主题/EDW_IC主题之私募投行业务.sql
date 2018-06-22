--私募投行业务语句查询
SELECT
  --存续规模
  sum(t.f_balance_agg) / 100000000 AS f_eot,
  sum(CASE WHEN b.l_pool_flag = 0 AND
                substr(y.l_setup_date, 1, 6) BETWEEN substr(t.l_month_id, 1, 4) || '01' AND t.l_month_id
    THEN t.f_balance_agg
      ELSE 0 END) / 100000000      AS f_ieot,
  sum(CASE WHEN b.l_pool_flag = 0 AND substr(x.l_begin_date, 1, 6) = t.l_month_id
    THEN t.f_balance_agg
      ELSE 0 END) / 100000000      AS f_itot
FROM
  tt_ic_invest_cont_m t, dim_ic_contract x, dim_pb_product y, dim_pb_project_basic a, dim_pb_project_biz b, dim_month c,
  dim_pb_department d
WHERE t.l_cont_id = x.l_cont_id AND x.l_prod_id = y.l_prod_id AND a.l_dept_id = d.l_dept_id
      AND y.l_proj_id = a.l_proj_id AND a.l_proj_id = b.l_proj_id AND t.l_month_id = c.month_id
      AND c.month_id = to_char(To_Date('28-02-2018', 'dd-mm-yyyy'), 'yyyymm')
      AND x.l_invown_flag IN (0)
      AND d.c_dept_code NOT IN ('841', '0_1001')
      AND ((nvl(b.c_special_type, '0') = 'A' AND x.c_busi_type <> '1')
           OR (nvl(x.c_cont_type, 'XN') = 'XN')
           OR (nvl(b.c_special_type, '0') <> 'A'))
      AND substr(x.l_effective_date, 1, 6) <= t.l_month_id
      AND substr(x.l_expiration_date, 1, 6) > t.l_month_id;