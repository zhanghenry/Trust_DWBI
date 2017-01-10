--项目关键要素
select b.c_proj_code, --项目编码
       b.c_proj_name, --项目名称
       b.l_setup_date, --成立日期
       b.l_expiry_date, --终止日期
       a.c_proj_type, --项目类型
       a.c_proj_type_n, --项目类型说明
       a.c_func_type, --功能分类
       a.c_func_type_n, --功能分类说明
       a.c_affair_props, --事务性质
       a.c_affair_props_n, --事务性质说明
       c.c_inst_name --推荐分行
  from dim_pb_project_biz a, dim_pb_project_basic b, dim_pb_institution c
 where a.l_Proj_id = b.l_proj_id
   and a.l_bankrec_sub = c.l_inst_id(+)
   and b.l_effective_flag = 1
   and nvl(b.l_expiry_date, '20991231') > 20151231
 order by b.c_proj_code, a.l_proj_id;

--项目推荐分行
select c.c_proj_code, c.c_proj_name, b.c_inst_name
  from dim_pb_project_basic c, dim_pb_project_biz a, dim_pb_institution b
 where a.l_proj_id = c.l_proj_id
   and a.l_bankrec_sub = l_inst_Id
   and nvl(C.L_EXPIRY_DATE, '20991231') < 20160601
   and a.l_effective_flag = 1;

--查看具体项目的存续规模对应的委托人
select c.c_cust_name, b.l_proj_id, c.c_cust_tytpe_n, sum(a.f_scale)
  from tt_tc_scale_flow_d   a,
       dim_tc_contract      b,
       dim_ca_customer      c,
       dim_pb_project_basic d
 where a.l_cont_id = b.l_cont_id
   and b.l_settler_id = c.l_cust_id
   and b.l_proj_id = d.l_proj_Id
   and d.l_effective_flag = 1
   and d.c_proj_name like '%稳健1167号%'
 group by c.c_cust_name, b.l_proj_id, c.c_cust_tytpe_n
having sum(a.f_scale) <> 0
 order by c.c_cust_tytpe_n;
 
--按项目类型存续项目个数
select b.c_proj_type_n, count(*)
  from dim_pb_project_basic a, dim_pb_project_biz b
 where a.l_effective_flag = 1
   and a.l_proj_id = b.l_proj_id
   and a.c_proj_phase >= '35'
   and nvl(a.l_expiry_date, 20991231) > 20160930
   and a.l_setup_date <= 20160930
 group by b.c_proj_type_n;

--按项目状态表统计存续项目个数
select t.c_object_code
  from tt_pb_object_status_m t, dim_pb_object_status s
 where t.l_month_id = 201609
   and t.l_objstatus_id = s.l_objstatus_id
   and t.c_object_type = 'XM'
   and s.l_exist_tm_flag = 1;

--类资金池项目
select c.c_dept_name,a.l_proj_id,a.c_proj_code,a.c_proj_name
  from dim_pb_project_basic a, dim_pb_project_biz b, dim_pb_department c
 where a.l_proj_id = b.l_proj_id
   and a.l_dept_id = c.l_dept_id
   and b.l_pool_flag = 1
   and a.l_effective_flag = 1;

--资管项目个数
select distinct a.c_proj_code,a.c_proj_name,c.c_invest_type_n
  from dim_pb_project_basic a, dim_pb_department b, dim_to_book c
 where a.l_dept_id = b.l_dept_id
   and a.l_proj_id = c.l_proj_id
   and c.l_effective_flag = 1
   and b.c_dept_name like '%资产管理%';

--是否场内场外业务
select b.l_pitch_flag, a.*
  from dim_pb_project_basic a, dim_pb_project_biz b
 where a.l_proj_id = b.l_proj_id;  

--部门变更记录查询
select t.c_proj_code,
       t.c_proj_name,
       c.c_dept_name,
       d.c_dept_name,
       t.l_effective_date
  from dim_pb_project_basic t,
       (select *
          from dim_pb_project_basic s
         where s.l_effective_flag = 0
           and substr(S.L_EXPIRATION_DATE, 1, 6) = 201606) b,
       dim_pb_department c,
       dim_pb_department d
 where substr(t.l_effective_date, 1, 6) = 201606
   and t.l_effective_flag = 1
   and t.l_dept_id = c.l_dept_id
   and b.l_dept_id = d.l_dept_id
   and t.c_proj_code = b.c_proj_code
   and t.l_dept_id <> b.l_dept_id; 