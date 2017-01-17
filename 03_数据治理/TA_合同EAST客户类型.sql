
--针对信托合同中的c_eastcusttype字段进行数据体检；
--如果委托人实际为银行等金融机构，则EAST客户类型原则上不应该为0，即非金融机构；
select b.c_tano         as 理财账号,
       b.c_clientname   as 委托人姓名,
       b.c_clientkind   as 委托人类型,
       b.c_idtype       as 证件类型,
       b.c_idcard       as 证件号码,
       a.l_serialno     as 合同序列号,
       a.c_eastcusttype as east客户类型--0：普通机构,非金融机构和各类基金性质资金
  from ttrustcontractdetails a, hstdc.cm_client b
 where a.c_fundacco = b.c_tano
   and (b.c_clientname like '%银行%' or b.c_clientname like '%基金%' or b.c_clientname like '%保险%' or b.c_clientname like '%信托%')
   and exists (select 1
          from ttrustcontractdetails c
         where a.l_serialno = c.l_serialno
           and c.c_eastcusttype = '0');

--非银行委托人（名字包含银行或合作社的），资金来源是银行理财或银行自有的		   
select b.c_tano         as 理财账号,
       b.c_clientname   as 委托人姓名,
       b.c_clientkind   as 委托人类型,
       b.c_idtype       as 证件类型,
       b.c_idcard       as 证件号码,
       a.l_serialno     as 合同序列号,
       a.c_eastcusttype as east客户类型--0：普通机构,非金融机构和各类基金性质资金
  from ttrustcontractdetails a, hstdc.cm_client b
 where a.c_fundacco = b.c_tano
   and (b.c_clientname not like '%银行%' and b.c_clientname not like '%合作%社%' )
   and exists (select 1
          from ttrustcontractdetails c
         where a.l_serialno = c.l_serialno
           and c.c_eastcusttype in ('2','3'));