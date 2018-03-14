--存续规模差异
select t1.c_proj_code,
       t1.f_cxgm as 简表存续规模,
       t2.c_grain,
       t2.c_proj_name,
       t2.f_value as BI存续规模,
       nvl(t1.f_cxgm,0) - nvl(t2.f_value,0) as 差值
  from temp_20180222_01 t1
  full outer join temp_20180222_02 t2
    on t1.c_proj_code = t2.c_grain
 where nvl(t1.f_cxgm,0) <> nvl(t2.f_value,0);

--计划收入差异
select t1.c_proj_code,
       t1.f_xtsr as 简表合同收入,
       t1.f_xtbc as 简表信托报酬,
       t1.f_xtcgf as 简表财顾费,
       t2.c_proj_code,
       t2.c_proj_name,
       t2.f_xtsr as BI合同收入,
       t2.f_xtbc as BI信托报酬,
       t2.f_xtcgf as BI信托财顾费,
       t1.f_xtsr - t2.f_xtsr as 差值
  from temp_20180222_03 t1
  full outer join temp_20180222_04 t2
    on t1.c_proj_code = t2.c_proj_code
 where t1.f_xtsr <> t2.f_xtsr;
 
--本年清算规模差异
select t1.c_proj_code,
       t1.f_qsgm as 简表清算规模,
       t2.c_proj_code,
       t2.c_proj_name,
       t2.f_qsgm as BI清算规模,
       t1.f_qsgm - t2.f_qsgm as 差值
  from temp_20180222_05 t1
  full outer join temp_20180222_06 t2
    on t1.c_proj_code = t2.c_proj_code
 where t1.f_qsgm <> t2.f_qsgm;

--本年新增项目个数差异
select t1.c_proj_code,
       t2.c_proj_code  
       from temp_20180222_07 t1
  full outer join temp_20180222_08 t2
    on replace(t1.c_proj_code,'
','') = t2.c_proj_code
 where t1.c_proj_code is null or t2.c_proj_code is null;


--本年新增规模差异
select t1.c_proj_code,
       t1.f_xzgm as 简表新增规模,
       t2.c_proj_code,
       t2.c_proj_name,
       t2.f_xzgm as BI新增规模,
       nvl(t1.f_xzgm,0) - nvl(t2.f_xzgm,0) as 差值
  from temp_20180222_09 t1
  full outer join temp_20180222_10 t2
    on replace(t1.c_proj_code,'
','') = t2.c_proj_code
 where nvl(t1.f_xzgm,0) <> nvl(t2.f_xzgm,0);
