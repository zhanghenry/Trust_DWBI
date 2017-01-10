--以信托合同汇总项目存续规模
select a.*,b.c_invprod_code as 主产品编码,
       b.c_busi_scope as 业务范围,
       b.c_busi_scope_n as 业务范围名称,
       b.c_proj_type as 项目类型,
       b.c_proj_type_n as 项目类型名称,
       b.c_trust_type as 信托类型,
       b.c_trust_type_n as 信托类型名称,
       b.c_func_type as 功能类型,
       b.c_func_type_n as 功能类型名称, 
       b.c_property_type as 财产权类型,
       b.c_property_type_n as 财产权类型名称,
       b.c_coop_type as 合作类型,
       b.c_coop_type_n as 合作类型名称,
       b.c_invest_indus as 投向行业,
       b.c_invest_indus_n as 投向行业名称,
       b.c_invest_way as 投资方式,
       b.c_invest_way_n as 投资方式名称,
       b.c_invest_dir as 投资方向,
       b.c_invest_dir_n as 投资方向名称
        from (
select r.c_proj_code as 项目编码,
       r.c_proj_name as 项目名称,
       r.d_setup as 成立日期,
       r.d_expiring as 结束日期,
       r.c_phase_name,
       r.c_status_name,
       case
         when nvl(r.d_setup, to_date(20000101,'yyyymmdd')) > to_date('20151231','yyyymmdd') then
          '本年新增'
         else
          '往年成立'
       end as 成立情况,
       case
         when nvl(r.d_expiring, to_date(20991231,'yyyymmdd')) > to_date('20160531','yyyymmdd') then
          '当前存续'
         else
          '已经清算'
       end as 存续情况,
       sum(t.f_tshares) as 存续规模
  from tta_trust_order t, tde_product s, tde_project r
 where t.c_fundcode = s.c_prod_code
   and s.c_proj_code = r.c_proj_code /*and nvl(r.d_expiring, to_date(20991231,'yyyymmdd')) > to_date('20160531','yyyymmdd')*/
   and t.d_date <= to_date('20160531','yyyymmdd')
 group by r.c_proj_code,r.c_proj_name,r.d_setup,r.d_expiring,r.c_phase_name,
       r.c_status_name
 order by r.c_proj_code) a,tde_project b where a.项目编码=b.c_proj_code;
 

--有规模但无法关联产品
select *
  from (select t.c_prod_code,
               sum(case
                     when t.c_busi_type = '03' then
                      t.f_trade_share * -1
                     else
                      t.f_trade_share
                   end)
          from tta_trust_order t
         where t.c_busi_type in ('50', '02', '03')
         group by t.c_prod_code
        having sum(case
          when t.c_busi_type = '03' then
           t.f_trade_share * -1
          else
           t.f_trade_share
        end)<>0) s
 where not exists
 (select 1 from tde_product b where s.c_prod_code = b.c_prod_code);