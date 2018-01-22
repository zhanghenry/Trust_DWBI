-----------------------------------------------------------------解决集团融资规模----------------------------------------------------------
--查询项目是否集团推荐，功能分类，事务性质
select t.c_proj_code,
       s.l_proj_id,
       s.l_grprec_flag,
       s.c_func_type,
       s.c_func_type_n,
       s.c_affair_props,
       s.c_affair_props_n
  from dim_pb_project_basic t, dim_pb_project_biz s
 where t.l_proj_id = s.l_proj_id
   and t.c_proj_name like '%稳健643%';

--联动融资规模，本年新成立+往年二期
SELECT b.c_proj_code,b.c_proj_name,SUM(A.F_INCREASE_EOT) AS F_VALUE
  FROM TT_SR_SCALE_PROJ_M A, DIM_PB_PROJECT_BASIC B, DIM_PB_PROJECT_BIZ C
 WHERE A.L_PROJ_ID = B.L_PROJ_ID 
   AND B.L_PROJ_ID = C.L_PROJ_ID
   AND A.L_MONTH_ID >= SUBSTR(B.L_EFFECTIVE_DATE,1,6)
   AND A.L_MONTH_ID < SUBSTR(B.L_EXPIRATION_DATE,1,6)
   AND C.L_GRPREC_FLAG = 1 AND C.L_BANKREC_SUB IS NOT NULL   
   AND (C.C_FUNC_TYPE = '1' OR
       (C.C_FUNC_TYPE = '3' AND C.C_AFFAIR_PROPS = '1'))
   AND EXISTS (SELECT 1
          FROM DIM_SR_STAGE D,DIM_PB_PROJECT_BASIC E
         WHERE E.L_PROJ_ID = D.L_PROJ_ID
           AND B.C_PROJ_CODE = E.C_PROJ_CODE
           AND D.L_EFFECTIVE_FLAG = 1
           AND SUBSTR(D.L_SETUP_DATE, 1, 4) = 2016)
   AND A.L_MONTH_ID = 201608
   group by b.c_proj_code,b.c_proj_name 
   order by b.c_proj_code,b.c_proj_name;

--联动融资规模统计个数，本年成立的项目，往年二期不算
SELECT b.c_proj_code,b.c_proj_name,d.c_inst_name,SUM(A.F_INCREASE_EOT) AS F_VALUE
  FROM TT_SR_SCALE_PROJ_M A, DIM_PB_PROJECT_BASIC B, DIM_PB_PROJECT_BIZ C,dim_pb_institution d
 WHERE A.L_PROJ_ID = B.L_PROJ_ID 
   AND B.L_PROJ_ID = C.L_PROJ_ID
  and c.l_bankrec_sub= d.l_inst_id
   AND A.L_MONTH_ID >= SUBSTR(B.L_EFFECTIVE_DATE,1,6)
   AND A.L_MONTH_ID < SUBSTR(B.L_EXPIRATION_DATE,1,6)
   AND C.L_GRPREC_FLAG = 1
   AND (C.C_FUNC_TYPE = '1' OR
       (C.C_FUNC_TYPE = '3' AND C.C_AFFAIR_PROPS = '1'))
   AND EXISTS (SELECT 1
          FROM DIM_SR_STAGE D,DIM_PB_PROJECT_BASIC E
         WHERE E.L_PROJ_ID = D.L_PROJ_ID
           AND B.C_PROJ_CODE = E.C_PROJ_CODE
           AND D.L_EFFECTIVE_FLAG = 1
           AND SUBSTR(D.L_SETUP_DATE, 1, 4) = 2016)
   AND A.L_MONTH_ID = 201611
   --and b.l_setup_date >= 20160101
   group by b.c_proj_code,b.c_proj_name,d.c_inst_name 
   order by b.c_proj_code,b.c_proj_name,d.c_inst_name;