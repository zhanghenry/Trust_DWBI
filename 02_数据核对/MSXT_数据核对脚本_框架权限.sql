select U.*, o.c_nodevalue, '1' as c_assignstatus
  from hsi_user u
  left join hsi_usergroup up
    on up.l_userid = u.l_userid
  left join tbrokertree o
    on o.c_nodeid = u.c_nodeid
 where up.l_groupid = 1;
 
select t.c_usercode from hsi_user t,dataedw.dim_pb_employee t1 where t.c_usercode = t1.c_name_abbr and t1.l_effective_flag = 1 group by t.c_usercode having count(*) > 1;
 
update hsi_user t set t.c_userno = (select t1.c_emp_code from dataedw.dim_pb_employee t1 where t.c_usercode = t1.c_name_abbr and t1.l_effective_flag = 1)
 where t.c_usercode not in ('yinjianju','chenyong','liyan','guoshuwen','null','zhaodong')
 
 select t.l_userid from tfundbroker t group by t.l_userid having count(*) > 1;

select * from tfundbroker t where t.l_userid  = '6';

select * from dataedw.dim_pb_employee t where t.c_name_abbr = 'xufeiqing';

select t1.l_userid from tfundbroker t,hsi_user t1 where substr(t.c_brokeraccount,4) = t1.c_userno group by t1.l_userid having count(*) > 1

update tfundbroker t
   set t.l_userid =
       (select t1.l_userid
          from hsi_user t1
         where substr(t.c_brokeraccount, 4) = t1.c_userno)
 where exists (select 1
          from hsi_user t2
         where substr(t.c_brokeraccount, 4) = t2.c_userno and t.l_userid <> t2.l_userid);
         
delete from tfundbroker t where t.c_brokeraccount in (         
select t.c_brokeraccount
  from tfundbroker t, dataedw.dim_pb_employee t1
 where substr(t.c_brokeraccount, 4) = t1.c_emp_code
   and t1.l_effective_flag = 1
   and t1.c_emp_status <> '0'); -- t.l_userid in (6,257,130,515,644);

delete from hsi_user t where t.l_userid in (   
select t.l_userid
  from hsi_user t, dataedw.dim_pb_employee t1
 where t.c_userno = t1.c_emp_code
   and t1.l_effective_flag = 1
   and t1.c_emp_status <> '0' );

--是否存在不一样的员工编号   
select a.c_usercode
  from hsi_user a, dataedw.dim_pb_employee b
 where a.c_usercode = b.c_name_abbr
   and b.l_effective_flag = 1
   and b.c_emp_status = '0'
   and a.c_userno <> b.c_emp_code
 group by a.c_usercode;
 
--是否存在未配置的用户
select * from hsi_user t where not exists(select 1 from dataedw.dim_pb_employee t1 where t.c_userno = t1.c_emp_code and t1.l_effective_flag = 1 and t1.c_emp_status = '0');

--
select * from dataedw.dim_pb_employee t where not exists(select 1 from hsi_user t1 where t1.c_userno = t.c_emp_code) and t.l_effective_flag = 1 and t.c_emp_status = '0';

--
select * from tfundbroker a where not exists(select 1 from hsi_user b where a.l_userid = b.l_userid);

--
select * from hsi_user a where not exists(select 1 from tfundbroker b where a.l_userid = b.l_userid);

--
select * from hsi_usergroup a where not exists(select 1 from hsi_user b where a.l_userid = b.l_userid);
select * from hsi_user a where not exists(select 1 from hsi_usergroup b where a.l_userid = b.l_userid) and a.c_username not like '%公共资源账户%';

select * from hsi_usergroup t where t.l_groupid = 49;

select rowid,t.* from tfundbroker t where t.c_brokername = '李明明';

select * from hsi_user t where t.c_username = '徐斐清';

select * from hsi_usergroup t where t.l_userid = 337;

delete  from hsi_user t where t.c_usercode = 'null' and exists(select 1 from dataedw.dim_pb_employee t1 where t.c_username = t1.c_emp_name and t1.c_emp_status = '0');

select * from hsi_user t where t.c_username = '吴敏';

select * from hsi_usergroup t where t.l_userid = 381;

select * from tfundbroker t where t.l_userid = 381;
