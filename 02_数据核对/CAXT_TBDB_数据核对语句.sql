select * from fa_fundinfo t where t.c_projcode = '201630801467';

select * from fa_subject t where t.c_fundid = '4987' and t.c_subcode = '1132090101006196';

select * from fa_subprop t where t.c_subprop = '1132330101';

select t.c_subcode,t.c_subname, sum(t.f_debit - t.f_credit)
  from fa_vouchers t
 where t.c_subcode like '1%'
   and t.c_fundid = '5045'
   and t.d_busi <= to_date('20161231', 'yyyymmdd')
   and t.l_state < 32
 group by t.c_subcode,t.c_subname;

select * from fa_fundinfo t where t.c_fundid in( '1893','1892');

select * from fa_ttjzt_map t where t.l_ztbh in ('5045','1893');

select count(*) from fa_ttjzt_map t where t.l_tjzt = 3160
