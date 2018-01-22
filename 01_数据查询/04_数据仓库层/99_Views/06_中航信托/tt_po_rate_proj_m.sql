create or replace view tt_po_rate_proj_m as
select a.l_month_id, a.l_proj_id, a.f_exist_days,
       a.f_scale_agg, a.f_trust_cost, a.f_benefic_income, a.f_trust_pay
  from (
select t.l_day_id, substr(t.l_day_id,1,6) as l_month_id,
       t.l_proj_id, t.f_exist_days,
       t.f_scale_agg, t.f_trust_cost, t.f_benefic_income, t.f_trust_pay,
       row_number() over(partition by t.l_proj_id, substr(t.l_day_id,1,6) order by t.l_day_id) as rn
  from tt_po_rate_proj_d t ) a where a.rn = 1;