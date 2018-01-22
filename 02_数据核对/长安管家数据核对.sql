--总客户数量
--业务源
select count(*) as f_value
  from cajinfu.t_customer_info t
 where t.delete_flag = 0
   and ((trunc(t.create_time) <= to_date('20161231', 'yyyymmdd') and
       'D' = :C_CHECK_FREQ) or (to_char(t.create_time, 'yyyymm') <=
       '201612' and 'M' = :C_CHECK_FREQ));

--DOCK层
select count(*) as f_value
  from tcr_customer t
 where 1 = 1
   and t.d_create <= to_date('20161231', 'yyyymmdd');

--EDW层
select sum(a.f_count_agg)
  from tt_ca_count_cust_m a, dim_ca_behavior b, dim_ca_customer c
 where a.l_beha_id = b.l_beha_id
   and a.l_cust_id = c.l_cust_id
   and b.c_beha_code = 'KH_XX_SS_CJ'
   and a.l_month_id = 201612
 group by c.c_cust_type_n;
	   
--事实客户数量
--业务源
select count(*) as f_value
  from cajinfu.t_customer_info t
 where t.delete_flag = 0
   and t.customer_flag = '1'
   and trunc(t.create_time) <= to_date('20161231', 'yyyymmdd');

--DOCK层
select count(*) as f_value
  from tcr_customer t
 where t.c_cust_cate = '1'
   and t.d_create <= to_date('20161231', 'yyyymmdd');   

--EDW层
select sum(a.f_count_agg)
  from tt_ca_count_cust_m a, dim_ca_behavior b, dim_ca_customer c
 where a.l_beha_id = b.l_beha_id
   and a.l_cust_id = c.l_cust_id
   and b.c_beha_code = 'KH_XX_SS_CJ'
   and a.l_month_id = 201612
   and c.c_cust_cate = 'SS'
 group by c.c_cust_cate,c.c_cust_cate_n;   

--潜在客户数量
select count(*) as f_value
  from cajinfu.t_customer_info t
 where t.delete_flag = 0
   and t.customer_flag = '0'
   and trunc(t.create_time) <= to_date('20161231', 'yyyymmdd');

--个人客户数量
select count(*) as f_value
  from cajinfu.t_customer_info t
 where t.customer_type = '1'
   and t.delete_flag = 0
   and trunc(t.create_time) <= to_date('20161231', 'yyyymmdd');
   
--机构客户数量
select count(*) as f_value
  from cajinfu.t_customer_info t
 where t.customer_type = '0'
   and t.delete_flag = 0
   and trunc(t.create_time) <= to_date('20161231', 'yyyymmdd');

--会员数量
select count(*) as f_value
  from cajinfu.t_customer_info t
 where t.is_member = 1
   and t.delete_flag = '0'
   and trunc(t.create_time) <= to_date('20161231', 'yyyymmdd');

--网上信托
select count(*) as f_value
  from cajinfu.t_customer_info t, cajinfu.t_user_info t1
 where t1.IS_OPEN_TRUST = '3'
   and t.delete_flag = '0' and t.is_member = 1
   and t.customer_id = t1.customer_id
   and trunc(t.create_time) <= to_date('20161231', 'yyyymmdd');

--本年认购规模
select sum(a.change_share) / 100000000 as f_value
  from cajinfu.t_share_change_his a
 where to_char(a.business_type) in ('120', '130')
   and to_char(a.create_time, 'YYYY') = '2016';

--本年申购规模
select sum(a.change_share) / 100000000 as f_value
  from cajinfu.t_share_change_his a
 where to_char(a.business_type) in ('122')
   and to_char(a.create_time, 'YYYY') = '2016';

--本年赎回规模
select sum(a.change_share) / 100000000 as f_value
  from cajinfu.t_share_change_his a
 where to_char(a.business_type) in ('024', '124', '142', '145', '150')
   and to_char(a.create_time, 'YYYY') = '2016';

--
select * from cajinfu.t_share_change_his;

select distinct to_char(t.change_status),to_char(t.business_type) from cajinfu.t_share_change_his t;

