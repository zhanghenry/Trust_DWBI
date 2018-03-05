with temp_50 as (select t2.c_proj_code,sum(t1.f_scale) as f_50 from tde_scale_change t1 ,tde_stage t2 where t1.c_stage_code = t2.c_stage_code and t1.c_scatype_code = '50' group by t2.c_proj_code)
select a.c_proj_code,a.c_proj_name,a.c_cy_code,a.d_setup,a.d_expiry,b.c_dept_name,C.C_EMP_NAME,d.f_50
from tde_project a ,tde_department b,tde_employee c,temp_50 d
where nvl(A.d_expiry,to_date('20991231','yyyymmdd')) > to_date('20180630','yyyymmdd')
and a.c_dept_code = b.c_dept_id and A.C_TSTMGR_CODE = C.C_EMP_ID
and a.c_proj_code = d.c_proj_code;

with temp_50 as (select t3.c_proj_code,t2.l_period,sum(t1.f_tshares) as f_50 from tta_trust_order t1,tta_trust_contract t2,tde_product t3  where t1.c_pactid = t2.c_pactid and t2.c_fundcode = t3.c_prod_code and   t1.c_busiflag = '50' group by t3.c_proj_code,t2.l_period)
select a.c_proj_code,a.c_proj_name,a.c_cy_code,f.l_period,a.d_setup,a.d_expiry,b.c_dept_name,C.C_EMP_NAME,d.f_50
from tde_project a ,tde_department b,tde_employee c,temp_50 d,tde_product e,tta_trust_contract f
where nvl(A.d_expiry,to_date('20991231','yyyymmdd')) > to_date('20180630','yyyymmdd')
and a.c_dept_code = b.c_dept_id and A.C_TSTMGR_CODE = C.C_EMP_ID
and e.c_prod_code = f.c_fundcode
and a.c_proj_code = d.c_proj_code
and nvl(f.l_period,0) = nvl(d.l_period,0);