--截止2017年12月31日，财富中心客户经理名下客户，存续份额300以上（含300万）的客户清单。
with temp_fe as
 (select t1.c_fundacco, t1.c_custno, sum(t1.f_remainshares) as f_fe
    from tsharedetail t1
   where t1.d_cdate <= to_date('20171231', 'yyyymmdd')
   group by t1.c_fundacco, t1.c_custno
  having sum(t1.f_remainshares) >= 3000000),
temp_broker as
 (select a.c_brokeraccount, a.c_brokername, b.c_nodecode
    from tfundbroker a, tbrokermanage b, tbrokertree c
   where a.c_brokeraccount = b.c_brokeraccount
     and b.c_nodecode = c.c_nodecode
     and c.c_nodecode like '00011055%')
select tp4.c_fundacco as 理财账号,
       tp1.c_custno as 客户编码,
       tp1.c_custname as 客户名称,
       decode(tp1.c_custtype, '1', '自然人', '机构') as 客户类型,
       (select t.c_caption
          from tdictionary t
         where ((t.l_keyno = 1005 and tp1.c_custtype = '1') or
               (t.l_keyno = 1006 and tp1.c_custtype = '0'))
           and t.c_keyvalue = tp1.c_identitytype
           and t.c_sysname = 'TA') as 证件类型,
       tp1.c_identityno as 证件号码,
       tp3.c_brokeraccount as 理财经理账号,
       tp3.c_brokername as 理财经理姓名,
       tp4.f_fe as 存续份额
  from tcustomerinfo       tp1,
       tfundbrokerrelation tp2,
       temp_broker         tp3,
       temp_fe             tp4
 where tp1.c_custno = tp2.c_custno
   and tp2.c_ismain = 1
   and tp2.c_brokeraccount = tp3.c_brokeraccount
   and tp1.c_custno = tp4.c_custno;

--2017年年度，财富中心客户经理名下客户，购买次数。
with temp_cs as
 (select t1.c_fundacco, t1.c_custno, count(*) as f_cs
    from tconfirm t1
   where to_char(t1.d_cdate, 'yyyy') = '2017'
     and t1.c_businflag in ('50', '02')
   group by t1.c_fundacco, t1.c_custno),
temp_broker as
 (select a.c_brokeraccount, a.c_brokername, b.c_nodecode
    from tfundbroker a, tbrokermanage b, tbrokertree c
   where a.c_brokeraccount = b.c_brokeraccount
     and b.c_nodecode = c.c_nodecode
     and c.c_nodecode like '00011055%')
select tp4.c_fundacco as 理财账号,
       tp1.c_custno as 客户编码,
       tp1.c_custname as 客户名称,
       decode(tp1.c_custtype, '1', '自然人', '机构') as 客户类型,
       (select t.c_caption
          from tdictionary t
         where ((t.l_keyno = 1005 and tp1.c_custtype = '1') or
               (t.l_keyno = 1006 and tp1.c_custtype = '0'))
           and t.c_keyvalue = tp1.c_identitytype
           and t.c_sysname = 'TA') as 证件类型,
       tp1.c_identityno as 证件号码,
       tp3.c_brokeraccount as 理财经理账号,
       tp3.c_brokername as 理财经理姓名,
       tp4.f_cs as 购买次数
  from tcustomerinfo       tp1,
       tfundbrokerrelation tp2,
       temp_broker         tp3,
       temp_cs             tp4
 where tp1.c_custno = tp2.c_custno
   and tp2.c_ismain = 1
   and tp2.c_brokeraccount = tp3.c_brokeraccount
   and tp1.c_custno = tp4.c_custno;

--2017年年度，财富中心客户经理名下新增客户（017年内新增的客户）在017年底存续份额
with temp_fe as
 (select t1.c_fundacco, t1.c_custno, sum(t1.f_remainshares) as f_fe
    from tsharedetail t1
   where t1.d_cdate <= to_date('20171231', 'yyyymmdd')
   group by t1.c_fundacco, t1.c_custno),
temp_gm as
 (select t1.c_fundacco, t1.c_custno, min(t1.d_cdate) as min_cdate
    from tconfirm t1
   where t1.c_businflag in ('50', '02')
   group by t1.c_fundacco, t1.c_custno),
temp_broker as
 (select a.c_brokeraccount, a.c_brokername, b.c_nodecode
    from tfundbroker a, tbrokermanage b, tbrokertree c
   where a.c_brokeraccount = b.c_brokeraccount
     and b.c_nodecode = c.c_nodecode
     and c.c_nodecode like '00011055%')
select tp4.c_fundacco as 理财账号 tp1.c_custno as 客户编码 tp1.c_custname as 客户名称 decode(tp1.c_custtype, '1', '自然人', '机构') as 客户类型,
       (select t.c_caption
          from tdictionary t
         where ((t.l_keyno = 1005 and tp1.c_custtype = '1') or
               (t.l_keyno = 1006 and tp1.c_custtype = '0'))
           and t.c_keyvalue = tp1.c_identitytype
           and t.c_sysname = 'TA') as 证件类型,
       tp1.c_identityno as 证件号码,
       tp3.c_brokeraccount as 理财经理账号,
       tp3.c_brokername as 理财经理姓名,
       tp4.f_fe as 存续份额
  from tcustomerinfo       tp1,
       tfundbrokerrelation tp2,
       temp_broker         tp3,
       temp_fe             tp4,
       temp_gm             tp5
 where tp1.c_custno = tp2.c_custno
   and tp2.c_ismain = 1
   and tp2.c_brokeraccount = tp3.c_brokeraccount
   and tp1.c_custno = tp4.c_custno
   and tp1.c_custno = tp5.c_custno
   and to_char(min_cdate, 'yyyy') = '2017';
