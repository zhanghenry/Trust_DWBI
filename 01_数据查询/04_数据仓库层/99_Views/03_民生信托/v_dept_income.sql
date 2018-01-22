create or replace view v_dept_income as
select t1.l_day_id,
        dept.c_dept_code_l1,
        dept.c_dept_name_l1,
        dept.c_dept_code,
        dept.c_dept_name,
        MAX(case when d2.l_setup_date >= substr(t1.l_day_id,0,4)||'0101'
        then '新增'
        else '存续' end) as c_status_name,
        d5.l_iestatus_id,
        d5.c_iestatus_name,
        d2.l_stage_id,
        d2.c_stage_code,
        --主动信托报酬
        sum(case
              when d4.c_manage_type = '1' and d1.c_ietype_code_l2 = 'XTBC' then
               t1.f_planned_eoy
              else
               0
            end) f_zd_xtbc,
        --主动财顾费
        sum(case
              when d4.c_manage_type = '1' and d1.c_ietype_code_l2 = 'XTCGF' then
               t1.f_planned_eoy
              else
               0
            end) f_zd_xtcgf,
        --自营分享
        sum(case
              when d4.c_manage_type = '1' and d1.c_ietype_code_l2 = 'TZZYFX' then
               t1.f_planned_eoy
              else
               0
            end) f_zd_xtzy,

        --事务信托报酬
        sum(case
              when d4.c_manage_type = '2' and d1.c_ietype_code_l2 = 'XTBC' then
               t1.f_planned_eoy
              else
               0
            end) f_sw_xtbc,
        --事务财顾费
        sum(case
              when d4.c_manage_type = '2' and d1.c_ietype_code_l2 = 'XTCGF' then
               t1.f_planned_eoy
              else
               0
            end) f_sw_xtcgf,
        --自营分享
        sum(case
              when d4.c_manage_type = '2' and d1.c_ietype_code_l2 = 'TZZYFX' then
               t1.f_planned_eoy
              else
               0
            end) f_sw_xtzy

   from tt_sr_ie_stage_d     t1,
        dim_pb_ie_type       d1,
        dim_pb_ie_status     d5,
        dim_sr_stage         d2,
        dim_pb_project_basic d3,
        dim_pb_project_biz   d4,
        dim_pb_department    dept
  where t1.l_ietype_id = d1.l_ietype_id
    and t1.l_stage_id = d2.l_stage_id
    and d3.l_dept_id = dept.l_dept_id
    and t1.l_proj_id = d3.l_proj_id
    and t1.l_proj_id = d4.l_proj_id
    and t1.l_iestatus_id = d5.l_iestatus_id
    and dept.c_dept_cate = '1'
    and d4.c_busi_scope in ('1', '2') --信托&基金项目
    and dept.l_effective_date <= t1.l_day_id
    and dept.l_expiration_date > t1.l_day_id
    and d5.l_recog_flag = 1
  group by t1.l_day_id,
           dept.c_dept_code_l1,
           dept.c_dept_name_l1,
           dept.c_dept_code,
           dept.c_dept_name,
           d5.l_iestatus_id,
           d5.c_iestatus_name,
           d2.l_stage_id,
           d2.c_stage_code;
