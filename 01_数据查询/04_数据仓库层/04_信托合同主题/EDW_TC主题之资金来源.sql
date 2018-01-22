--合同资金来源属性信息	
select a.l_cont_id,
       a.c_cont_code,
       b.c_proj_code,
       b.l_expiry_date,
       a.l_fdsrc_id,
       c.c_fdsrc_name,
       a.l_fdsrc_inst_id,
       d.c_inst_name,
       A.C_LINKED_CONT_CODE,
       a.l_alltransfer_flag,
       a.l_effective_date,
       a.l_expiration_date,
       a.l_effective_flag,
       a.l_data_date
  from dim_tc_contract a, dim_pb_project_basic b,dim_tc_fund_source c,dim_pb_institution d
 where a.l_proj_id = b.l_proj_id and a.l_fdsrc_id = c.l_fdsrc_id(+) and a.l_fdsrc_inst_id = d.l_inst_id(+)
   and b.c_proj_code = 'G133';

--合同资金来源及对应规模
select b.c_cont_code,
       s.c_proj_code,
       s.c_proj_name,
       e.c_cust_name,
       c.c_fdsrc_name,
       d.c_inst_name,
       sum(t.f_scale)
  from tt_tc_scale_flow_d   t,
       dim_tc_contract      b,
       dim_pb_project_basic s,
       dim_tc_fund_source   c,
       dim_pb_institution   d,
       dim_ca_customer      e
 where t.l_cont_id = b.l_cont_id
   and b.l_proj_id = s.l_proj_id
   and b.l_settler_id = e.l_cust_id(+)
   and nvl(b.l_fdsrc_Id, 0) = c.l_fdsrc_id(+)
   and nvl(b.l_fdsrc_inst_id, 0) = d.l_inst_id(+)
   and s.c_proj_name like '%稳健1304号%'
   and t.l_change_date <= 20160831
   and b.l_expiration_date > 20160831
 group by b.c_cont_code,
          s.c_proj_code,
          s.c_proj_name,
          e.c_cust_name,
          c.c_fdsrc_name,
          d.c_inst_name
 order by s.c_proj_code,
          s.c_proj_name,
          e.c_cust_name,
          c.c_fdsrc_name,
          d.c_inst_name;   
   
--从流水表汇总资金来源对应规模
--最准确
select s.c_proj_code,
       s.c_proj_name,
       c.c_fdsrc_name,
       d.c_inst_name,
       round(sum(t.f_scale) / 10000, 2)
  from tt_tc_scale_flow_d   t,
       dim_tc_contract      b,
       dim_pb_project_basic s,
       dim_tc_fund_source   c,
       dim_pb_institution   d
 where t.l_cont_id = b.l_cont_id
   and b.l_proj_id = s.l_proj_id
   and nvl(b.l_fdsrc_Id, 0) = c.l_fdsrc_id(+)
   and nvl(b.l_fdsrc_inst_id, 0) = d.l_inst_id(+)
   and s.c_proj_name like '%融正78号%'
      --and c.c_fdsrc_code like '11%'
   and t.l_change_date <= 20160930
   and b.l_expiration_date > 20160930
 group by s.c_proj_code, s.c_proj_name, c.c_fdsrc_name, d.c_inst_name
 order by s.c_proj_code, s.c_proj_name, c.c_fdsrc_name, d.c_inst_name;

--行外机构资金变动
select s.c_proj_code,
       s.c_proj_name,
       c.c_fdsrc_name,
       d.c_inst_name,
       round(sum(t.f_scale) / 10000, 2)
  from tt_tc_scale_flow_d   t,
       dim_tc_contract      b,
       dim_pb_project_basic s,
       dim_tc_fund_source   c,
       dim_pb_institution   d
 where t.l_cont_id = b.l_cont_id
   and b.l_proj_id = s.l_proj_id
   and nvl(b.l_fdsrc_Id, 0) = c.l_fdsrc_id(+)
   and nvl(b.l_fdsrc_inst_id, 0) = d.l_inst_id(+)
   and t.l_change_date between 20161201 and 20161209
 group by s.c_proj_code, s.c_proj_name, c.c_fdsrc_name, d.c_inst_name
 order by s.c_proj_code, s.c_proj_name, c.c_fdsrc_name, d.c_inst_name; 
 
-----------------------------------------------------------------资金来源枚举-------------------------------------------------------
select s.c_proj_code as 项目编码,s.c_proj_name as 项目名称,d.c_proj_type_n as 项目类型,d.c_func_type_n as 功能分类,e.c_inst_name as 分行,
       sum(case when b.l_fdsrc_inst_id = 13 then 1 else 0 end) as 是否来源交行,
       sum(decode(c.l_fdsrc_id, 1, t.f_scale, 0)) as 银行资金,
       sum(decode(c.l_fdsrc_id, 2, t.f_scale, 0)) as 银行直投资金,
       sum(decode(c.l_fdsrc_id, 3, t.f_scale, 0)) as 银行自有,
       sum(decode(c.l_fdsrc_id, 4, t.f_scale, 0)) as 银行自有转,
       sum(decode(c.l_fdsrc_id, 5, t.f_scale, 0)) as 直投施罗德转,
       sum(decode(c.l_fdsrc_id, 6, t.f_scale, 0)) as 银行理财资金,
       sum(decode(c.l_fdsrc_id, 7, t.f_scale, 0)) as 银行理财,
       sum(decode(c.l_fdsrc_id, 8, t.f_scale, 0)) as 银行理财转,
       sum(decode(c.l_fdsrc_id, 9, t.f_scale, 0)) as 银行理财代收,
       sum(decode(c.l_fdsrc_id, 10, t.f_scale, 0)) as 施罗德过桥无代收,
       sum(decode(c.l_fdsrc_id, 11, t.f_scale, 0)) as 企业年金,
       sum(decode(c.l_fdsrc_id, 12, t.f_scale, 0)) as 年金,
       sum(decode(c.l_fdsrc_id, 13, t.f_scale, 0)) as 非银行资金,
       sum(decode(c.l_fdsrc_id, 14, t.f_scale, 0)) as 证券资金,
       sum(decode(c.l_fdsrc_id, 15, t.f_scale, 0)) as 基金资金,
       sum(decode(c.l_fdsrc_id, 16, t.f_scale, 0)) as 保险资金,
       sum(decode(c.l_fdsrc_id, 17, t.f_scale, 0)) as 信托资金自有资金,
       sum(decode(c.l_fdsrc_id, 18, t.f_scale, 0)) as 信托资金受托资金, 
       sum(decode(c.l_fdsrc_id, 19, t.f_scale, 0)) as 资管资金交银,
       sum(decode(c.l_fdsrc_id, 20, t.f_scale, 0)) as 资管资金非交银,
       sum(decode(c.l_fdsrc_id, 21, t.f_scale, 0)) as 企业自有,
       sum(decode(c.l_fdsrc_id, 22, t.f_scale, 0)) as 个人自有,
       sum(decode(c.l_fdsrc_id, 23, t.f_scale, 0)) as 社保资金,
       sum(decode(c.l_fdsrc_id, 24, t.f_scale, 0)) as 社会团体资金,
       sum(decode(c.l_fdsrc_id, 25, t.f_scale, 0)) as 集团财务公司自有,
       sum(decode(c.l_fdsrc_id, 26, t.f_scale, 0)) as 组合资金,
       sum(decode(c.l_fdsrc_id, 27, t.f_scale, 0)) as 资产证券化
  from (select a.l_cont_id,
               decode(sum(a.f_scale), 0, 1, sum(f_scale)) as f_scale
          from tt_tc_scale_flow_d a
         where a.l_change_date <= 20161031
         group by a.l_cont_Id) t,
       dim_tc_contract b,
       dim_pb_project_basic s,
       dim_tc_fund_source c,
       dim_pb_project_biz d,
       dim_pb_institution e
 where t.l_cont_id = b.l_cont_id
   and b.l_proj_id = s.l_proj_id
   and s.l_proj_id = d.l_proj_id
   and nvl(b.l_fdsrc_Id, 0) = c.l_fdsrc_id(+)
   and nvl(d.l_bankrec_sub,0) = e.l_inst_id(+)
   and b.l_expiration_date > 20161031
--and s.c_proj_code = 'F466'
    group by s.c_proj_code,s.c_proj_name,d.c_proj_type_n,d.c_func_type_n,e.c_inst_name
    order by s.c_proj_code,s.c_proj_name,d.c_proj_type_n,d.c_func_type_n,e.c_inst_name;