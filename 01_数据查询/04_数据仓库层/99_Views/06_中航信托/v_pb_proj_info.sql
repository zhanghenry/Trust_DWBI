create or replace view v_pb_proj_info as
select pb1.l_proj_id,
       pb3.l_prod_id,
       pb1.c_proj_code          as "项目编号(TCMP)",
       pb1.c_name_full          as "项目名称(TCMP)",
       pb4.c_dept_name          as "业务部门(TCMP)",
       pb2.c_manage_type_n      as "项目管理类型(TCMP)",
       pb2.c_proj_type_n        as "项目类型(TCMP)",
       pb2.c_func_type_n        as "项目功能分类(BULU)",
       pb2.c_invest_indus_n     as "项目实质投向(BULU)",
       to_date(pb1.l_setup_date, 'yyyymmdd')                as "项目开始日期(TCMP)",
       to_date(pb1.l_expiry_date, 'yyyymmdd')               as "项目终止日期(TCMP)",
       to_date(pb1.l_preexp_date, 'yyyymmdd')               as "项目预计到期(TCMP)",
       case when nvl(substr(pb1.l_expiry_date, 1, 6), 209912) > 201707 then  '存续' else '清算' end as "项目状态(TCMP)",
       decode(pb2.l_pool_flag, 0, '否', 1, '是', null)  as "是否资金池(BULU)",
       decode(pb2.c_special_type, 'A', '是', '否')      as "普惠金融(TCMP)",
       decode(pb2.l_pitch_flag, 0, '否', 1, '是', null) as "是否场内场外(TCMP)",
       decode(pb2.l_openend_flag, 0, '否', 1, '是', null) as "是否开放式(TCMP)"
  from dim_pb_project_basic pb1,
       dim_pb_project_biz   pb2,
       dim_pb_product       pb3,
       dim_pb_department    pb4
 where pb1.l_proj_id = pb2.l_proj_id
   and pb1.l_setup_date <= 20170731
   and substr(pb1.l_Effective_Date, 1, 6) <= 201707
   and substr(pb1.l_expiration_date, 1, 6) > 201707
   and pb1.l_proj_id = pb3.l_proj_id
   and pb1.l_dept_id = pb4.l_dept_id;
