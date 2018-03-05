--不属于
with temp_scale as
 (select s.c_proj_code, sum(t.f_balance) as f_scale
    from tfa_voucher t, tfa_book s
   where t.c_book_code = s.c_book_code
     and t.c_subj_code like '4001%'
     and t.d_business <= to_date('20170331', 'yyyymmdd')
     and t.c_voucher_status < '32'
   group by s.c_proj_code having sum(t.f_balance) <> 0)
select b.c_dept_code,
       b.c_dept_name,
       b.c_dept_cate_n,
       a.c_proj_code,
       a.c_proj_name,
       c.f_scale
  from tde_project a, tde_department b,temp_scale c
 where a.c_dept_code = b.c_dept_code
   and a.c_proj_code = c.c_proj_code
   and b.c_dept_cate not in ('01', '03', '05', '07');

--潜在客户数量
select count(*) as f_value
  from tcr_customer t
 where t.c_cust_cate = '0'
   and t.d_create <= to_date('20161231', 'yyyymmdd');

--个人客户数量
select count(*) as f_value
  from tcr_customer t
 where t.c_cust_type = '1'
   and t.d_create <= to_date('20161231', 'yyyymmdd');

--机构客户数量
select count(*) as f_value
  from tcr_customer t
 where t.c_cust_type = '0'
   and t.d_create <= to_date('20161231', 'yyyymmdd');

--会员数
select count(*) as f_value
  from tcr_customer t
 where t.l_mbr_flag = 1
   and t.d_create <= to_date('20161231', 'yyyymmdd');

--开通网上信托客户
select count(*) as f_value
  from tcr_customer t
 where t.l_online_flag = 1
   and t.d_create <= to_date('20161231', 'yyyymmdd');

--客户风险等级
select t.c_risk_degree, t.c_risk_degree_n, count(*)
  from tcr_customer t
 group by t.c_risk_degree, t.c_risk_degree_n;

--截止当前份额
--每个客户的持仓份额
select *
  from (select a.c_cust_code,
               sum(case
                     when a.c_busi_type in ('124', '135', '142', '145', '150') then
                      a.f_share * -1
                     else
                      a.f_share
                   end) as f_share
          from tcr_share_change a
         where a.c_busi_type in
               ('122', '124', '130', '134', '135', '142', '145', '150')
         group by a.c_cust_code) t
 where t.f_share < 0;

select distinct t.c_busi_type,t.c_busi_type_n from tcr_share_change t;

select * from tcr_share_change t where t.c_busi_type = 'P07';

select t.d_confirm,
       t.c_busi_type,
       t.c_busi_type_n,
       t.c_prod_code,
       t.f_share
  from tcr_share_change t
 where t.c_cust_code = '20161230090605151212'
 order by t.d_confirm;

select * from tcr_share_change t where not exists(select 1 from tde_product s where t.c_prod_code = s.c_prod_code);

select t.c_chan_code,t.* from tcr_share_change t;

--渠道
select * from tcr_channel;

--经纪人团队
select * from tcr_broker_team;

--经纪人
select * from tcr_broker t where t.c_broker_code = '002098';

--经纪人客户
select * from tcr_broker_cust;

select distinct t.c_broker_code from tcr_broker_cust t where not exists(select 1 from tcr_broker s where t.c_broker_code = s.c_broker_code);

--份额流水
select * from tcr_share_change t where t.c_cust_code = '20161230090323100922';

select t.c_txntype_code, sum(t.f_share)/100000000
  from tcr_share_change t
 where t.c_txntype_code  in ('JY_RG_QR', 'JY_SG_QR', 'JY_SH_QR')
   and to_char(t.d_confirm, 'yyyy') = '2016'
 group by t.c_txntype_code;

select * from tcr_share_change t where t.c_txntype_code = 'JY_SH_SQ';

select * from tde_dict_key t where t.c_dict_code = 'INIT_TRADE_MAPPING';
select * from tde_dict_mapping t where t.c_table_name = 'TCR_SHARE_CHANGE';

select * from tfa_book t where t.c_proj_code = '201110102145';

select * from tfa_subject t where t.c_book_code = '1893';

--科目余额
select t1.c_subj_code,
       t1.c_subj_name,
       t1.c_invest_indus,
       t1.c_fduse_way,
       sum(t.f_debit),
       sum(t.f_credit),
       sum(t.f_balance)
  from tfa_voucher t, tfa_subject t1
 where t.c_subj_code = t1.c_subj_code
   and t.c_book_code = t1.c_book_code
   and t.c_book_code = '1893'
   and t.c_subj_code like '1%'
   and t.d_business <= to_date('20161231','yyyymmdd')
 group by t1.c_subj_code, t1.c_subj_name, t1.c_invest_indus, t1.c_fduse_way;

--项目个数
select count(*) as f_value from tde_project a where 1=1 and a.d_setup <= to_date('20161231','yyyymmdd');

--信托规模
select sum(t.f_balance) as f_value
  from tfa_voucher t
 where t.c_subj_code like '4001%'
   and t.d_business <= to_date('20161231', 'yyyymmdd');

select t1.c_proj_code,sum(t.f_balance) as f_value
  from tfa_voucher t,tfa_book t1
 where t.c_subj_code like '4001%'
   and t.c_book_code = t1.c_book_code
   and t.d_business <= to_date('20161231', 'yyyymmdd')
   group by t1.c_proj_code;

--TA规模
select sum(case
             when a.c_busi_type in ('03', '71') then
              a.f_trade_share * -1
             else
              a.f_trade_share
           end) as f_value
  from tta_trust_order a
 where a.c_busi_type in ('50', '02', '03', '70', '71')
   and a.c_order_status = '9'
   and to_char(a.d_confirm, 'yyyymmdd') <= '20161231';
   
--AM收入
select sum(a.f_actual) as f_value
  from tam_order a
 where a.c_order_type = 'SZ'
   and a.c_ietype_code in ('XTGDBC', 'XTFDBC', 'XTGDCGF', 'XTFDCGF')
   and a.c_order_status = '9'
   and to_char(a.d_actual,'yyyy') = '2016'
   and to_char(a.d_actual, 'yyyymmdd') <= '20161231';
   
--NC信托收入
select tde_project.c_proj_code, sum(tfi_voucher.f_credit) as f_valye
  from tfi_voucher, tde_project
 where tfi_voucher.c_object_type = 'XM'
   and substr(tfi_voucher.c_subj_code, 1, 4) in ('6021', '6051')
   and tfi_voucher.c_object_code = tde_project.c_proj_code
   and to_char(tfi_voucher.d_business, 'yyyy') = 2016
   and to_char(tfi_voucher.d_business, 'yyyymm') <= 201612
 group by tde_project.c_proj_code;


--信托资产
select s.c_proj_code, sum(t.f_balance) as f_value
  from tfa_voucher t, tfa_book s
 where t.c_book_code = s.c_book_code
   and t.c_subj_code like '1%'
   and to_char(t.d_business, 'yyyymm') <= 201703
 group by s.c_proj_code having sum(t.f_balance) <> 0
 order by s.c_proj_code;

--估值规模
select s.c_proj_code, sum(t.f_balance) as f_value
  from tfa_voucher t, tfa_book s
 where t.c_subj_code like '4001%'
   and t.c_book_code = s.c_book_code(+)
   and to_char(t.d_business, 'yyyymm') <= 201703
 group by s.c_proj_code
having sum(t.f_balance) <> 0;

--估值资金运用方式
select /*a.c_book_code,*/
       sum(decode(b.c_fduse_way, 'YYFS_DK', a.f_balance, 0))/100000000 as 贷款,
       sum(decode(b.c_fduse_way, 'YYFS_JYXJRZC', a.f_balance, 0))/100000000 as 交易性金融资产,
       sum(decode(b.c_fduse_way, 'YYFS_KGCSJCYZDQ', a.f_balance, 0))/100000000 as 可供出售及持有至到期,
       sum(decode(b.c_fduse_way, 'YYFS_GQTZ', a.f_balance, 0))/100000000 as 股权投资,
       sum(decode(b.c_fduse_way, 'YYFS_ZL', a.f_balance, 0))/100000000 as 租赁,
       sum(decode(b.c_fduse_way, 'YYFS_MRFS', a.f_balance, 0))/100000000 as 买入返售,
       sum(decode(b.c_fduse_way, 'YYFS_CC', a.f_balance, 0))/100000000 as 拆出,
       sum(decode(b.c_fduse_way, 'YYFS_CFTY', a.f_balance, 0))/100000000 as 存放同业,
       sum(decode(b.c_fduse_way, 'YYFS_QT', a.f_balance, 0))/100000000 as 其他
  from tfa_voucher a, tfa_subject b
 where a.c_book_code = b.c_book_code
 and a.c_subj_code = b.c_subj_code
   and a.d_business <= to_date('20161231','yyyymmdd')
   group by a.c_book_code;

--帐套资产余额
select t.c_book_code, sum(t.f_balance)
  from tfa_voucher t, tfa_subject t1
 where t.c_subj_code = t1.c_subj_code
   and t.c_book_code = t1.c_book_code
      /*   and t.c_book_code = '1893'*/
   and t.c_subj_code like '1%'
  /* and t.c_book_code = '4726'*/
   and t.d_business <= to_date('20161231', 'yyyymmdd')
 group by t.c_book_code;
   
--帐套科目余额   
select t1.c_subj_code,
       t1.c_subj_name,
       sum(t.f_debit),
       sum(t.f_credit),
       sum(t.f_balance)
  from tfa_voucher t, tfa_subject t1
 where t.c_subj_code = t1.c_subj_code
   and t.c_book_code = t1.c_book_code
   and t.c_book_code = '4993'
   and t.c_subj_code like '1%'
   and t.d_business <= to_date('20161231', 'yyyymmdd')
 group by t1.c_subj_code, t1.c_subj_name;
 
--项目收入
select tde_project.c_proj_code, sum(tfi_voucher.f_credit) as f_valye
  from tfi_voucher, tde_project
 where tfi_voucher.c_object_type = 'XM'
   and substr(tfi_voucher.c_subj_code, 1, 4) in ('6021', '6051')
   and tfi_voucher.c_object_code = tde_project.c_proj_code
   and to_char(tfi_voucher.d_business, 'yyyy') = 2017
   and to_char(tfi_voucher.d_business, 'yyyymmdd') <= 20170427
 group by tde_project.c_proj_code
