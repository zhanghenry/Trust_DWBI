-----------------------------------------------------------------清算项目-----------------------------------------------------------
--清算项目个数
--基于项目信息表
select b.c_proj_type_n, count(*)
  from dim_pb_project_basic a, dim_pb_project_biz b
 where a.l_effective_flag = 1
   and a.l_proj_id = b.l_proj_id
   and nvl(a.l_expiry_date, 20991231) between 20160901 and 20160930
 group by b.c_proj_type_n;

--清算项目个数
--基于项目状态表
select t.c_object_code
  from tt_pb_object_status_m t, dim_pb_object_status s
 where t.l_month_id = 201609
   and t.l_objstatus_id = s.l_objstatus_id
   and t.c_object_type = 'XM'
   and s.l_expiry_tm_flag = 1;

--清算项目规模
select c.c_proj_type_n, round(sum(a.f_decrease_tot) / 100000000, 2)
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
   and nvl(b.l_expiry_date, 20991231) between 20160901 and 20160930
      --and nvl(b.l_expiry_date, 20991231) > 20160930
   and a.l_month_id = 201609
 group by c.c_proj_type_n;   
   
--非交易赎回
select c.c_proj_type_n,c.c_func_type_n,c.c_affair_props_n,
sum(case when b.c_scatype_code = '03' and l_valuation_flag <> 1 then a.f_incurred_agg else 0 end)/100000000 as f_scale
from tt_sr_scale_type_m a ,dim_sr_scale_type b,dim_pb_project_biz c ,dim_pb_project_basic d
where a.l_proj_id = c.l_proj_id 
and c.l_proj_id = d.l_proj_id
and a.l_scatype_id = b.l_scatype_id 
and a.l_month_id = 201606
and nvl(d.l_expiry_date,'20010101') > 20151231
and a.l_month_id >= substr(d.l_effective_date,1,6)
and a.l_month_id < substr(d.l_expiration_date, 1,6)
group by c.c_proj_type_n,c.c_func_type_n,c.c_affair_props_n 
order by c.c_proj_type_n,c.c_func_type_n,c.c_affair_props_n ;

--兑付规模：非估值类赎回
select 
sum(case when b.c_scatype_code = '03' and l_valuation_flag <> 1 then a.f_incurred_eot else 0 end)/100000000 as f_scale
from tt_sr_scale_type_m a ,dim_sr_scale_type b,dim_pb_project_biz c ,dim_pb_project_basic d
where a.l_proj_id = c.l_proj_id 
and c.l_proj_id = d.l_proj_id
and a.l_scatype_id = b.l_scatype_id 
and a.l_month_id = 201606;

--兑付规模：估值类终止项目本年赎回
select d.c_proj_code,
sum( a.f_incurred_eot )/100000000 as f_scale
from tt_sr_scale_type_m a ,dim_sr_scale_type b,dim_pb_project_biz c ,dim_pb_project_basic d
where a.l_proj_id = c.l_proj_id 
and c.l_proj_id = d.l_proj_id
and a.l_scatype_id = b.l_scatype_id 
and c.l_valuation_flag = 1
and b.c_scatype_code = '03'
and nvl(d.l_expiry_date,'20991231') between 20160101 and 20160630
and a.l_month_id = 201606
group by d.c_proj_code;

--终止项目情况
select b.c_proj_code,b.c_proj_name,b.l_expiry_date,
a.f_exist_days,a.f_scale_agg,a.f_trust_cost,a.f_benefic_income,a.f_trust_pay,a.f_cost_rate,a.f_benefic_rate,a.f_pay_rate
from tt_po_rate_proj_d a ,dim_pb_project_basic b ,dim_pb_project_biz c
where a.l_proj_id = b.l_proj_id
and b.l_proj_id = c.l_proj_id
and nvl(b.l_expiry_date,20991231) between 20160101 and 20160630
and a.l_day_id = 20160630
order by b.c_proj_code;

--清算规模
select a.l_proj_id,
       a.f_incurred_agg,
       b.l_proj_id,
       b.c_proj_code,
       b.c_proj_name,
       b.l_expiry_date
  from (select t.l_proj_id, sum(t.f_incurred_agg) as f_incurred_agg
          from tt_sr_scale_type_m t
         where t.l_scatype_id = 1301
           and t.l_month_id = 201608
         group by t.l_proj_id) a,
       (select *
          from dim_pb_project_basic t
         where t.l_dept_id = 2
           and t.l_effective_flag = 1
           and nvl(t.l_expiry_date, '20991231') between 20160101 and
               20160831) b
 where a.l_proj_id = b.l_proj_id;
 
--终止项目情况
select b.c_proj_code,
a.f_scale_agg,
a.f_exist_days,
a.f_trust_cost,
a.f_benefic_income,
a.f_trust_Pay,
a.f_cost_rate,
a.f_benefic_rate,
a.f_benefic_rate 
from tt_po_rate_proj_d a,dim_pb_project_basic b 
where b.l_proj_id = a.l_proj_id 
and  a.l_day_id = 20160630
and nvl(b.l_expiry_date,20991231) between 20160101 and 20160630
order by b.c_proj_code;

 --终止项目明细
with temp_qs as
 (select b.l_proj_id,
         b.c_proj_code,
         b.c_proj_name,
         b.l_expiry_date,
         ROUND(a.f_incurred_agg / 10000, 4) as f_qs
    from (select t.l_proj_id, sum(t.f_incurred_agg) as f_incurred_agg
            from tt_sr_scale_type_m t
           where t.l_scatype_id = 1301
             and t.l_month_id = 201608
           group by t.l_proj_id) a,
         (select *
            from dim_pb_project_basic t
           where t.l_effective_flag = 1
             and nvl(t.l_expiry_date, '20991231') between 20160801 and
                 20160831) b
   where a.l_proj_id = b.l_proj_id)
select d.c_proj_type_n,
       d.c_func_type_n,
       d.c_affair_props_n,
       b.c_proj_code,
       b.c_proj_name,
       round(A.F_SCALE_AGG / 10000, 4),
       c.f_qs,
       A.F_EXIST_DAYS,
       A.F_TRUST_PAY,
       A.F_BENEFIC_INCOME,
       A.F_TRUST_COST,
       A.F_PAY_RATE,
       A.F_BENEFIC_RATE,
       A.F_COST_RATE
  from tt_po_rate_proj_d    a,
       dim_pb_project_basic b,
       temp_qs              c,
       dim_pb_project_biz   d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_proj_id
   and a.l_proj_id = c.l_proj_id
   and a.l_day_id = 20160831
   and nvl(b.l_expiry_date, '20991231') between 20160801 and 20160831;
   
--终止项目明细
with temp_qs as
 (select b.l_proj_id,
         b.c_proj_code,
         b.c_proj_name,
         b.l_expiry_date,
         ROUND(a.f_incurred_agg / 10000, 4) as f_qs
    from (select t.l_proj_id, sum(t.f_incurred_agg) as f_incurred_agg
            from tt_sr_scale_type_m t
           where t.l_scatype_id = 1301
             and t.l_month_id = 201608
           group by t.l_proj_id) a,
         (select *
            from dim_pb_project_basic t
           where t.l_effective_flag = 1
             and nvl(t.l_expiry_date, '20991231') between 20160801 and
                 20160831) b
   where a.l_proj_id = b.l_proj_id)
select d.c_proj_type,
       d.c_proj_type_n,
       d.c_func_type,
       d.c_func_type_n,
       d.c_affair_props,
       d.c_affair_props_n,
       count(*),
       round(sum(A.F_SCALE_AGG) / 10000, 4),
       sum(c.f_qs),
       round(sum(A.F_TRUST_PAY) / 10000, 4),
       round(sum(A.F_BENEFIC_INCOME) / 10000, 4),
       round(sum(a.f_trust_cost) / 10000, 4)
  from tt_po_rate_proj_d    a,
       dim_pb_project_basic b,
       temp_qs              c,
       dim_pb_project_biz   d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_proj_id
   and a.l_proj_id = c.l_proj_id
   and a.l_day_id = 20160831
   and nvl(b.l_expiry_date, '20991231') between 20160801 and 20160831
 group by d.c_proj_type,
          d.c_proj_type_n,
          d.c_func_type,
          d.c_func_type_n,
          d.c_affair_props,
          d.c_affair_props_n
 order by d.c_proj_type, d.c_func_type, d.c_affair_props;

-----------------------------------------------------------------兑付规模-----------------------------------------------------------
select t1.c_dept_name,
       t1.c_proj_code,
       t1.c_proj_name,
       t1.L_valuation_flag,
       t1.f_scale - nvl(t2.f_scale, 0)
  from (select e.c_dept_name,
               d.c_proj_code,
               d.c_proj_name,
               c.L_valuation_flag,
               sum(a.f_incurred_eot) as f_scale
          from tt_sr_scale_type_m   a,
               dim_sr_scale_type    b,
               dim_pb_project_biz   c,
               dim_pb_project_basic d,
               dim_pb_department    e
         where a.l_proj_id = c.l_proj_id
           and c.l_proj_id = d.l_proj_id
           and a.l_scatype_id = b.l_scatype_id
           and d.l_dept_id = e.l_dept_id
           and c.l_valuation_flag = 0
           and b.c_scatype_code = '03'
           and nvl(d.l_expiry_date, '20991231') >= 20160101
           and a.l_month_id = 201608
         group by e.c_dept_name,
                  d.c_proj_code,
                  d.c_proj_name,
                  c.L_valuation_flag) t1,
       (select e.c_dept_name,
               d.c_proj_code,
               d.c_proj_name,
               c.l_valuation_flag,
               sum(a.f_incurred_agg) as f_scale
          from tt_sr_scale_type_m   a,
               dim_sr_scale_type    b,
               dim_pb_project_biz   c,
               dim_pb_project_basic d,
               dim_pb_department    e
         where a.l_proj_id = c.l_proj_id
           and c.l_proj_id = d.l_proj_id
           and a.l_scatype_id = b.l_scatype_id
           and d.l_dept_id = e.l_dept_id
           and c.l_valuation_flag = 0
           and b.c_scatype_code = 'QS'
           and nvl(d.l_expiry_date, '20991231') between 20160101 and
               20160831
           and a.l_month_id = 201608
         group by e.c_dept_name,
                  d.c_proj_code,
                  d.c_proj_name,
                  c.l_valuation_flag) t2
 where t1.c_proj_code = t2.c_proj_code(+)
   and t1.c_dept_name = '资产管理一部'
order by t1.c_dept_name,t1.c_proj_code;