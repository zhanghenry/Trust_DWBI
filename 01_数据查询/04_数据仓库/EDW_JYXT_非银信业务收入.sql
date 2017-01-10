-----------------------------------------------------------------非银信明细------------------------------------------------------------   
--不存在银信、直投施罗德   
SELECT sum(F_VALUE)
  FROM (SELECT b.c_proj_code,
               b.c_proj_name,
               round(sum(A.F_ACTUAL_EOT) / 10000, 2) AS F_VALUE
          FROM TT_SR_TSTREV_PROJ_M  A,
               DIM_PB_PROJECT_BASIC B,
               DIM_PB_PROJECT_BIZ   C
         WHERE A.L_PROJ_ID = B.L_PROJ_ID
           AND B.L_PROJ_ID = C.L_PROJ_ID
           AND SUBSTR(B.L_EFFECTIVE_DATE, 1, 6) <= A.L_MONTH_ID
           AND SUBSTR(B.L_EXPIRATION_DATE, 1, 6) > A.L_MONTH_ID
           AND B.C_PROJ_CODE <> 'E942'
           AND C.C_BUSI_SCOPE <> '3'
           and not exists
         (select 1
                  from tt_tc_fdsrc_proj_m   d,
                       dim_pb_project_basic e,
                       dim_tc_fund_source   f
                 where d.l_proj_id = e.l_proj_id
                   and d.l_fdsrc_id = f.l_fdsrc_id
                   and (f.c_fdsrc_code like '12%' or f.c_fdsrc_code = '113')
                   and b.c_proj_code = e.c_proj_code
                   and d.l_month_id = 201611)
           AND A.L_MONTH_ID = 201611
         group by b.c_proj_code, b.c_proj_name
        UNION ALL
        SELECT b.c_proj_code,
               b.c_proj_name,
               round(SUM(A.F_ACTUAL_EOT) / 10000, 2) AS F_VALUE
          FROM TT_SR_TSTREV_PROJ_M  A,
               DIM_PB_PROJECT_BASIC B,
               DIM_PB_PROJECT_BIZ   C
         WHERE A.L_PROJ_ID = B.L_PROJ_ID
           AND B.L_PROJ_ID = C.L_PROJ_ID
           AND SUBSTR(B.L_EFFECTIVE_DATE, 1, 6) <= A.L_MONTH_ID
           AND SUBSTR(B.L_EXPIRATION_DATE, 1, 6) > A.L_MONTH_ID
           AND (B.C_PROJ_CODE = 'E942' OR C.C_BUSI_SCOPE = '3')
           AND A.L_MONTH_ID = 201611
         group by b.c_proj_code, b.c_proj_name); 
        
--估值类项目            
SELECT b.c_proj_code,b.c_proj_name,SUM(A.F_ACTUAL_EOT) 
        FROM TT_SR_TSTREV_PROJ_M A,
               DIM_PB_PROJECT_BASIC B,
               DIM_PB_PROJECT_BIZ   C
         WHERE A.L_PROJ_ID = B.L_PROJ_ID
           AND B.L_PROJ_ID = C.L_PROJ_ID
           AND SUBSTR(B.L_EFFECTIVE_DATE,1,6) <= A.L_MONTH_ID
           AND SUBSTR(B.L_EXPIRATION_DATE,1,6) > A.L_MONTH_ID
           AND (B.C_PROJ_CODE = 'E942' OR C.C_BUSI_SCOPE = '3')
           AND B.L_EFFECTIVE_FLAG = 1
           AND A.L_MONTH_ID = 201606 
           group by b.c_proj_code,b.c_proj_name having sum(A.F_ACTUAL_EOT) <> 0;     