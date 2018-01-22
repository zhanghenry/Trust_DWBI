-----------------------------------------------------------------直投银信----------------------------------------------------------

--新增直投个数-本年成立项目中有直投的
select count(distinct a.l_proj_id) from tt_tc_fdsrc_stage_m a,dim_tc_fund_source b,dim_pb_project_basic c 
where a.l_fdsrc_id = b.l_fdsrc_id 
and a.l_proj_id = c.l_proj_Id
and a.l_month_id = 201705 
and c.l_setup_date 
between 20170101 and 20170531
and b.c_fdsrc_code like '11%';

--新增银信个数—本年成立项目中有银信的
select count(distinct a.l_proj_id) from tt_tc_fdsrc_stage_m a,dim_tc_fund_source b,dim_pb_project_basic c 
where a.l_fdsrc_id = b.l_fdsrc_id 
and a.l_proj_id = c.l_proj_id
and a.l_month_id = 201705 
and c.l_setup_date 
between 20170101 and 20170531
and b.c_fdsrc_code like '12%';

--新增直投规模—本年成立期次对应的直投规模
select sum(a.f_increase_eot)/100000000 from tt_tc_fdsrc_stage_m a,dim_tc_fund_source b,dim_sr_stage c 
where a.l_fdsrc_id = b.l_fdsrc_id
and a.l_stage_Id = c.l_stage_id
and a.l_month_id = 201705 
and c.l_setup_date 
between 20170101 and 20170531
and b.c_fdsrc_code like '11%';

--新增银信规模—本年成立期次对应的银信规模
select sum(a.f_increase_eot)/100000000 from tt_tc_fdsrc_stage_m a,dim_tc_fund_source b,dim_sr_stage c 
where a.l_fdsrc_id = b.l_fdsrc_id
and a.l_stage_Id = c.l_stage_id
and a.l_month_id = 201705 
and c.l_setup_date 
between 20170101 and 20170531
and b.c_fdsrc_code like '12%';

--本年新增银信/直投个数
select s.c_proj_code,s.c_proj_name,s.l_setup_date,t.c_fdsrc_name,t.c_inst_name
  from (select a.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_scale_inst_d a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_pb_project_basic d
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_proj_id = d.l_proj_id
           and substr(d.l_setup_date,1,4) = 2016
           and a.l_day_id = 20160630
           and b.c_fdsrc_code like '11%'
           and c.c_inst_name like '%交通银行'
           /*and a.f_balance_eot > 0*/
           group by a.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.c_inst_name,s.c_proj_code;

--本年新增银信/直投规模，项目
select s.c_proj_code,s.c_proj_name,s.l_setup_date,t.c_fdsrc_name,t.c_inst_name,t.f_scale
  from (select a.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_scale_inst_d a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_pb_project_basic d
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_proj_id = d.l_proj_id
           and a.l_day_id = 20160630
           and b.c_fdsrc_code like '11%'
           and c.c_inst_name like '%交通银行'
           /*and a.f_balance_eot > 0*/
           and exists(select 1 from dim_sr_stage e,dim_pb_project_basic f 
                      where e.l_proj_id = f.l_proj_id 
                      and d.c_proj_code = f.c_proj_code 
                      and substr(e.l_setup_date,1,4) = 2016)
           group by a.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.c_inst_name,s.c_proj_code;

--本年新增银信/直投规模，期次
select s.c_proj_code,s.c_proj_name,s.l_setup_date,t.c_fdsrc_name,t.c_inst_name,t.f_scale
  from (select e.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_fdsrc_stage_d a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_sr_stage d,
               dim_pb_project_basic e
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_stage_id = d.l_stage_id
           and d.l_proj_id = e.l_proj_id
           and a.l_day_id = 20160630
           and b.c_fdsrc_code like '12%'
           and c.c_inst_name like '%交通银行%'
           /*and a.f_balance_eot > 0*/
           and substr(d.l_setup_date,1,4) = 2016
           group by e.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.c_inst_name,s.c_proj_code;

--存续个数规模
select s.c_proj_code,s.c_proj_name,s.l_expiry_date,t.c_fdsrc_name,t.c_inst_name,t.f_scale
  from (select a.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_scale_inst_d a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_pb_project_basic d
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_proj_id = d.l_proj_id
           and nvl(d.l_expiry_date,20991231) > 20160630
           and a.l_day_id = 20160630
           and b.c_fdsrc_code like '11%'
           /*and c.c_inst_name not like '%交通银行/
           /*and a.f_balance_eot > 0*/
           group by a.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.c_inst_name,s.c_proj_code;
   
--存续个数规模
select s.c_proj_code,s.c_proj_name,s.l_expiry_date,t.c_fdsrc_name,t.c_inst_name,t.f_scale
  from (select a.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_fdsrc_proj_m a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_pb_project_basic d
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_proj_id = d.l_proj_id
           and nvl(d.l_expiry_date,20991231) > 20161031
           and a.l_month_id = 201610
           and b.c_fdsrc_code like '12%'
           /*and c.c_inst_name not like '%交通银行/
           /*and a.f_balance_eot > 0*/
           group by a.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.c_inst_name,s.c_proj_code;