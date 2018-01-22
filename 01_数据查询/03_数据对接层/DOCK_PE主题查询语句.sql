select t.c_stage_code,
       sum(case
             when t.c_ietype_code like '%BC_1Q%' then
              t.f_amount
             else
              0
           end) as f_q1,
       sum(case
             when t.c_ietype_code like '%BC_1Q%' or
                  t.c_ietype_code like '%BC_2Q%' then
              t.f_amount
             else
              0
           end) as f_q2,
       sum(case
             when t.c_ietype_code not like '%BC_4Q%' then
              t.f_amount
             else
              0
           end) as f_q3,
       sum(case
             when t.c_ietype_code like '%BC_4Q%' then
              t.f_amount
             else
              0
           end) as f_q4

  from tde_ie_change t
 where t.c_ietype_code like '%KH%BC%'
   and t.d_change between to_date('20160101', 'yyyymmdd') and
       to_date('20161231', 'yyyymmdd')
 group by t.c_stage_code;