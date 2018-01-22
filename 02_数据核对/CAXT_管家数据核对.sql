--证件号有误
select *
  from cajinfu.t_customer_info t
 where t.credential_no = '35010519830026194X';

--证件号码存在中文括号
select * from cajinfu.t_customer_info t where t.customer_name = '王菡';

--属于会员但会员编号为空
select *
  from cajinfu.t_customer_info t
 where t.is_member = 1
   and t.member_no is null
   and delete_flag = 0;

--同一个经纪人同一个客户，多条记录
select a.customer_id, a.staff_code
  from cajinfu.t_cust_manager_rel a
 group by a.customer_id, a.staff_code
having count(1) > 1;

--经纪人不存在与员工表
select distinct a.staff_code
  from cajinfu.t_cust_manager_rel a
 where not exists (select 1
          from cajinfu.t_staff_info b
         where a.staff_code = b.staff_code)
   and a.delete_flag = '0';

--员工无部门
select *
  from cajinfu.t_staff_info a
 where not exists
 (select 1 from cajinfu.t_organization b where a.org_id = b.org_id);

--份额类型为空
select * from cajinfu.t_share_change_his a where a.share_class is null;

--客户持仓份额为负
select *
  from (select to_char(a.customer_id),
               sum(case
                     when a.business_type in ('124', '135', '142', '145', '150') then
                      a.change_share * -1
                     else
                      a.change_share
                   end) as f_share
          from cajinfu.t_share_change_his a
         where a.business_type in
               ('122', '124', '130', '134', '135', '142', '145', '150')
         group by to_char(a.customer_id)) t
 where t.f_share < 0
 order by t.f_share;
 
select to_char(t.business_type),t.* from cajinfu.t_share_change_his t where to_char(t.Customer_Id) = '20170225041506201900';
