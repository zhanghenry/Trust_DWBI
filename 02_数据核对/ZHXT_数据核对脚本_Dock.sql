--dock规模
select a.c_prod_code,
       sum(case
             when a.c_busi_type in ('03', '15', '71') then
              a.f_trade_share * -1
             else
              a.f_trade_share
           end)
  from tta_trust_order a
 where a.c_order_status = '9'
   and a.d_confirm <= to_date('20170630', 'yyyymmdd')
   and a.c_busi_type <> '74'
 group by a.c_prod_code
having sum(case
  when a.c_busi_type in ('03', '15', '71') then
   a.f_trade_share * -1
  else
   a.f_trade_share
end) <> 0;

select t.c_busi_type, sum(t.f_trade_share)
  from tta_trust_order t
 where t.c_prod_code = 'ZH0A9Y'
   and t.d_confirm <= to_date('20170630', 'yyyymmdd')
 group by t.c_busi_type;
 
--dock收入
select * from tam_order a where a.c_order_type = 'SZ' and a.d_plan ; 

