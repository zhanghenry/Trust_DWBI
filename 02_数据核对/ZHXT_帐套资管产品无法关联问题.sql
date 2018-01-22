--项目主表上的不存在于ta的产品
select t.c_fundcode, t.c_Projectcode
  from tproject_info_tcmp t
 where not exists
 (select 1 from hstdc.ta_fundinfo s where t.c_fundcode = s.c_fundcode) and t.c_fundcode like 'ZH%';

--估值和资管中不存在于ta的产品
select *
  from hstdc.fa_fundinfo a
 where not exists
 (select 1 from hstdc.ta_fundinfo b where a.c_fundcode = b.c_fundcode)
   and a.l_astype <> 1
   and a.l_void = 0
   and a.c_projcode is not null
   and exists(select 1 from dataedw.dim_to_book c where a.c_fundid = c.c_book_code and c.l_prod_id <> 0);

select *
  from datadock.tfa_book a
 where not exists
 (select 1 from hstdc.ta_fundinfo b where a.c_prod_code = b.c_fundcode)
   and exists (select 1
          from tproject_info_tcmp c
         where a.c_prod_code = c.c_fundcode);

--资管合同的产品不存在与TA
select *
  from hstdc.am_pact a
 where not exists
 (select 1 from hstdc.ta_fundinfo b where a.c_fundcode = b.c_fundcode)
   and a.c_fundcode like 'ZH%'
   and  exists(select 1 from tproject_info_tcmp c where a.c_fundcode = c.c_fundcode);

--资管合同中的产品不存在与TA且不存在与TCMP主产品
select *
  from datadock.tam_contract a
 where not exists (select 1
          from datadock.tde_product b
         where a.c_prod_code = b.c_prod_code) and a.c_prod_code like 'ZH%'
         and not exists(select 1 from tproject_info_tcmp c where a.c_prod_code = c.c_fundcode);

--非投资指令有合同
select s.c_prod_code,t.c_prod_code,t.*
  from datadock.tam_order t,datadock.tam_contract s
 where t.c_order_type = 'TZ' and t.c_cont_code = s.c_cont_code(+)
   and t.c_cont_code is not null and t.c_prod_code <> s.c_prod_code;

select t.d from datadock.tde_project t where t.c_proj_code = 'AVICTC2013X0778';

select * from datadock.tde_product;

select s.c_fundcode,t.* from hstdc.fa_fundinfo t,hstdc.ta_fundinfo s where t.c_fundcode = s.c_fundcode(+) and t.c_projcode = 'AVICTC2015X1083';
select * from datadock.tam_contract t where t.c_cont_name like '%天盛11号%';


select * from datadock.tfa_book t where t.c_book_code = '200152';
select * from dataedw.dim_to_book t where t.c_book_code = '200152';

--母帐套找不到对应产品
AVICTC2015X1164
AVICTC2014X0641
AVICTC2015X1057
AVICTC2015X1075
AVICTC2016X0773
AVICTC2015X1083
