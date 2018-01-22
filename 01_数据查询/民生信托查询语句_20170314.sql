--DM确认信托报酬
select r.c_stage_code,
       sum(decode(t.l_quarterid, 20161, t.f_trust_pay_sum, 0)) as f_q1,
       sum(decode(t.l_quarterid, 20162, t.f_trust_pay_sum, 0)) as f_q2,
       sum(decode(t.l_quarterid, 20163, t.f_trust_pay_sum, 0)) as f_q3,
       sum(decode(t.l_quarterid, 20164, t.f_trust_pay_sum, 0)) as f_q4
  from tt_kpi_income_quarter t, dim_projectinfo s, dim_stage r
 where s.l_projectid = t.l_projectid
   and t.l_stageid = r.l_stageid
   and s.l_effective_flag = 1
   and substr(t.l_quarterid, 1, 4) = 2016
 group by r.c_stage_code
having sum(t.f_trust_pay_sum) <> 0
order by r.c_stage_code;