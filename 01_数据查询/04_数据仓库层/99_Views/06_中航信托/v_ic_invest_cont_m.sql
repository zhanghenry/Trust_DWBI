create or replace view v_ic_invest_cont_m as
select ic1.l_month_id,
       ic2.l_cont_id,
       ic2.l_prod_id,
       ic2.l_proj_id,
       ic1.f_balance_agg,
       /*decode(substr(pb1.l_setup_date, 1, 4),
              substr(ic1.l_month_id, 1, 4),
              ic1.f_balance_agg,
              ic1.f_invest_eot) as f_invest_eot,*/
       ic1.f_balance_agg as f_invest_eot,
       ic1.f_return_agg,
       nvl£¨ratio_to_report(ic1.f_balance_agg) OVER(partition by ic1.l_month_id, ic2.l_proj_id),
       1/count(ic1.f_balance_agg)over(partition by ic1.l_month_id, ic2.l_proj_id)) f_invest_ratio
  from (select t.l_month_id,
               t.l_cont_id,
               sum(t.f_balance_agg) as f_balance_agg,
               sum(t.f_invest_eot) as f_invest_eot,
               sum(t.f_return_agg) as f_return_agg
          from tt_ic_invest_cont_m t
         group by t.l_month_id, t.l_cont_id) ic1,
       dim_ic_contract ic2,
       dim_pb_product pb1
 where ic1.l_month_id = 201707
   and ic1.l_cont_id = ic2.l_cont_id
   and ic2.l_prod_id = pb1.l_prod_id
   and substr(ic2.l_effective_date, 1, 6) <= ic1.l_month_id
   and substr(ic2.l_expiration_date, 1, 6) > ic1.l_month_id;
