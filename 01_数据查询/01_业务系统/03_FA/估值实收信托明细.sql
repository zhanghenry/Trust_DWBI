--估值实收信托
select b.vc_code,
       sum(a.en_credit - a.en_debit),
       sum(decode(c.vc_name, '优先级受益人', a.en_credit - a.en_debit, 0)) as 优先,
       sum(decode(c.vc_name, '次级受益人', a.en_credit - a.en_debit, 0)) as 次级
  from vjk_fk_vouchers a, tfundinfo b, taccount c
 where a.l_fundid = b.l_fundid
   and a.vc_code like '4001%'
   and a.l_fundid = c.l_fundid
   and a.vc_code = c.vc_code
      --and a.l_fundid = 7023
   and a.d_make <= to_date('20170430', 'yyyymmdd')
   and a.l_state <> 32
 group by b.vc_code, c.vc_code, c.vc_name;