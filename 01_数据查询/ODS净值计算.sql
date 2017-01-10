--æª÷µº∆À„
select t2.c_code,
       --t1.d_make,
       sum(case
             when t1.c_code like '4001%' then
              t1.f_credit - t1.f_debit
             else
              0
           end) fLastshares,
       sum(t1.f_credit - t1.f_debit) f_lastasset
  from (select a.l_id,
               a.l_fundid,
               a.l_mainid,
               a.l_year,
               a.l_month,
               a.c_code,
               a.c_fullname,
               a.f_debit,
               a.f_credit,
               a.d_make
          from t_h_vouchers a
         where a.l_state <> 32
           and a.c_code <> '400100'
           and (a.c_code LIKE '6%' or a.c_code LIKE '4%') and a.l_fundid = 1112
        union all
        select b.l_id,
               b.l_fundid,
               b.l_mainid,
               b.l_year,
               b.l_month,
               b.c_code,
               b.c_fullname,
               b.f_debit,
               b.f_credit,
               b.d_make
          from tvouchers b
         where b.l_state <> 32
           and b.c_code <> '400100'
           and (b.c_code LIKE '6%' or b.c_code LIKE '4%')
           and b.l_fundid = 1112
           ) t1,
       taccountsets t2
 where t1.l_fundid = t2.l_fundid 
 and t1.d_make <= to_date('20110831','yyyymmdd')
 group by t2.c_code;

select * from taccountsets t where t.c_code = 'CA01CH';

select  40674153.32/40600000
	 from dual;
