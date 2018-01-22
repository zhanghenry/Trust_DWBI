--项目信托收入
select b.c_proj_code  项目编码,
       b.c_proj_name  项目名称,
       b.d_setup      项目成立日期,
       存续信托报酬,
       存续信托财顾费,
       新增信托报酬,
       新增信托财顾费
  from tde_project b
  left outer join (select a.c_proj_code,
                          sum(case
                                when a.c_revstatus_code = 'EXIST' and
                                     a.c_revtype_code = 'XTBC' then
                                 a.f_revenue
                                else
                                 0
                              end) as 存续信托报酬,
                          sum(case
                                when a.c_revstatus_code = 'EXIST' and
                                     a.c_revtype_code = 'XTCGF' then
                                 a.f_revenue
                                else
                                 0
                              end) as 存续信托财顾费,
                          sum(case
                                when a.c_revstatus_code = 'NEW' and
                                     a.c_revtype_code = 'XTBC' then
                                 a.f_revenue
                                else
                                 0
                              end) as 新增信托报酬,
                          sum(case
                                when a.c_revstatus_code = 'NEW' and
                                     a.c_revtype_code = 'XTCGF' then
                                 a.f_revenue
                                else
                                 0
                              end) as 新增信托财顾费
                     from tde_revenue_change a
                    where a.d_revenue >= to_date('20160101', 'yyyymmdd')
                      and a.d_revenue <= to_date('20160930', 'yyyymmdd')
                    group by a.c_proj_code) t
    on t.c_proj_code = b.c_proj_code
 order by b.d_setup;