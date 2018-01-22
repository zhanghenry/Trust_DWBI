--经营指标
select b.l_month_id,
       a.c_indic_code,
       a.c_indic_name,
       b.f_indic_actual*round (dbms_random.value(1,1.2),2) as 实际值,
       b.f_indic_budget*round (dbms_random.value(1,1.2),2) as 预算值
  from dim_op_indicator a, tt_op_indicator_m b
 where a.l_indic_id = b.l_indic_id
   and b.l_month_id in(201512,201612)
   order by b.l_month_id,a.c_indic_code;
   
--新增规模
--新成立规模，非交易类申购
--JYXT
select t1.*,t1.f_scale*round (dbms_random.value(1,1.2),2),t2.f_revenue*round (dbms_random.value(1,1.2),2) 
from test1 t1,test2 t2 
where t1.c_proj_code = t2.c_proj_code 
and t1.L_month_id = t2.l_month_id;   

--直投存续个数规模
select t.l_month_id,s.c_proj_code,s.c_proj_name,s.l_expiry_date,t.c_fdsrc_name,t.c_inst_name,t.f_scale*round (dbms_random.value(1,1.2),2)
  from (select a.l_month_id,a.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_fdsrc_proj_m a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_pb_project_basic d
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_proj_id = d.l_proj_id
           and nvl(d.l_expiry_date,20991231) > 20160630
           and a.l_month_id between 201601 and 201612
           and b.c_fdsrc_code like '11%'
           and a.l_proj_id < 1000
           /*and c.c_inst_name not like '%交通银行/
           /*and a.f_balance_eot > 0*/
           group by a.l_month_id,a.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.l_month_id,t.c_inst_name,s.c_proj_code;
   
--银信存续个数规模
select t.l_month_id,s.c_proj_code,s.c_proj_name,s.l_expiry_date,t.c_fdsrc_name,t.c_inst_name,t.f_scale*round (dbms_random.value(1,1.2),2)
  from (select a.l_month_id,a.l_proj_id,b.c_fdsrc_name,c.c_inst_name,count(*),sum(a.f_balance_eot) as f_scale
          from tt_tc_fdsrc_proj_m a,
               dim_tc_fund_source b,
               dim_pb_institution c,
               dim_pb_project_basic d
         where a.l_fdsrc_id = b.l_fdsrc_id
           and a.l_fdsrc_inst_id = c.l_inst_id
           and a.l_proj_id = d.l_proj_id
           and nvl(d.l_expiry_date,20991231) > 20161031
           and a.l_month_id between 201601 and  201612
           and b.c_fdsrc_code like '12%' and a.l_proj_id < 1000
           /*and c.c_inst_name not like '%交通银行/
           /*and a.f_balance_eot > 0*/
           group by a.l_month_id,a.l_proj_id,b.c_fdsrc_name,c.c_inst_name) t,dim_pb_project_basic s
   where t.l_proj_id = s.l_proj_id 
   order by t.l_month_id,t.c_inst_name,s.c_proj_code;