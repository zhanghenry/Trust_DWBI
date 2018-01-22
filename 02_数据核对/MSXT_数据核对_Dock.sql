--收入--项目-日
select a.c_Proj_code as c_grain, sum(a.f_amount) as f_value
  from tde_ie_change a,tde_project b
 where a.c_proj_code = b.c_proj_code 
   and a.l_actual_flag = 0
   and a.l_recog_flag = 0
   and to_char(a.d_change, 'yyyy') = '2017'
   and (a.c_ie_cate in ('XTSR','TZSR') or (a.c_ietype_code in ('XTDLZF','XTFXBC''XTFXCGF')))
   and to_char(b.d_setup,'yyyymmdd') <= 20170731
 group by a.c_Proj_code;
 
--收入--项目-月
select a.c_Proj_code as c_grain, sum(a.f_amount) as f_value
  from tde_ie_change a, tde_stage b, tde_project c
 where a.c_stage_code = b.c_stage_code(+)
   and a.c_Proj_Code = c.c_proj_code
   and a.l_actual_flag = 0
   and a.l_recog_flag = 0
   and to_char(a.d_change, 'yyyy') = '2017'
   and (a.c_ie_cate in ('XTSR', 'TZSR') or
       (a.c_ietype_code in ('XTDLZF', 'XTFXBC''XTFXCGF')))
   and (to_char(b.d_setup, 'yyyymm') <= 201707 or
       (b.d_setup is null and to_char(c.d_setup, 'yyyymm') <= 201707))
 group by a.c_Proj_code;

--收入-信托收入-期次-日
select a.c_stage_code as c_grain,sum(case when a.c_ie_cate = 'XTSR' then a.f_amount when a.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_amount*-1 else 0 end) as f_value
  from tde_ie_change a,tde_stage b,tde_project c
 where a.c_stage_code  = b.c_stage_code 
   and b.c_proj_code = c.c_proj_code
   and c.c_busi_scope <> 0
   and a.l_actual_flag = 0
   and a.l_recog_flag = 0
   and to_char(a.d_change, 'yyyy') = '2017'
   and to_char(b.d_setup,'yyyymmdd') <= '20170731'
   group by a.c_stage_code;
   
--收入-信托收入-期次-月
select a.c_stage_code as c_grain,sum(case when a.c_ie_cate = 'XTSR' then a.f_amount when a.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_amount*-1 else 0 end) as f_value
  from tde_ie_change a,tde_stage b,tde_project c
 where a.c_stage_code  = b.c_stage_code 
   and b.c_proj_code = c.c_proj_code
   and c.c_busi_scope <> 0
   and a.l_actual_flag = 0
   and a.l_recog_flag = 0
   and to_char(a.d_change, 'yyyy') = '2017'
   and to_char(b.d_setup,'yyyymm') <= '201705' and c.c_proj_code = 'G403'
   group by a.c_stage_code;

--收入-自营收入-项目-日
select a.c_proj_code as c_grain, sum(a.f_amount) as f_value
  from tde_ie_change a, tde_project b
 where a.c_proj_code = b.c_proj_code
   and b.c_busi_scope = 0
   and a.l_actual_flag = 0
   and a.l_recog_flag = 0
   and a.c_ie_cate = 'TZSR'
   and to_char(a.d_change, 'yyyy') = '2017'
   and to_char(b.d_setup,'yyyymmdd') <= '20170731'
 group by a.c_proj_code;
 
--收入-自营收入-项目-月
select a.c_proj_code as c_grain, sum(a.f_amount) as f_value
  from tde_ie_change a, tde_project b
 where a.c_proj_code = b.c_proj_code
   and b.c_busi_scope = 0
   and a.l_actual_flag = 0
   and a.l_recog_flag = 0
   and a.c_ie_cate = 'TZSR'
   and to_char(a.d_change, 'yyyy') = '2017'
   and to_char(b.d_setup,'yyyymm') <= '201707'
 group by a.c_proj_code;

--收入-信托新增-日
select a.c_stage_code as c_grain,sum(case when a.c_ie_cate = 'XTSR' then a.f_amount when a.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_amount*-1 else 0 end) as f_value
  from tde_ie_change a,tde_project b,tde_stage c
 where a.c_proj_code  = b.c_proj_code 
   and a.c_stage_code = c.c_stage_code
   and b.c_busi_scope <> 0
   and a.l_actual_flag = 0
   and a.l_recog_flag = 0
   and to_char(c.d_setup,'yyyymmdd') <= '20170731'
   and to_char(c.d_setup,'yyyy') = '2017'
   and to_char(a.d_change, 'yyyy') = '2017' group by a.c_stage_code;
   
--收入-信托新增-月
select a.c_stage_code as c_grain,sum(case when a.c_ie_cate = 'XTSR' then a.f_amount when a.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_amount*-1 else 0 end) as f_value
  from tde_ie_change a,tde_project b,tde_stage c
 where a.c_proj_code  = b.c_proj_code 
   and a.c_stage_code = c.c_stage_code
   and b.c_busi_scope <> 0
   and a.l_actual_flag = 0
   and a.l_recog_flag = 0
   and to_char(c.d_setup,'yyyymm') <= '201707'
   and to_char(c.d_setup,'yyyy') = '2017'
   and to_char(a.d_change, 'yyyy') = '2017' group by a.c_stage_code;

--信托分成后收入-日-部门-期次
select tt.c_stage_code,
       sum((tt.d_expiration - tt.d_effective + 1) / (tt.d_expiration_max - tt.d_effective_min + 1) * tt.f_divide_rate * tt.f_sr)
  from (select greatest(d_effective, d_effective_min) as d_effective,
               least(nvl(d_expiration,
                         to_date(:C_YEAR || '1231', 'yyyymmdd')),
                     d_expiration_max) as d_expiration,
               c.d_effective_min,
               c.d_expiration_max,
               b.f_divide_rate,
               a.c_stage_code,
               case when a.c_ie_cate = 'XTSR' then a.f_amount when a.c_ietype_code in ('XTFXBC', 'XTFXCGF', 'TZZYFX') then a.f_amount * -1 else 0 end as f_sr
          from tde_ie_change a,
               tde_divide_scheme b,
               ((select t.c_divide_code as c_stage_code,
                        min(t.d_effective) as d_effective_min,
                        nvl(max(t.d_expiration), to_date(:C_YEAR || '1231', 'yyyymmdd')) as d_expiration_max
                   from tde_divide_scheme t
                  where t.c_scheme_type = 'QC'
                    and t.c_object_type = 'BM'
                    and (to_char(t.d_expiration, 'yyyy') >= :C_YEAR or t.d_expiration is null)
                    and to_char(t.d_effective, 'yyyy') <= :C_YEAR
                  group by t.c_divide_code)) c,
               tde_stage d
         where a.c_stage_code = b.c_divide_code
           and a.c_stage_code = c.c_stage_code
           and a.c_stage_code = d.c_stage_code
           and b.c_scheme_type = 'QC'
           and b.c_object_type = 'BM'
           and a.l_actual_flag = 0
           and a.l_recog_flag = 0
           and to_char(d.d_setup, 'yyyymmdd') <= :C_DAY
           and to_char(a.d_change, 'yyyy') = :C_YEAR) tt
 group by tt.c_stage_code;
 
--信托分成后收入-日-员工-期次
select tt.c_stage_code,
       sum((tt.d_expiration - tt.d_effective + 1) / (tt.d_expiration_max - tt.d_effective_min + 1) * tt.f_divide_rate * tt.f_sr)
  from (select greatest(d_effective, d_effective_min) as d_effective,
               least(nvl(d_expiration,
                         to_date(:C_YEAR || '1231', 'yyyymmdd')),
                     d_expiration_max) as d_expiration,
               c.d_effective_min,
               c.d_expiration_max,
               b.f_divide_rate,
               a.c_stage_code,
               case when a.c_ie_cate = 'XTSR' then a.f_amount when a.c_ietype_code in ('XTFXBC', 'XTFXCGF', 'TZZYFX') then a.f_amount * -1 else 0 end as f_sr
          from tde_ie_change a,
               tde_divide_scheme b,
               ((select t.c_divide_code as c_stage_code,
                        min(t.d_effective) as d_effective_min,
                        nvl(max(t.d_expiration), to_date(:C_YEAR || '1231', 'yyyymmdd')) as d_expiration_max
                   from tde_divide_scheme t
                  where t.c_scheme_type = 'QC'
                    and t.c_object_type = 'YG'
                    and (to_char(t.d_expiration, 'yyyy') >= :C_YEAR or t.d_expiration is null)
                    and to_char(t.d_effective, 'yyyy') <= :C_YEAR
                  group by t.c_divide_code)) c,
               tde_stage d
         where a.c_stage_code = b.c_divide_code
           and a.c_stage_code = c.c_stage_code
           and a.c_stage_code = d.c_stage_code
           and b.c_scheme_type = 'QC'
           and b.c_object_type = 'YG'
           and a.l_actual_flag = 0
           and a.l_recog_flag = 0
           and to_char(d.d_setup, 'yyyymmdd') <= :C_DAY
           and to_char(a.d_change, 'yyyy') = :C_YEAR) tt
 group by tt.c_stage_code;

--收入-信托存续
select a.c_stage_code as c_grain,sum(case when a.c_ie_cate = 'XTSR' then a.f_amount when a.c_ietype_code in ('XTFXBC','XTFXCGF','TZZYFX') then a.f_amount*-1 else 0 end) as f_value
  from tde_ie_change a,tde_project b,tde_stage c
 where a.c_proj_code  = b.c_proj_code 
   and a.c_stage_code = c.c_stage_code
   and b.c_busi_scope <> 0
   and a.l_actual_flag = 0
   and a.l_recog_flag = 0
   and to_char(c.d_setup,'yyyy') < '2017'
   and to_char(a.d_change, 'yyyy') = '2017' group by a.c_stage_code;
   
--规模-时点-日
select b.c_stage_code as c_grain, sum(a.f_scale) as f_value
  from datadock.tde_scale_change a,
       datadock.tde_stage        b,
       datadock.tde_project      c
 where a.c_stage_code = b.c_stage_code
   and b.c_proj_code = c.c_proj_code
   and to_char(a.d_change, 'yyyymmdd') <= '20170731'
 group by b.c_stage_code;

--规模-时点-月
select b.c_stage_code as c_grain, sum(a.f_scale) as f_value
  from datadock.tde_scale_change a,
       datadock.tde_stage        b,
       datadock.tde_project      c
 where a.c_stage_code = b.c_stage_code
   and b.c_proj_code = c.c_proj_code
   and to_char(a.d_change, 'yyyymm') <= '201707'
 group by b.c_stage_code;
 
--规模-信托-日
select b.c_stage_code as c_grain, sum(a.f_scale) as f_value
  from datadock.tde_scale_change a,
       datadock.tde_stage        b,
       datadock.tde_project      c
 where a.c_stage_code = b.c_stage_code
   and b.c_proj_code = c.c_proj_code
   and c.c_busi_scope = '1'
   and to_char(a.d_change, 'yyyymmdd') <= '20170731'
 group by b.c_stage_code;
 
--规模-信托-月
select b.c_stage_code as c_grain, sum(a.f_scale) as f_value
  from datadock.tde_scale_change a,
       datadock.tde_stage        b,
       datadock.tde_project      c
 where a.c_stage_code = b.c_stage_code
   and b.c_proj_code = c.c_proj_code
   and c.c_busi_scope = '1'
   and to_char(a.d_change, 'yyyymm') <= '201707'
 group by b.c_stage_code;

--规模-基金-日
select b.c_stage_code as c_grain, sum(a.f_scale) as f_value
  from datadock.tde_scale_change a,
       datadock.tde_stage        b,
       datadock.tde_project      c
 where a.c_stage_code = b.c_stage_code
   and b.c_proj_code = c.c_proj_code
   and c.c_busi_scope = '2'
   and to_char(a.d_change, 'yyyymmdd') <= '20170731'
 group by b.c_stage_code;
 
--规模-基金-月
select b.c_stage_code as c_grain, sum(a.f_scale) as f_value
  from datadock.tde_scale_change a,
       datadock.tde_stage        b,
       datadock.tde_project      c
 where a.c_stage_code = b.c_stage_code
   and b.c_proj_code = c.c_proj_code
   and c.c_busi_scope = '2'
   and to_char(a.d_change, 'yyyymm') <= '201707'
 group by b.c_stage_code;

--规模-主动-日
select b.c_stage_code as c_grain, sum(a.f_scale) as f_value
  from datadock.tde_scale_change a,
       datadock.tde_stage        b,
       datadock.tde_project      c
 where a.c_stage_code = b.c_stage_code
   and b.c_proj_code = c.c_proj_code
   and c.c_manage_type = '1'
   and to_char(a.d_change, 'yyyymmdd') <= '20170731'
 group by b.c_stage_code;
 
--规模-主动-月
select b.c_stage_code as c_grain, sum(a.f_scale) as f_value
  from datadock.tde_scale_change a,
       datadock.tde_stage        b,
       datadock.tde_project      c
 where a.c_stage_code = b.c_stage_code
   and b.c_proj_code = c.c_proj_code
   and c.c_manage_type = '1'
   and to_char(a.d_change, 'yyyymm') <= '201707'
 group by b.c_stage_code;

--规模-被动-日
select b.c_stage_code as c_grain, sum(a.f_scale) as f_value
  from datadock.tde_scale_change a,
       datadock.tde_stage        b,
       datadock.tde_project      c
 where a.c_stage_code = b.c_stage_code
   and b.c_proj_code = c.c_proj_code
   and c.c_manage_type <> '1'
   and to_char(a.d_change, 'yyyymmdd') <= '20170731'
 group by b.c_stage_code;
 
--规模-被动-月
select b.c_stage_code as c_grain, sum(a.f_scale) as f_value
  from datadock.tde_scale_change a,
       datadock.tde_stage        b,
       datadock.tde_project      c
 where a.c_stage_code = b.c_stage_code
   and b.c_proj_code = c.c_proj_code
   and c.c_manage_type <> '1'
   and to_char(a.d_change, 'yyyymm') <= '201707'
 group by b.c_stage_code;
 
--分成后规模-日-部门-期次
select tt.c_stage_code,
       sum((tt.d_expiration - tt.d_effective + 1) / (tt.d_expiration_max - tt.d_effective_min + 1) * tt.f_divide_rate * tt.f_scale)
  from (select greatest(d_effective, d_effective_min) as d_effective,
               least(nvl(d_expiration, to_date('2017' || '1231', 'yyyymmdd')), d_expiration_max) as d_expiration,
               c.d_effective_min,
               c.d_expiration_max,
               b.f_divide_rate,
               a.c_stage_code,
               a.f_scale
          from tde_scale_change a,
               tde_divide_scheme b,
               (select t.c_divide_code as c_stage_code,
                       min(t.d_effective) as d_effective_min,
                       nvl(max(t.d_expiration), to_date('2017' || '1231', 'yyyymmdd')) as d_expiration_max
                  from tde_divide_scheme t
                 where t.c_scheme_type = 'QC'
                   and t.c_object_type = 'BM'
                   and (to_char(t.d_expiration, 'yyyy') >= '2017' or t.d_expiration is null)
                   and to_char(t.d_effective, 'yyyy') <= '2017'
                 group by t.c_divide_code) c
         where a.c_stage_code = b.c_divide_code
           and a.c_stage_code = c.c_stage_code
           and b.c_scheme_type = 'QC'
           and b.c_object_type = 'BM'
           and to_char(a.d_change, 'yyyymmdd') <= '20170731') tt
 group by tt.c_stage_code;
   
--分成后规模-日-员工-期次
select tt.c_stage_code,
       sum((tt.d_expiration - tt.d_effective + 1) / (tt.d_expiration_max - tt.d_effective_min + 1) * tt.f_divide_rate * tt.f_scale)
  from (select greatest(b.d_effective, d_effective_min) as d_effective,
               least(nvl(b.d_expiration, to_date('2017' || '1231', 'yyyymmdd')), d_expiration_max) as d_expiration,
               c.d_effective_min,
               c.d_expiration_max,
               b.f_divide_rate,
               a.c_stage_code,
               a.f_scale
          from tde_scale_change a,
               tde_divide_scheme b,
               (select t.c_divide_code as c_stage_code,
                       min(t.d_effective) as d_effective_min,
                       nvl(max(t.d_expiration), to_date('2017' || '1231', 'yyyymmdd')) as d_expiration_max
                  from tde_divide_scheme t
                 where t.c_scheme_type = 'QC'
                   and t.c_object_type = 'YG'
                   and (to_char(t.d_expiration, 'yyyy') >= '2017' or t.d_expiration is null)
                   and to_char(t.d_effective, 'yyyy') <= '2017'
                 group by t.c_divide_code) c
         where a.c_stage_code = b.c_divide_code
           and a.c_stage_code = c.c_stage_code
           and b.c_scheme_type = 'QC'
           and b.c_object_type = 'YG'
           and to_char(a.d_change, 'yyyymmdd') <= '20170731') tt where tt.c_stage_code = 'F217-5'
 group by tt.c_stage_code;
 
select * from tde_scale_change t where t.c_stage_code = 'F217-5';
select * from tde_divide_scheme t where t.c_divide_code = 'F217-5';
 
--弹性费用-部门-日
select a.c_object_code as c_grain, sum(a.f_amount) as f_value
  from datadock.tfi_voucher a, datadock.tde_department b
 where a.c_object_code = b.c_dept_code
   and (a.c_subj_code like '660102%' or a.c_subj_code like '66010301%' or a.c_subj_code like '66010302%')
   and a.c_object_type = 'BM'
   and a.l_fiscal_year = 2017
   and to_char(a.d_business,'yyyymmdd') <= 20170731
 group by a.c_object_code;

--弹性费用-部门-月
select a.c_object_code as c_grain, sum(a.f_amount) as f_value
  from datadock.tfi_voucher a, datadock.tde_department b
 where a.c_object_code = b.c_dept_code
   and (a.c_subj_code like '660102%' or a.c_subj_code like '66010301%' or a.c_subj_code like '66010302%')
   and a.c_object_type = 'BM'
   and a.l_fiscal_year = 2017
   and to_char(a.d_business,'yyyymm') <= 201706
 group by a.c_object_code;

--公共费用-部门-日
select a.c_object_code as c_grain, sum(a.f_amount) as f_value
  from datadock.tfi_voucher a, datadock.tde_department b
 where a.c_object_code = b.c_dept_code
   and (a.c_subj_code like '660102%' or a.c_subj_code like '660103%' or a.c_subj_code like '660104%')
   and a.c_object_type = 'BM'
   and b.c_dept_cate = '5'
   and a.l_fiscal_year = 2017
   and to_char(a.d_business,'yyyymmdd') <= 20170731
 group by a.c_object_code;

--公共费用-部门-月
select a.c_object_code as c_grain, sum(a.f_amount) as f_value
  from datadock.tfi_voucher a, datadock.tde_department b
 where a.c_object_code = b.c_dept_code
   and (a.c_subj_code like '660102%' or a.c_subj_code like '660103%' or a.c_subj_code like '660104%')
   and a.c_object_type = 'BM'
   and b.c_dept_cate = '5'
   and a.l_fiscal_year = 2017
   and to_char(a.d_business,'yyyymm') <= 201707
 group by a.c_object_code;
 
--项目个数-项目-日
select a.c_proj_code as c_grain, count(*) as f_value
  from datadock.tde_project a
 where to_char(a.d_setup, 'yyyymmdd') <= '20170731'
   and a.c_busi_scope <> '0'
 group by a.c_proj_code;
 
--项目个数-项目-月
select a.c_proj_code as c_grain, count(*) as f_value
  from datadock.tde_project a
 where to_char(a.d_setup, 'yyyymm') <= '201707'
   and a.c_busi_scope <> '0'
 group by a.c_proj_code;

--期次个数-期次-日
select a.c_stage_code as c_grain, count(*) as f_value
  from datadock.tde_stage a
  where to_char(a.d_setup,'yyyymmdd') <= '20170731'
 group by a.c_stage_code;
 
--期次个数-期次-月
select a.c_stage_code as c_grain, count(*) as f_value
  from datadock.tde_stage a
  where to_char(a.d_setup,'yyyymm') <= '201707'
 group by a.c_stage_code;

